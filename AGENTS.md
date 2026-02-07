# Repository Guidelines

## Project Structure & Module Organization

- `src/lib.rs`: Rust entry point that registers the Zed extension.
- `extension.toml`: extension metadata and grammar source pin (`tree-sitter-arktype`).
- `languages/arktype/`: hidden ArkType injection target (`config.toml`, `highlights.scm`).
- `languages/javascript/`, `languages/typescript/`, `languages/tsx/`: adapted Zed language query sets plus `injections-arktype.scm`.

## Build, Test, and Development Commands

- `cargo check`: compile and type-check extension code quickly.
- `cargo test`: run Rust tests (currently smoke-level; may be zero tests).
- `cargo fmt --all -- --check`: verify formatting.
- In Zed: `Install Dev Extension` and select this repo to validate real highlighting behavior.

Example local validation flow:

1. `cargo check`
2. `cargo fmt --all -- --check`
3. Install as dev extension in Zed and open `.js/.ts/.tsx` files.

## Coding Style & Naming Conventions

- Rust: follow `rustfmt` defaults (Rust 2021 edition).
- Tree-sitter queries: keep `.scm` files parser-compatible; avoid unsupported field names.
- Keep JS/TS/TSX injection behavior aligned unless a language-specific difference is required.
- Use explicit, scoped filenames for ArkType additions (for example, `injections-arktype.scm`).

## Testing Guidelines

- No dedicated automated grammar test suite exists yet; rely on command checks plus manual editor verification.
- Validate at least:
  - `type("string.json.parse")`
  - `type("...").to({...})`
  - chain APIs such as `.or()`, `.and()`, `.pipe()`, `.to()`
- Confirm base JS/TS/TSX highlighting is not regressed.

## Commit & Pull Request Guidelines

- Follow Conventional Commits seen in history: `feat:`, `fix:`, `docs:`, `chore:`.
- Keep commits focused by area (`languages/*`, `src/`, docs).
- PRs should include:
  - concise change summary,
  - before/after highlighting screenshots,
  - affected language folders,
  - attribution/license updates when copying or adapting upstream content.

## Licensing & Attribution

- Repository license: GPL-3.0-or-later (`LICENSE`).
- When copying/adapting third-party files, update:
  - folder-level `README.md` in the affected `languages/*` directory,
  - root `README.md` third-party notices.
- If you edit files previously copied/adapted from other projects, update that directory's `README.md` modification notes as needed (changed files, behavior differences, and modification date when required by the license).
