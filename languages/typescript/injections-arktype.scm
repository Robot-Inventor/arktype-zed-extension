(call_expression
  function: (identifier) @_fn
  (#eq? @_fn "type")
  arguments: (arguments
    (string
      (string_fragment) @injection.content))
  (#set! injection.language "arktype"))

(call_expression
  function: (identifier) @_fn
  (#eq? @_fn "scope")
  arguments: (arguments
    (string
      (string_fragment) @injection.content))
  (#set! injection.language "arktype"))

(call_expression
  function: (member_expression
    object: (identifier) @_fn
    (#eq? @_fn "type")
    property: (property_identifier))
  arguments: (arguments
    (string
      (string_fragment) @injection.content))
  (#set! injection.language "arktype"))

(call_expression
  function: (member_expression
    object: (identifier) @_fn
    (#eq? @_fn "scope")
    property: (property_identifier))
  arguments: (arguments
    (string
      (string_fragment) @injection.content))
  (#set! injection.language "arktype"))
