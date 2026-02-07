# arktype-zed-extension

Unofficial ArkType highlighting extension for Zed.

## Features

- Registers the ArkType Tree-sitter grammar.
- Adds a hidden `ArkType` language used only as an injection target.
- Injects ArkType highlighting into JavaScript (including JSX), TypeScript, and TSX strings passed to `type(...)` and `scope(...)`.
- Uses Zed's built-in JavaScript/TypeScript/TSX grammars (no JS/TS grammar replacement in this extension).

## Local Development

1. Open Zed and run `Install Dev Extension`.
2. Select this repository directory.
3. Open a JS/TS file and add an ArkType string such as `type("string.email")`.

## Attribution

- ArkType Tree-sitter grammar (`tree-sitter-arktype`) by Jeff Martin: https://github.com/jeffrom/tree-sitter-arktype
- ArkType VS Code extension injection/highlighting rules, referenced for parity of ArkType call-chain highlighting: https://github.com/arktypeio/arktype/tree/main/ark/extension
- JavaScript/TypeScript/TSX language query/config baselines are adapted from Zed built-in language definitions: https://github.com/zed-industries/zed/tree/main/crates/languages/src
- JavaScript/TypeScript parsing is provided by Zed built-ins, which are based on Tree-sitter TypeScript grammars: https://github.com/tree-sitter/tree-sitter-typescript (and Zed's fork: https://github.com/zed-industries/tree-sitter-typescript)
