import React from "react";
import NextLink from "next/link";
import { useRouter } from "next/router";
import { combineAsUrl, hasScheme } from "../path";

type LinkProps = Readonly<{
	href: string;
	children: React.ReactNode;
}>;

export const Link: React.VFC<LinkProps> = ({ href, children }) => {
	const router = useRouter();
	if(hasScheme(href))
		return <a href={href}>{children}</a>;
	const asPath = combineAsUrl(router.asPath, href);
	return (
		<NextLink href="/[[...slug]]" as={asPath}>
			<a>{children}</a>
		</NextLink>
	);
};
