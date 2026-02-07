(primitive) @type.builtin

(literal) @boolean

(identifier
  (keyword) @type)

(number) @number

(string) @string
(escape_sequence) @string.escape

(regex
  "/" @punctuation.special
  (regex_pattern) @string.regex
  "/" @punctuation.special)

(regex_pattern) @string.regex
(regex_flags) @string.special

(operator) @operator

(member_expression
  "." @punctuation.delimiter)

(member_expression
  property: (keyword) @property)

[
  "("
  ")"
] @punctuation.bracket
