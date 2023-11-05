import type { AstroConfig, AstroIntegration, ContentEntryType, HookParameters } from 'astro';
import fs from 'node:fs/promises';
import matter from 'gray-matter';
import type { Plugin as VitePlugin } from 'vite';

// document: https://docs.astro.build/ja/reference/integrations-reference/

type SetupHookParams = HookParameters<'astro:config:setup'> & {
	// `addPageExtension` and `contentEntryType` are not a public APIs
	// Add type defs here
	addPageExtension: (extension: string) => void;
	addContentEntryType: (contentEntryType: ContentEntryType) => void;
};

export default function wf(): AstroIntegration {
	return {
		name: 'lufia/wf',
		hooks: {
			'astro:config:setup': async (params) => {
				const {
					updateConfig,
					config,
					addPageExtension,
					addContentEntryType,
				} = params as SetupHookParams;
				addPageExtension('.wf');
				addContentEntryType({
					extensions: ['.wf'],
					async getEntryInfo({ fileUrl, contents }: { fileUrl: URL; contents: string }) {
						const parsed = parseFrontmatter(contents, fileURLToPath(fileUrl));
						return {
							data: parsed.data,
							body: parsed.content,
							slug: parsed.data.slug,
							rawData: parsed.matter,
						};
					},
					//contentModuleTypes: await fs.readFile(
					//	new URL('../template/content-module-types.d.ts', import.meta.url),
					//	'utf-8'
					//),
				});
				updateConfig({
					vite: {
						plugins: [
							{
								name: 'xxxx',
								async transform(_, id) {
									if(!id.endsWith('.wf'))
										return;
									const { fileId } = getFileInfo(id, config);
									const code = await fs.readFile(fileId, 'utf-8');
									const { data: frontmatter, content: pageContent } = parseFrontmatter(code, id);
									return { code: "{ console.log('aaa') }", map: null };
								},
							},
						] as VitePlugin[],
					},
				});
			},
		},
	};
}

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

function getFileInfo(id: string, config: AstroConfig): FileInfo {
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

function parseFrontmatter(code: string, id: string) {
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
