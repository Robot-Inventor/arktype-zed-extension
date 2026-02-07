# arktype-zed-extension

Unofficial ArkType highlighting extension for Zed.

## Features

- Registers the ArkType Tree-sitter grammar.
- Injects ArkType highlighting into JavaScript/TypeScript strings passed to `type(...)` and `scope(...)`.
- Supports JavaScript, TypeScript, JSX, and TSX source files.

## Local Development

1. Open Zed and run `Install Dev Extension`.
2. Select this repository directory.
3. Open a JS/TS file and add an ArkType string such as `type("string.email")`.

## Attribution

This extension uses the `tree-sitter-arktype` grammar by Jeff Martin: https://github.com/jeffrom/tree-sitter-arktype
