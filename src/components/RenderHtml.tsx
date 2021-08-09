import React from "react";
import Children from "react-children-utilities";
import Head from "next/head";
import { Parser as HtmlToReactParser } from "html-to-react";

type Components = Readonly<{
	[key: string]: React.ComponentType<any>;
}>;

type RenderProps = Readonly<{
	html: string;
	components: Components;
}>;

export const RenderHtml: React.VFC<RenderProps> = ({ html, components }) => {
	const root = parse(html);
	if(root === undefined)
		return null;
	const heads = Children
		.deepFilter(root, match("head"))
		.map(p => upgrade(Head, p));
	const body = Children.deepFind(root, match("body"));
	if(!Children.hasChildren(body))
		return <>{heads}</>;
	const contents = Children.deepMap(body.props.children, p => {
		if(!React.isValidElement(p))
			return p;
		if(typeof p.type !== "string")
			return p;
		const c = components[p.type];
		if(c === undefined)
			return p;
		return upgrade(c, p);
	});
	return <>{[...heads, ...contents]}</>;
}

function parse(html: string): React.ReactElement | undefined {
	const parser = new HtmlToReactParser();
	return parser.parse(html).filter(isElement).find(match("html"))
}

function isElement(p: React.ReactElement | string): p is React.ReactElement {
	return typeof p !== "string";
}

function match(tagName: string): (p: React.ReactNode) => boolean {
	return (p: React.ReactNode): boolean => {
		if(!React.isValidElement(p))
			return false;
		return p.type === tagName;
	};
}

function upgrade(c: React.ComponentType<any>, e: React.ReactNode): React.ReactElement {
	if(Children.hasChildren(e))
		return React.createElement(c, e.props, e.props.children);
	if(React.isValidElement(e))
		return React.createElement(c, e.props);
	return React.createElement(c, {});
}
