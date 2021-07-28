import { createReadStream } from "fs";
import {
	GetStaticPaths,
	GetStaticPropsContext,
	InferGetStaticPropsType,
	NextPage,
} from "next";
import { Parser as HtmlToReactParser } from "html-to-react";
import { convertToHtml, include } from "../html-generator";

type Params = Readonly<{
	id: string;
}>;

export const getStaticPaths: GetStaticPaths<Params> = async () => {
	return {
		paths: [
			{
				params: { id: "index" },
			},
		],
		fallback: false,
	};
};

type Props = InferGetStaticPropsType<typeof getStaticProps>;

export const getStaticProps = async (context: GetStaticPropsContext) => {
	const { params } = context;
	const f = createReadStream(params.id + ".w", "utf-8");
	const stream = f.pipe(include()).pipe(convertToHtml({
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
		},
	};
};

const Page: NextPage<Props> = (props) => {
	const parser = new HtmlToReactParser();
	const html = parser.parse(props.message);
	return html;
};

export default Page;
