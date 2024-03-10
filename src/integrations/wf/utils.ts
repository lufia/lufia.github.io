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
}

export function getFileInfo(id: string, config: AstroConfig): FileInfo {
	const fileId = id.split('?')[0];
	return { fileId };
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
