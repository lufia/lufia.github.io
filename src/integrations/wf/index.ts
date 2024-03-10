import type {
	AstroIntegration,
	ContentEntryType,
	HookParameters,
} from 'astro';
import { JSDOM } from 'jsdom';
import fs from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { codeToHtml } from 'shiki';
import { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';
import type { Plugin as VitePlugin } from 'vite';
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
									} = parseFrontmatter(code, fileId);
									const frontmatter: Frontmatter = {
										title: params.title,
										style: params.style!,
										pre: params.pre,
										post: params.post,
									}
									const data = await layout(fileId, pageContent, frontmatter);
									const html = await convert(data);
									const dir = path.dirname(fileId);
									return {
										code: await generateCode(dir, html, frontmatter.style),
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
	const f = Readable.from([data]);
	const w = new WritableMemoryStream();
	await pipeline(f, convertToHtml({
		lang: 'ja',
		extensions: {
			//map: 'svg',
			w: 'html',
		},
	}), w);
	return w.toString();
}

async function generateCode(dir: string, html: string, style: string): Promise<string> {
	const { document } = new JSDOM(html).window;
	const nodes = document.querySelectorAll('img[src$=".map"]');
	const images = Array.from(nodes).map((p, i) => ({
		varname: `image${i+1}`,
		src: p.src,
		file: path.resolve(dir, p.src),
	}));

	const code = `
	import { JSDOM } from 'jsdom'
	import css from '${style}?inline'
	const html = ${JSON.stringify(await highlight(html))}

	const dom = new JSDOM(html)
	const { document } = dom.window
	const style = document.createElement('style')
	style.appendChild(document.createTextNode(css))
	document.head.appendChild(style)

	const imageMap = new Map()
	${images.map(s => `
		import ${s.varname} from ${JSON.stringify(s.file)}
		imageMap.set(${JSON.stringify(s.src)}, ${s.varname})
	`).join('')}
	document.querySelectorAll('img[src$=".map"]').forEach(p => {
		p.src = imageMap.get(p.src)
	})
	export default function render() {
		return dom.serialize()
	}
	render['astro:html'] = true
	render[Symbol.for("astro.needsHeadRendering")] = false
	`;

	return code;
}

async function highlight(html: string): Promise<string> {
	const dom = new JSDOM(html);
	const { document } = dom.window;
	const codes = Array.from(document.querySelectorAll('code'));
	for(const c of codes){
		if(c.className === undefined)
			continue;
		c.parentNode.outerHTML = await codeToHtml(c.innerHTML, {
			lang: c.className,
			theme: 'github-light',
		});
	}
	return dom.serialize();
}
