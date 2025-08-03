#!/usr/bin/env sh
/qompassai/tko/scripts/quickstart.sh
# Qompass AI TKO Quickstart
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
set -e
PROJECT="qompass-paper"
XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
INSTALL_DIR="${XDG_DATA_HOME}/$PROJECT"
FAST=false
INSTALL=false
SECURE=false
ROOTLESS=true
while [ $# -gt 0 ]; do
	case $1 in
	--fast) FAST=true ;;
	--install) INSTALL=true ;;
	--secure) SECURE=true ;;
	--no-rootless) ROOTLESS=false ;;
	esac
	shift
done
OS=$(uname -s)
ARCH=$(uname -m)
echo "==> Qompass AI TKO Quickstart"
echo "Detected OS: $OS, Architecture: $ARCH"
echo "Project directory (XDG style): $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/src/pages"
cd "$INSTALL_DIR" || exit 1
command -v deno >/dev/null 2>&1 || {
	echo "Deno not found."
	if [ "$INSTALL" = true ]; then
		echo "Installing Deno..."
		if [ "$OS" = "Linux" ] || [ "$OS" = "Darwin" ]; then
			curl -fsSL https://deno.land/install.sh | sh
			export PATH="$HOME/.deno/bin:$PATH"
		else
			echo "Please install Deno manually (https://deno.land/)"
			exit 1
		fi
	else
		echo "Please run with --install to auto-install Deno, or install manually."
		exit 1
	fi
}
command -v npm >/dev/null 2>&1 || {
	echo "npm not found."
	if [ "$INSTALL" = true ]; then
		echo "Please install Node.js/npm for your platform."
		exit 1
	else
		echo "npm is required. Exiting."
		exit 1
	fi
}
if [ "$FAST" = false ]; then
	printf "Paper title [default: Transforming Knowledge Ontology with the Model Context Protocol]: "
	read -r TITLE
	[ -z "$TITLE" ] && TITLE="Transforming Knowledge Ontology with the Model Context Protocol"
	printf "Description [default: A quality overview]: "
	read -r DESCRIPTION
	[ -z "$DESCRIPTION" ] && DESCRIPTION="A quality overview"
	echo "===> Enter authors. Leave name blank to finish."
	AUTHORS_BLOCK=""
	AUTHOR_NUM=1
	while :; do
		printf "Author #%d Name: " $AUTHOR_NUM
		read -r A_NAME
		[ -z "$A_NAME" ] && break
		printf "  Institution: "
		read -r A_INST
		printf "  URL (optional): "
		read -r A_URL
		AUTHORS_BLOCK="${AUTHORS_BLOCK}    {\n      name: \"$A_NAME\",\n      institution: \"$A_INST\""
		[ -n "$A_URL" ] && AUTHORS_BLOCK="${AUTHORS_BLOCK},\n      url: \"$A_URL\""
		AUTHORS_BLOCK="${AUTHORS_BLOCK}\n    },\n"
		AUTHOR_NUM=$((AUTHOR_NUM + 1))
		printf "Add another author? [y/N]: "
		read MORE
		case "$MORE" in
		[Yy]*) ;;
		*) break ;;
		esac
	done
	[ -z "$AUTHORS_BLOCK" ] && AUTHORS_BLOCK="    {\n      name: \"Matt A. Porter\",\n      institution: \"Qompass AI\",\n      url: \"https://www.qompass.ai\"\n    }"

	printf "Conference (optional) [Conference Name]: "
	read CONFERENCE
	[ -z "$CONFERENCE" ] && CONFERENCE="Conference Name"
else
	TITLE="Transforming Knowledge Ontology with the Model Context Protocol"
	DESCRIPTION="A quality overview"
	AUTHORS_BLOCK="    {\n      name: \"Matt A. Porter\",\n      institution: \"Qompass AI\",\n      url: \"https://www.qompass.ai\"\n    }"
	CONFERENCE="Conference Name"
fi
if [ "$INSTALL" = true ]; then
	[ -f package.json ] || npm init -y
	echo "Installing Astro and integrations…"
	npm install astro @astrojs/tailwind @astrojs/mdx @astrojs/react @astrojs/svelte astro-icon
fi
cat >astro.config.mjs <<EOF
import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import svelte from "@astrojs/svelte";
import icon from "astro-icon";
import fs from "node:fs";

export default defineConfig({
  site: "https://your-username.github.io/$PROJECT",
  base: "/$PROJECT",
  integrations: [tailwind(), icon(), mdx(), react(), svelte()],
  markdown: {
    shikiConfig: { themes: { light: "github-light", dark: "github-dark" } },
  },
  vite: {
    plugins: [
      {
        name: "astro-nojekyll",
        buildEnd() {
          fs.mkdirSync("dist", { recursive: true });
          fs.writeFileSync("dist/.nojekyll", "");
        },
      },
    ],
  },
});
EOF
cat >src/pages/index.mdx <<EOF
---
layout: ../layouts/Layout.astro
title: $TITLE
description: $DESCRIPTION
favicon: favicon.svg
thumbnail: screenshot-light.png
---

import Header from "../components/Header.astro";
import Video from "../components/Video.astro";
import HighlightedSection from "../components/HighlightedSection.astro";
import SmallCaps from "../components/SmallCaps.astro";
import Figure from "../components/Figure.astro";
import Image from "../components/Image.astro";
import TwoColumns from "../components/TwoColumns.astro";
import YouTubeVideo from "../components/YouTubeVideo.astro";
import LaTeX from "../components/LaTeX.astro";
import { ImageComparison } from "../components/ImageComparison.tsx";
import outside from "../assets/outside.mp4";
import transformer from "../assets/transformer.webp";
import Splat from "../components/Splat.tsx"
import dogsDiffc from "../assets/dogs-diffc.png"
import dogsTrue from "../assets/dogs-true.png"
import CodeBlock from "../components/CodeBlock.astro";
import Table from "../components/Table.astro";
export const components = {pre: CodeBlock, table: Table}

<Header
  title={frontmatter.title}
  authors={[
$AUTHORS_BLOCK
  ]}
  conference="$CONFERENCE"
  notes={[
    {
      symbol: "*",
      text: "author note one"
    },
    {
      symbol: "†",
      text: "author note two"
    }
  ]}
  links={[
    {
      name: "Code",
      url: "https://github.com/qompassai/tko",
      icon: "ri:github-line"
    }
  ]}
/>

<Video source={outside} />

<HighlightedSection>
## Abstract

[Add abstract here.]
</HighlightedSection>

<HighlightedSection>
## Background

[Add background here.]
</HighlightedSection>

## Figures
<Figure>
  <Image slot="figure" source={transformer} altText="Diagram of the transformer deep learning architecture." />
  <span slot="caption">Diagram of the transformer deep learning architecture.</span>
</Figure>

## Image comparison slider
<Figure>
  <ImageComparison slot="figure" client:load imageUrlOne={dogsDiffc.src} imageUrlTwo={dogsTrue.src} altTextOne="Photo of two dogs running side-by-side in shallow water, lossily compressed using the DiffC algorithm" altTextTwo="Original photo of two dogs running side-by-side in shallow water" />
  <span slot="caption">A photo of two dogs running side-by-side in shallow water, lossily compressed using the <a href="https://jeremyiv.github.io/diffc-project-page/">DiffC algorithm</a>.</span>
</Figure>

## Two columns
<TwoColumns>
  <Figure slot="left">
    <YouTubeVideo slot="figure" videoId="wjZofJX0v4M" />
    <span slot="caption">Take a look at this YouTube video.</span>
  </Figure>
  <Figure slot="right">
    <Splat slot="figure" client:idle />
    <span slot="caption">Now look at this <a href="https://en.wikipedia.org/wiki/Gaussian_splatting">Gaussian splat</a>, rendered with a React component.</span>
  </Figure>
</TwoColumns>

## LaTeX
You can also add LaTeX formulas:
<LaTeX formula="\int_a^b f(x) dx" />

## Tables

| Model         | Accuracy | F1 score | Training time (hours) |
| :---          | :---:    | :---:    | :---:                |
| BERT-base     | 0.89     | 0.87     | 4.5                  |
| RoBERTa-large | 0.92     | 0.91     | 7.2                  |
| DistilBERT    | 0.86     | 0.84     | 2.1                  |
| XLNet         | 0.90     | 0.89     | 6.8                  |

## BibTeX citation

\`\`\`bibtex
@misc{porter2025modelcontext,
  author = "{$(echo "$AUTHORS_BLOCK" | awk -F'"' '/name/ {printf "%s, ", $4}' | sed 's/, $//')}",
  title = "{$TITLE}",
  year = "2025",
  howpublished = "\url{https://your-username.github.io/$PROJECT}",
}
\`\`\`
EOF

# -------- tsconfig --------
cat >tsconfig.json <<EOF
{
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "node16",
    "strict": true,
    "jsx": "preserve",
    "esModuleInterop": true,
    "allowJs": true,
    "target": "ESNext"
  },
  "exclude": ["node_modules"]
}
EOF

if [ "$SECURE" = true ]; then
	chmod -R go-rwx "$INSTALL_DIR"
fi
cat <<EOM

✅ Qompass AI Publication Quickstart is ready at $INSTALL_DIR

To proceed:
- cd $INSTALL_DIR

To install dependencies automatically, run:
- ./quickstart.sh --install

To start local dev server (once npm deps installed):
- npm run dev

To build for GitHub Pages:
- npm run build

All installation and config paths use XDG conventions and work rootless by default.
Add --fast for maximum speed (skips prompts, uses defaults).
All author/metadata fields and sections are generated interactively.

Happy publishing!
EOM
