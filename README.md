# Feshmedia

A small desktop starter built with Haxe, [HXP](https://lib.haxe.org/p/hxp/),
[hxelectron](https://github.com/tong/hxelectron), Electron, and
[HMM](https://github.com/andywhite37/hmm). The application code lives in
`source/`, and the build is described by a single `Project.hxp` script at the
project root.

## Prerequisites

- Haxe 4.3 or newer
- Node.js 20 or newer
- HMM installed globally

Install HMM once if it is not already available:

```sh
haxelib --global install hmm
haxelib --global run hmm setup
```

## Setup

```sh
hmm install
npm install
```

HMM creates a project-local `.haxelib/` repository and installs the exact
Haxe library versions declared in `hmm.json`.

## Commands

```sh
npm run build   # compile main and renderer Haxe targets into dist/
npm run clean   # remove the generated dist/ output
npm start       # build and launch Electron
npm run dev     # same as start, with Electron logging enabled
```

You can invoke the HXP build directly as well. `haxelib run hxp` discovers the
`Project.hxp` script automatically and dispatches on the command name:

```sh
haxelib run hxp         # build everything (default)
haxelib run hxp build   # same as above
haxelib run hxp clean   # remove dist/
```

## Layout

```text
Project.hxp        HXP build script (targets + asset copy)
source/
  Main.hx          Electron main process
  Renderer.hx      Browser renderer
public/            HTML and CSS copied into dist/
dist/              Generated application output
hmm.json           Project-local Haxelib dependencies
package.json       Electron runtime and npm commands
```

The BrowserWindow uses `contextIsolation: true`, `nodeIntegration: false`,
and sandboxing. Add a narrow preload bridge before exposing any native
capability to renderer code.
