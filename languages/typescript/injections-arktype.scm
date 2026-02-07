; ArkType root APIs: type(), scope(), generic(), define(), match(), fn(), module(), ark*()
(call_expression
  function: (identifier) @_root
  (#match? @_root "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; Namespace/member root APIs such as ark.type("...")
(call_expression
  function: (member_expression
    object: (identifier) @_root_object
    property: (property_identifier) @_root_method)
  (#match? @_root_object "^[aA]rk[a-zA-Z]*$")
  (#match? @_root_method "^(type|generic|scope|define|match|fn|module)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; ArkType chained APIs with direct string args, e.g. type("...").to("...")
(call_expression
  function: (member_expression
    object: (call_expression)
    property: (property_identifier) @_chain_method)
  (#match? @_chain_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; ArkType chained APIs with object literal args, e.g. type("...").to({ a: "string" })
(call_expression
  function: (member_expression
    object: (call_expression)
    property: (property_identifier) @_chain_method)
  (#match? @_chain_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    (object
      (pair
        value: [
          (string (string_fragment) @injection.content)
          (template_string (string_fragment) @injection.content)
        ])))
  (#set! injection.language "arktype"))
