; ArkType expressions are injected from JS/TS/TSX strings and parsed with the
; TypeScript grammar. This query biases highlighting toward ArkType keywords.

((identifier) @type.builtin
  (#match? @type.builtin "^(any|Array|bigint|boolean|Date|false|Function|infer|instanceof|keyof|Map|never|null|number|object|Record|RegExp|Set|string|symbol|true|typeof|undefined|unknown)$"))

((predefined_type) @type.builtin)

((property_identifier) @type.builtin
  (#match? @type.builtin "^(alphanumeric|alpha|before|creditCard|date|digits|email|exactLength|format|from|integer|ip|json|lower|max|maxLength|min|minLength|NFC|NFD|NFKC|NFKD|normalize|numeric|parse|phone|semver|trim|upper|url|uuid|v4|v6)$"))

[
  (string)
  (template_string)
  (template_literal_type)
] @string

(escape_sequence) @string.escape

(regex) @string.regex
(regex_flags) @keyword.operator.regex
(regex "/" @string.regex)

(number) @number

[
  (true)
  (false)
] @boolean

[
  (null)
  (undefined)
] @constant.builtin

[
  ";"
  "?."
  "."
  ","
  ":"
  "?"
] @punctuation.delimiter

[
  "..."
  "-"
  "--"
  "-="
  "+"
  "++"
  "+="
  "*"
  "*="
  "**"
  "**="
  "/"
  "/="
  "%"
  "%="
  "<"
  "<="
  "<<"
  "<<="
  "="
  "=="
  "==="
  "!"
  "!="
  "!=="
  "=>"
  ">"
  ">="
  ">>"
  ">>="
  ">>>"
  ">>>="
  "~"
  "^"
  "&"
  "|"
  "^="
  "&="
  "|="
  "&&"
  "||"
  "??"
  "&&="
  "||="
  "??="
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
