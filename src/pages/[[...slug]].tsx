import {
	promises as fs,
	createReadStream,
} from "fs";
import { glob } from "glob";
import {
	GetStaticPaths,
	GetStaticPropsContext,
	InferGetStaticPropsType,
	NextPage,
} from "next";
import path from "path";
import { pipeline } from "stream/promises";
import {
	convertToHtml,
	include,
	WritableMemoryStream,
} from "../html-generator";
import { findUp, getProjectDir, stat } from "../path";
import { Link, RenderHtml } from "../components";

type Params = Readonly<{
	// BUG?: pass {slug:[]} then getStaticProps receives undefined from context.
	slug: string[] | undefined;
}>;

export const getStaticPaths: GetStaticPaths<Params> = async () => {
	const projectDir = await getProjectDir(fs);
	const files = await glob("**/*.w", {
		cwd: projectDir,
	});
	const paths = files.map(s => {
		if(path.normalize(s) === "index.w"){
			return {
				params: { slug: undefined },
			};
		}
		const dir = path.dirname(s);
		const name = path.basename(s, ".w");
		return {
			params: { slug: dir.split(path.sep).concat(name) }
		};
	});
	return {
		paths,
		fallback: false,
	};
};

type Props = InferGetStaticPropsType<typeof getStaticProps>;

export const getStaticProps = async (context: GetStaticPropsContext<Params>) => {
	const { params } = context;
	const slug = params.slug || [];
	const asPath = path.join(...slug);
	const file = await getSourcePath(asPath);

	const includeDir = await lookupIncludeDir(file);
	const f = createReadStream(file, "utf-8");
	const w = new WritableMemoryStream();
	await pipeline(f, include(includeDir), convertToHtml({
		lang: "ja",
		extensions: {
			"map": "svg",
			"w": "html",
		},
	}), w);
	return {
		props: {
			html: w.toString(),
		},
	};
};

async function getSourcePath(asPath: string): Promise<string> {
	const projectDir = await getProjectDir(fs);
	const candidate = path.join(projectDir, asPath);
	const s = await stat(fs, candidate);
	if(s && s.isDirectory())
		return path.join(candidate, "index.w");
	const dir = path.dirname(candidate);
	const base = path.basename(candidate, ".html");
	return path.join(dir, base + ".w");
}

async function lookupIncludeDir(file: string): Promise<string | undefined> {
	const dir = path.dirname(file);
	return findUp(dir, async dir => {
		const d = path.join(dir, "include");
		const s = await stat(fs, d);
		if(s && s.isDirectory())
			return d;
		return undefined;
	});
}

const components = {
	"a": Link,
};

const Page: NextPage<Props> = ({ html }) => {
	return <RenderHtml html={html} components={components} />;
};

export default Page;
