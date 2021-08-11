import { ChildProcess, spawn } from "child_process";
import { Transform, Writable } from "stream";

export function include(dir?: string): Transform {
	const args = dir ? ["-a", dir] : [];
	const p = spawn("include", args, {
		stdio: ["pipe", "pipe", "inherit"],
	});
	return createTransform(p);
}

type ConverterOptions = Readonly<{
	lang: string;
	extensions?: { [key: string]: string };
	// TODO: fragment: boolean; will add -p option
}>;

export function convertToHtml(options: ConverterOptions): Transform {
	const args: string[] = [];
	if(options.lang)
		args.push("-l", options.lang);
	if(options.extensions)
		for(const [key, value] of Object.entries(options.extensions))
			args.push("-x", key, value);
	const p = spawn("wf", args, {
		stdio: ["pipe", "pipe", "inherit"],
	});
	return createTransform(p);
}

function createTransform(p: ChildProcess): Transform {
	const que: string[] = [];
	p.stdout.on("data", s => {
		que.push(s);
	});

	const t = new Transform({
		transform: (data, encoding, callback): void => {
			p.stdin.write(data);
			while(que.length > 0)
				t.push(que.shift());
			callback();
		},
		final: async (callback): Promise<void> => {
			p.stdin.end();
			const status = await new Promise((resolve, reject) => {
				p.on("close", resolve);
			});
			if(status !== 0){
				throw new Error(`${p.spawnfile}: exit with ${status}`);
			}
			while(que.length > 0)
				t.push(que.shift());
			callback();
		},
	});
	return t;
}

export class WritableMemoryStream extends Writable {
	private data: string[];

	constructor() {
		super();
		this.data = [];
	}

	_write(data: any, encoding: BufferEncoding, callback: (error?: Error | null) => void) {
		this.data.push(data);
		callback();
	}

	toString(): string {
		return this.data.join("");
	}
}
