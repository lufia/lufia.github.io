import React from "react";
import Head from "next/head";
import Link from "next/link";
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
	return optimizeLinks(n).props.children;
}

function optimizeLinks(e: React.ReactElement): React.ReactElement {
	if(isPrimitive(e))
		return e;
	const a = React.Children.map(e.props.children, p => {
		if(p.type === "a"){
			const e = React.createElement("a", {}, p.props.children);
			return React.createElement(Link, p.props, e);
		}
		return optimizeLinks(p);
	});
	return React.cloneElement(e, {}, a);
}

function getElements(e: React.ReactElement, tagName: string): readonly React.ReactElement[] {
	if(isPrimitive(e))
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

// TODO: bug??
function isPrimitive(e: React.ReactElement): boolean {
	return typeof e === "string";
}

function getElement(e: React.ReactElement, tagName: string): React.ReactElement {
	const a = getElements(e, tagName);
	if(a.length === 0)
		return null;
	return a[0];
}
