import React from "react";
import Head from "next/head";
import { Parser as HtmlToReactParser } from "html-to-react";

// <head> to <Head>
// <a href="xxx"> to <Link href="xxx"><a>
// <img> to ?

export function parse(content: string): React.ReactNode {
	const parser = new HtmlToReactParser();
	return parser.parse(content);
}

export function optimize(node: React.ReactNode): React.ReactNode {
	const root = React.createElement("root", null, node);
	const html = getElement(root, "html");
	if(!html)
		return node;
	let body = getElement(html, "body");
	const heads = getElements(html, "head")
		.map(p => React.createElement(Head, p.props, p.props.children));
	const n = React.cloneElement(body, {}, heads, body.props.children);
	return n.props.children;
}

function getElement(e: React.ReactElement, tagName: string): React.ReactElement {
	const a = getElements(e, tagName);
	if(a.length === 0)
		return null;
	return a[0];
}

function getElements(e: React.ReactElement, tagName: string): readonly React.ReactElement[] {
	// https://dackdive.hateblo.jp/entry/2019/08/07/090000
	if(typeof e === "number" || typeof e === "string")
		return [];

	const a: React.ReactElement[] = [];
	React.Children.forEach(e.props.children, p => {
		if(p.type === tagName)
			a.push(p);
		const children = getElements(p, tagName);
		for(const c of children)
			a.push(c);
	});
	return a;
}
