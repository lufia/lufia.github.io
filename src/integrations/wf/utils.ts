import type { AstroConfig, SSRError } from 'astro';
import matter from 'gray-matter';

/*
 * below codes was imported from astro/packages/integrations/mdx/src/utils.ts
 */

function appendForwardSlash(path: string) {
	return path.endsWith('/') ? path : path + '/';
}

interface FileInfo {
	fileId: string;
	fileUrl: string;
}

export function getFileInfo(id: string, config: AstroConfig): FileInfo {
	const sitePathname = appendForwardSlash(
		config.site ? new URL(config.base, config.site).pathname : config.base
	);

	// Try to grab the file's actual URL
	let url: URL | undefined = undefined;
	try {
		url = new URL(`file://${id}`);
	} catch {}

	const fileId = id.split('?')[0];
	let fileUrl: string;
	const isPage = fileId.includes('/pages/');
	if (isPage) {
		fileUrl = fileId.replace(/^.*?\/pages\//, sitePathname).replace(/(\/index)?\.wf$/, '');
	} else if (url?.pathname.startsWith(config.root.pathname)) {
		fileUrl = url.pathname.slice(config.root.pathname.length);
	} else {
		fileUrl = fileId;
	}

	if (fileUrl && config.trailingSlash === 'always') {
		fileUrl = appendForwardSlash(fileUrl);
	}
	return { fileId, fileUrl };
}

export function parseFrontmatter(code: string, id: string) {
	try {
		return matter(code);
	} catch (e: any) {
		if (e.name === 'YAMLException') {
			const err: SSRError = e;
			err.id = id;
			err.loc = { file: e.id, line: e.mark.line + 1, column: e.mark.column };
			err.message = e.reason;
			throw err;
		} else {
			throw e;
		}
	}
}
