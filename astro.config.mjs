// /qompassai/tko/astro.config.mjs
// Qompass AI TKO Astro Config

import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import icon from "astro-icon";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import svelte from "@astrojs/svelte";
import fs from "node:fs";

// https://astro.build/config
export default defineConfig({
	site: "https://qompassai.github.io/tko",
	base: "/tko",

	integrations: [tailwind(), icon(), mdx(), react(), svelte()],

	markdown: {
		shikiConfig: {
			themes: {
				light: "github-light",
				dark: "github-dark",
			},
		},
	},

	vite: {
		buildEnd() {
			fs.mkdirSync("dist", { recursive: true });
			fs.writeFileSync("dist/.nojekyll", "");
		},
	},
});
