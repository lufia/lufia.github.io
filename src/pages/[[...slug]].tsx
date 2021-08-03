import {
	promises as fs,
	createReadStream,
} from "fs";
import {
	GetStaticPaths,
	GetStaticPropsContext,
	InferGetStaticPropsType,
	NextPage,
} from "next";
import path from "path";
import { convertToHtml, include } from "../html-generator";
import { optimize, parse } from "../react-node-optimizer";
import { findUp, getProjectDir, stat } from "../path";

type Params = Readonly<{
	slug: string[] | undefined;
}>;

export const getStaticPaths: GetStaticPaths<Params> = async () => {
	return {
		paths: [
			// BUG?: pass {slug:[]} then getStaticProps receives undefined from context.
			{ params: { slug: undefined } },
			{ params: { slug: ["estpolis"] } },
			{ params: { slug: ["estpolis", "story", "ch1.html"] } },
		],
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
	const stream = f.pipe(include(includeDir)).pipe(convertToHtml({
		lang: "ja",
		extensions: { "w": "html" },
	}));
	const data: string[] = [];
	for await (const s of stream) {
		data.push(s)
	}
	return {
		props: {
			message: data.join(""),
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
