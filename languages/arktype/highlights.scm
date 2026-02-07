(primitive) @type.builtin
(keyword) @type.builtin

((literal) @boolean
  (#match? @boolean "^(true|false)$"))

((literal) @string.special
  (#match? @string.special "^'.*'$"))

((literal) @string.special
  (#match? @string.special "^\".*\"$"))

(operator) @operator

(string) @string
(escape_sequence) @string.escape

(number) @number

(regex) @string.regex

(regex_pattern) @string.regex

(regex_flags) @string.special

[
 "("
 ")"
 ] @punctuation.bracket
