import { defineConfig } from 'astro/config';
import wf from './src/integrations/wf';
import command from './src/integrations/vite-plugin-command';

export default defineConfig({
	site: 'https://lufia.org',
	build: {
		format: 'preserve'
	},
	vite: {
		plugins: [
			command({
				extension: '.map',
				outputExtension: '.svg',
				mimeType: 'image/svg+xml',
				commands: [
					{ name: 'mapsvg' }
				]
			}),
			command({
				extension: '.pic',
				outputExtension: '.svg',
				mimeType: 'image/svg+xml',
				commands: [
					{ name: 'svgpic' }
				]
			}),
			command({
				extension: '.df',
				outputExtension: '.svg',
				mimeType: 'image/svg+xml',
				commands: [
					{ name: './bin/dformat' },
					{ name: 'svgpic' }
				]
			}),
		]
	},
	integrations: [wf()]
});
