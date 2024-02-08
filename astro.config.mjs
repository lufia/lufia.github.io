import { defineConfig } from 'astro/config';
import wf from './src/integrations/wf';

export default defineConfig({
	site: 'https://lufia.org',
	build: {
		format: 'preserve'
	},
	integrations: [wf()]
});
