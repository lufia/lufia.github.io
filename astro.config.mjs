import { defineConfig } from 'astro/config';
import wf from './src/integrations/wf';

export default defineConfig({
	build: {
		format: 'preserve'
	},
	integrations: [wf()]
});
