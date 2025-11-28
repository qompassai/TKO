// scripts/server.ts
// Qompass AI TKO Deno Server TS Script
// Copyright (C) 2025 Qompass AI, All rights reserved
/////////////////////////////////////////////////////

import { serveDir } from "https://deno.land/std@0.212.0/http/file_server.ts";
const port = 8080;
console.log(`Serving ./dist at http://localhost:${port}`);
Deno.serve({ port }, (req) => serveDir(req, { fsRoot: "./dist" }));
