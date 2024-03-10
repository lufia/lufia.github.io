import { spawn } from 'child_process';
import fs from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'path';
import { Readable } from 'stream';
import { pipeline } from 'stream/promises';
import type { Plugin } from 'vite';
import {
    createProcess,
    WritableMemoryStream,
} from '../../html-generator';

type Options = Readonly<{
	extension: string;
	outputExtension: string;
	mimeType: string;
	commands: Command[];
}>;

type Command = Readonly<{
	name: string;
	args?: string[];
}>;

export default function command(options: Options): Plugin {
	let config: ResolvedConfig;
	return {
		name: 'vite-plugin-command',
		configResolved(resolvedConfig: ResolvedConfig) {
			config = resolvedConfig;
		},
		async transform(_, id) {
			if(!id.endsWith(options.extension))
				return;
			const data = await run(id, options.commands);
			if(config.command === 'serve'){
				return {
					code: createEmbedData(data, options.mimeType),
					map: null,
				};
			}
			const fullPath = path.format({
				...path.parse(id),
				base: undefined,
				ext: options.outputExtension,
			});
			const file = this.emitFile({
				name: path.basename(fullPath),
				type: 'asset',
				source: data,
			});
			return {
				code: generateCode(file),
				map: null,
			};
		},
		resolveFileUrl({ fileName }) {
			return `${JSON.stringify('/'+fileName)}`;
		},
	};
}

async function run(file: string, cmds: Command[]): Promise<string> {
	const data = await fs.readFile(file, 'utf-8');
	const f = Readable.from([data]);
	const w = new WritableMemoryStream();
	const procs = cmds.map(c => createProcess(c.name, c.args ?? []));
	await pipeline(f, ...procs, w);
	return w.toString();
}

function createEmbedData(data: string, mimeType: string): string {
	const b = Buffer.from(data);
	const u = `data:${mimeType};base64,${b.toString('base64')}`;
	return `export default ${JSON.stringify(u)};`;
}

function generateCode(referenceId: string): string {
	return `export default import.meta.ROLLUP_FILE_URL_${referenceId};`;
}
