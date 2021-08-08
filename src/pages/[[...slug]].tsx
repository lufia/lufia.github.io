import {
	promises as fs,
	createReadStream,
} from "fs";
import glob from "glob";
import {
	GetStaticPaths,
	GetStaticPropsContext,
	InferGetStaticPropsType,
	NextPage,
} from "next";
import path from "path";
import { pipeline } from "stream/promises";
import { promisify } from "util";
import { convertToHtml, include, createWriteStream } from "../html-generator";
import { optimize, parse } from "../react-node-optimizer";
import { findUp, getProjectDir, stat } from "../path";

const globAsync = promisify(glob);

type Params = Readonly<{
	// BUG?: pass {slug:[]} then getStaticProps receives undefined from context.
	slug: string[] | undefined;
}>;

export const getStaticPaths: GetStaticPaths<Params> = async () => {
	const projectDir = await getProjectDir(fs);
	const files = await globAsync("**/*.w", {
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
	const queryPath = path.join(...slug);
	const info = await getPathInfo(queryPath);

	const includeDir = await lookupIncludeDir(info.file);
	const f = createReadStream(info.file, "utf-8");
	const { stream: w, result } = createWriteStream();
	await pipeline(f, include(includeDir), convertToHtml({
		lang: "ja",
		extensions: {
			"map": "svg",
			"w": "html",
		},
	}), w);
	return {
		props: {
			message: result(),
			pathname: "/[[...slug]]",
			urlPath: info.urlPath,
		},
	};
};

type PathInfo = Readonly<{
	file: string;
	urlPath: string;
}>;

async function getPathInfo(queryPath: string): Promise<PathInfo> {
	const projectDir = await getProjectDir(fs);
	const candidate = path.join(projectDir, queryPath);
	const s = await stat(fs, candidate);
	if(s && s.isDirectory())
		return {
			file: path.join(candidate, "index.w"),
			urlPath: `/${queryPath}/`,
		};
	const dir = path.dirname(candidate);
	const base = path.basename(candidate, ".html");
	return {
		file: path.join(dir, base + ".w"),
		urlPath: `/${queryPath}`,
	};
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

const Page: NextPage<Props> = (props) => {
	const node = parse(props.message);
	return <>{optimize({
		node,
		pathname: props.pathname,
		urlPath: props.urlPath,
	})}</>;
};

export default Page;
