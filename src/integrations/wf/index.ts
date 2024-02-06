import type {
	AstroIntegration,
	ContentEntryType,
	HookParameters,
} from 'astro';
import fs from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'path';
import type { Plugin as VitePlugin } from 'vite';
import { Readable } from 'stream';
import { pipeline } from 'stream/promises';
import {
    convertToHtml,
    WritableMemoryStream,
} from '../../html-generator';
import { getFileInfo, parseFrontmatter } from './utils.ts';

type SetupHookParams = HookParameters<'astro:config:setup'> & Readonly<{
	// `addPageExtension` and `contentEntryType` are not a public APIs
	// Add type defs here
	addPageExtension: (extension: string) => void;
	addContentEntryType: (contentEntryType: ContentEntryType) => void;
}>;

export default function wf(): AstroIntegration {
	return {
		name: 'integrations/wf',
		hooks: {
			'astro:config:setup': async (params) => {
				const {
					updateConfig,
					config,
					addPageExtension,
					addContentEntryType,
				} = params as SetupHookParams;
				addPageExtension('.w');
				addContentEntryType({
					extensions: ['.w'],
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
								name: 'vite-plugin-wf',
								async transform(_, id) {
									if(!id.endsWith('.w'))
										return;
									const { fileId } = getFileInfo(id, config);
									const code = await fs.readFile(fileId, 'utf-8');
									const {
										data: params,
										content: pageContent,
									} = parseFrontmatter(code, id);
									const frontmatter: Frontmatter = {
										title: params.title,
										style: params.style!,
										pre: params.pre,
										post: params.post,
									}
									const data = await layout(id, pageContent, frontmatter);
									const html = await convert(data);
									return {
										code: generateCode(html, frontmatter.style),
										map: null
									};
								},
							},
						] as VitePlugin[],
					},
				});
			},
		},
	};
}

type Frontmatter = Readonly<{
	title: string | undefined;
	style: string;
	pre: string | undefined;
	post: string | undefined;
}>;

async function layout(file: string, pageContent: string, frontmatter: Frontmatter): Promise<string> {
	const dir = path.dirname(file);
	let s = '';
	if(frontmatter.pre !== undefined){
		try{
			const pre = await fs.readFile(path.join(dir, frontmatter.pre));
			s += pre;
		}catch(err: any){
			if(err.code !== 'ENOENT')
				throw err;
		}
	}
	if(frontmatter.title !== undefined)
		s += '%title '+frontmatter.title+'\n';
	s += pageContent;
	if(frontmatter.post !== undefined){
		try{
			const post = await fs.readFile(path.join(dir, frontmatter.post));
			s += post;
		}catch(err: any){
			if(err.code !== 'ENOENT')
				throw err;
		}
	}
	return s;
}

async function convert(data: string): Promise<string> {
	//const f = createReadStream(file, 'utf-8');
	const f = Readable.from([data]);
	const w = new WritableMemoryStream();
	await pipeline(f, convertToHtml({
		lang: 'ja',
		extensions: {
			map: 'svg',
			w: 'html',
		},
	}), w);
	return w.toString();
}

function generateCode(html: string, style: string): string {
	const code = `
	import css from '${style}?inline'\n
	const html = \`${rawString(html)}\`\n
	const content = html.replace('</head>', '<style>\\n'+css+'\\n</style>\\n</head>')\n
	export default function render() {\n
		return content\n
	}\n
	render['astro:html'] = true\n
	render[Symbol.for("astro.needsHeadRendering")] = false\n
	`;
	return code;
}

function rawString(s: string): string {
	return s.replace(/[\`\$\\]/g, '\\$&');
}
