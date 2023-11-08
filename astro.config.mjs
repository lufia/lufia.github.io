import { defineConfig } from 'astro/config';
import wf from './src/integrations/wf';

export default defineConfig({
	integrations: [wf()]
});
