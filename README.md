# arktype-zed-extension

Unofficial ArkType highlighting extension for Zed.

## Features

- Registers the ArkType Tree-sitter grammar.
- Adds a hidden `ArkType` language used only as an injection target.
- Injects ArkType highlighting into JavaScript (including JSX), TypeScript, and TSX strings passed to `type(...)` and `scope(...)`.
- Adds ArkType injection queries on top of Zed's built-in JavaScript/TypeScript/TSX language definitions.

## Local Development

1. Open Zed and run `Install Dev Extension`.
2. Select this repository directory.
3. Open a JS/TS file and add an ArkType string such as `type("string.email")`.

## Attribution

This extension uses the `tree-sitter-arktype` grammar by Jeff Martin: https://github.com/jeffrom/tree-sitter-arktype
