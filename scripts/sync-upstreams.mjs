#!/usr/bin/env node

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const ZED_REPO_URL = 'https://github.com/zed-industries/zed.git';
const ARKTYPE_REPO_URL = 'https://github.com/arktypeio/arktype.git';
const TREE_SITTER_ARKTYPE_REPO_URL = 'https://github.com/jeffrom/tree-sitter-arktype.git';

const LANGUAGES = ['javascript', 'typescript', 'tsx'];
const ZED_FILES = [
  'config.toml',
  'brackets.scm',
  'debugger.scm',
  'highlights.scm',
  'imports.scm',
  'indents.scm',
  'injections.scm',
  'outline.scm',
  'overrides.scm',
  'runnables.scm',
  'textobjects.scm',
];

const ARKTYPE_HIGHLIGHT_MARKER = '; ArkType chain methods in fluent call expressions.';
const MANAGED_FILE_NOTE =
  '; NOTE: This file is managed by scripts/sync-upstreams.mjs.\n' +
  '; Update that script instead of editing this file directly.\n\n';

const INJECTIONS_TEMPLATE = `; NOTE: This file is managed by scripts/sync-upstreams.mjs.
; Update that script instead of editing this file directly.
; Root ArkType calls: type(...), generic(...), scope(...), define(...), match(...), fn(...), module(...), ark*(...)
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(@@ROOT_REGEX@@)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; Root ArkType calls with object value strings: type({ key: "string" })
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(@@ROOT_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: [
          (string (string_fragment) @injection.content)
          (template_string (string_fragment) @injection.content)
        ])))
  (#set! injection.language "arktype"))

; Root ArkType calls with object->array value strings: type({ tags: ["string"] })
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(@@ROOT_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
          ]))))
  (#set! injection.language "arktype"))

; Root ArkType calls with nested object value strings: type({ user: { id: "string" } })
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(@@ROOT_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: (object
          (pair
            value: [
              (string (string_fragment) @injection.content)
              (template_string (string_fragment) @injection.content)
            ])))))
  (#set! injection.language "arktype"))

; Root ArkType calls with array value strings: type(["string", "number"])
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(@@ROOT_REGEX@@)$")
  arguments: (arguments
    (array
      [
        (string (string_fragment) @injection.content)
        (template_string (string_fragment) @injection.content)
      ]))
  (#set! injection.language "arktype"))

; ArkType call chains and chain methods with direct string args.
; Covers type("...").to("..."), scope(...).and("...") etc.
(call_expression
  function: (member_expression
    object: (call_expression
      function: [
        (identifier) @_ark_receiver_fn
        (member_expression
          property: (property_identifier) @_ark_receiver_fn)
      ])
    property: (property_identifier) @_ark_method)
  (#match? @_ark_receiver_fn "^(@@COMBINED_REGEX@@)$")
  (#match? @_ark_method "^(@@COMBINED_REGEX@@)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; ArkType call chains and chain methods with object value strings.
(call_expression
  function: (member_expression
    object: (call_expression
      function: [
        (identifier) @_ark_receiver_fn
        (member_expression
          property: (property_identifier) @_ark_receiver_fn)
      ])
    property: (property_identifier) @_ark_method)
  (#match? @_ark_receiver_fn "^(@@COMBINED_REGEX@@)$")
  (#match? @_ark_method "^(@@COMBINED_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: [
          (string (string_fragment) @injection.content)
          (template_string (string_fragment) @injection.content)
        ])))
  (#set! injection.language "arktype"))

; ArkType call chains and chain methods with object->array value strings.
(call_expression
  function: (member_expression
    object: (call_expression
      function: [
        (identifier) @_ark_receiver_fn
        (member_expression
          property: (property_identifier) @_ark_receiver_fn)
      ])
    property: (property_identifier) @_ark_method)
  (#match? @_ark_receiver_fn "^(@@COMBINED_REGEX@@)$")
  (#match? @_ark_method "^(@@COMBINED_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
          ]))))
  (#set! injection.language "arktype"))

; ArkType call chains and chain methods with nested object value strings.
(call_expression
  function: (member_expression
    object: (call_expression
      function: [
        (identifier) @_ark_receiver_fn
        (member_expression
          property: (property_identifier) @_ark_receiver_fn)
      ])
    property: (property_identifier) @_ark_method)
  (#match? @_ark_receiver_fn "^(@@COMBINED_REGEX@@)$")
  (#match? @_ark_method "^(@@COMBINED_REGEX@@)$")
  arguments: (arguments
    (object
      (pair
        value: (object
          (pair
            value: [
              (string (string_fragment) @injection.content)
              (template_string (string_fragment) @injection.content)
            ])))))
  (#set! injection.language "arktype"))

; Regex helper parity with VS Code extension: regex("..."), obj.regex("...")
(call_expression
  function: (identifier) @_regex_fn
  (#eq? @_regex_fn "regex")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "regex"))

(call_expression
  function: (member_expression
    property: (property_identifier) @_regex_fn)
  (#eq? @_regex_fn "regex")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "regex"))
`;

function run(cmd, args = [], cwd = undefined) {
  return execFileSync(cmd, args, {
    cwd,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

function writeTextIfChanged(targetPath, content) {
  fs.mkdirSync(path.dirname(targetPath), { recursive: true });
  if (fs.existsSync(targetPath) && fs.readFileSync(targetPath, 'utf8') === content) {
    return false;
  }
  fs.writeFileSync(targetPath, content, 'utf8');
  return true;
}

function cloneRepo(url, checkoutDir) {
  run('git', ['clone', '--depth', '1', url, checkoutDir]);
}

function resolveTreeSitterSha() {
  const out = run('git', ['ls-remote', TREE_SITTER_ARKTYPE_REPO_URL, 'HEAD']);
  if (!out) throw new Error('Could not resolve tree-sitter-arktype HEAD SHA');
  return out.split(/\s+/)[0];
}

function extractArktypeRegex(beginPattern) {
  const match = beginPattern.match(/\\b\(([^)]*)\)\(\\\(/);
  if (!match) {
    throw new Error(`Could not extract regex alternatives from pattern: ${beginPattern}`);
  }
  return match[1];
}

function loadArktypeRegexes(arktypeRepoDir) {
  const injectedPath = path.join(arktypeRepoDir, 'ark/extension/injected.tmLanguage.json');
  const data = JSON.parse(fs.readFileSync(injectedPath, 'utf8'));
  return {
    rootRegex: extractArktypeRegex(data.repository.arkDefinition.begin),
    chainRegex: extractArktypeRegex(data.repository.arkChained.begin),
  };
}

function syncZedFiles(repoRoot, zedRepoDir) {
  let changed = 0;
  for (const language of LANGUAGES) {
    const srcDir = path.join(zedRepoDir, 'crates/languages/src', language);
    const dstDir = path.join(repoRoot, 'languages', language);
    for (const file of ZED_FILES) {
      const src = path.join(srcDir, file);
      if (!fs.existsSync(src)) {
        throw new Error(`Missing upstream file: ${src}`);
      }
      const content = fs.readFileSync(src, 'utf8');
      changed += writeTextIfChanged(path.join(dstDir, file), content) ? 1 : 0;
    }
  }
  return changed;
}

function applyImportsPatch(repoRoot) {
  let changed = 0;
  for (const language of LANGUAGES) {
    const target = path.join(repoRoot, 'languages', language, 'imports.scm');
    changed += writeTextIfChanged(
      target,
      '; NOTE: This file is managed by scripts/sync-upstreams.mjs.\n' +
        '; Update that script instead of editing this file directly.\n' +
        '(import_statement) @import\n',
    )
      ? 1
      : 0;
  }
  return changed;
}

function applyHighlightsPatch(repoRoot, chainRegex) {
  let changed = 0;
  const block =
    `${ARKTYPE_HIGHLIGHT_MARKER}\n` +
    '(call_expression\n' +
    '  function: (member_expression\n' +
    '    object: (call_expression)\n' +
    '    property: (property_identifier) @function.method)\n' +
    `  (#match? @function.method \"^(${chainRegex})$\"))\n`;

  for (const language of LANGUAGES) {
    const target = path.join(repoRoot, 'languages', language, 'highlights.scm');
    const original = fs.readFileSync(target, 'utf8');
    let base = original;
    if (base.startsWith('; NOTE: This file is managed by scripts/sync-upstreams.mjs.\n')) {
      const lines = base.split('\n');
      if (lines[1] === '; Update that script instead of editing this file directly.') {
        lines.splice(0, 2);
        if (lines[0] === '') {
          lines.splice(0, 1);
        }
        base = lines.join('\n');
      }
    }

    const stripped = base.includes(ARKTYPE_HIGHLIGHT_MARKER)
      ? `${base.split(ARKTYPE_HIGHLIGHT_MARKER)[0].trimEnd()}\n\n`
      : `${base.trimEnd()}\n\n`;
    const next = `${MANAGED_FILE_NOTE}${stripped}${block}`;
    changed += writeTextIfChanged(target, next) ? 1 : 0;
  }
  return changed;
}

function writeInjections(repoRoot, rootRegex, chainRegex) {
  let changed = 0;
  const combinedRegex = `${rootRegex}|${chainRegex}`;
  const content = INJECTIONS_TEMPLATE
    .replaceAll('@@ROOT_REGEX@@', rootRegex)
    .replaceAll('@@COMBINED_REGEX@@', combinedRegex);

  for (const language of LANGUAGES) {
    const target = path.join(repoRoot, 'languages', language, 'injections-arktype.scm');
    changed += writeTextIfChanged(target, content) ? 1 : 0;
  }
  return changed;
}

function updateExtensionToml(repoRoot, treeSitterSha) {
  const target = path.join(repoRoot, 'extension.toml');
  const lines = fs.readFileSync(target, 'utf8').split('\n');
  let inGrammarSection = false;
  let sawGrammarSection = false;
  let sawRev = false;
  let updated = false;

  for (let i = 0; i < lines.length; i += 1) {
    const stripped = lines[i].trim();
    if (stripped.startsWith('[') && stripped.endsWith(']')) {
      inGrammarSection = stripped === '[grammars.arktype]';
      if (inGrammarSection) {
        sawGrammarSection = true;
      }
      continue;
    }
    if (inGrammarSection && stripped.startsWith('rev = ')) {
      sawRev = true;
      const newLine = `rev = "${treeSitterSha}"`;
      if (lines[i] !== newLine) {
        lines[i] = newLine;
        updated = true;
      }
      break;
    }
  }

  if (!sawGrammarSection) {
    throw new Error('Could not find [grammars.arktype] section in extension.toml');
  }
  if (!sawRev) {
    throw new Error('Could not find rev entry in [grammars.arktype] section');
  }

  if (!updated) return 0;
  return writeTextIfChanged(target, `${lines.join('\n')}\n`) ? 1 : 0;
}

function updateLanguageReadmeDates(repoRoot, dateStr) {
  let changed = 0;
  const re = /(Last modification notice update:\s*)(\d{4}-\d{2}-\d{2})(\.)/g;
  for (const language of LANGUAGES) {
    const target = path.join(repoRoot, 'languages', language, 'README.md');
    const original = fs.readFileSync(target, 'utf8');
    const next = original.replace(re, `$1${dateStr}$3`);
    changed += writeTextIfChanged(target, next) ? 1 : 0;
  }
  return changed;
}

function main() {
  if (process.argv.length > 2) {
    throw new Error('This script does not accept arguments.');
  }

  const here = path.dirname(fileURLToPath(import.meta.url));
  const repoRoot = path.resolve(here, '..');
  const tmpRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'upstream-sync-'));

  try {
    const zedDir = path.join(tmpRoot, 'zed');
    const arktypeDir = path.join(tmpRoot, 'arktype');
    cloneRepo(ZED_REPO_URL, zedDir);
    cloneRepo(ARKTYPE_REPO_URL, arktypeDir);

    const zedSha = run('git', ['rev-parse', 'HEAD'], zedDir);
    const arktypeSha = run('git', ['rev-parse', 'HEAD'], arktypeDir);
    const treeSitterSha = resolveTreeSitterSha();

    const { rootRegex, chainRegex } = loadArktypeRegexes(arktypeDir);
    const today = new Date().toISOString().slice(0, 10);

    const zedFileChanges = syncZedFiles(repoRoot, zedDir);
    const importsPatchChanges = applyImportsPatch(repoRoot);
    const highlightsPatchChanges = applyHighlightsPatch(repoRoot, chainRegex);
    const injectionChanges = writeInjections(repoRoot, rootRegex, chainRegex);
    const extensionChanges = updateExtensionToml(repoRoot, treeSitterSha);

    const upstreamContentChanged = zedFileChanges > 0 || injectionChanges > 0;
    const readmeDateChanges = upstreamContentChanged
      ? updateLanguageReadmeDates(repoRoot, today)
      : 0;

    const changedFiles =
      zedFileChanges +
      importsPatchChanges +
      highlightsPatchChanges +
      injectionChanges +
      extensionChanges +
      readmeDateChanges;

    console.log('Upstream sync finished.');
    console.log(`- zed: ${zedSha}`);
    console.log(`- arktype: ${arktypeSha}`);
    console.log(`- tree-sitter-arktype: ${treeSitterSha}`);
    console.log(`- zed files changed: ${zedFileChanges}`);
    console.log(`- imports patch changes: ${importsPatchChanges}`);
    console.log(`- highlights patch changes: ${highlightsPatchChanges}`);
    console.log(`- injections changed: ${injectionChanges}`);
    console.log(`- extension.toml changes: ${extensionChanges}`);
    console.log(`- language README date changes: ${readmeDateChanges}`);
    console.log(`- files updated: ${changedFiles}`);
  } finally {
    fs.rmSync(tmpRoot, { recursive: true, force: true });
  }
}

try {
  main();
} catch (err) {
  console.error(err?.message ?? String(err));
  process.exit(1);
}
