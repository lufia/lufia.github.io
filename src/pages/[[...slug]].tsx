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
import { pipeline } from "stream/promises";
import { convertToHtml, include, createWriteStream } from "../html-generator";
import { optimize, parse } from "../react-node-optimizer";
import { findUp, getProjectDir, stat, walk } from "../path";

type Params = Readonly<{
	// BUG?: pass {slug:[]} then getStaticProps receives undefined from context.
	slug: string[] | undefined;
}>;

const targetDirs = [
	{ dir: ".", recursive: false },
	{ dir: "estpolis", recursive: true },
	{ dir: "notes", recursive: true },
	{ dir: "plan9", recursive: true },
	{ dir: "pkg", recursive: true },
] as const;

export const getStaticPaths: GetStaticPaths<Params> = async () => {
	const projectDir = await getProjectDir(fs);
	const files: string[] = [];
	for(const p of targetDirs){
		const dir = path.join(projectDir, p.dir);
		await walk(fs, dir, file => {
			const r = path.relative(projectDir, file);
			if(path.normalize(r) === "index.w")
				files.push(""); // avoid set to '.'
			else if(path.extname(r) === ".w"){
				const d = path.dirname(r);
				const f = path.basename(r, ".w");
				files.push(path.join(d, f));
			}
		}, p.recursive);
	}
	const paths = files.map(file => ({
		params: {
			slug: file.split(path.sep),
		},
	}));
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
		extensions: { "w": "html" },
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
