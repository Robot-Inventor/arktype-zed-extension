; NOTE: This file is managed by scripts/sync-upstreams.mjs.
; Update that script instead of editing this file directly.
; Root ArkType calls: type(...), generic(...), scope(...), define(...), match(...), fn(...), module(...), ark*(...)
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; Root ArkType calls with object value strings: type({ key: "string" })
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
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
  (#match? @_ark_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
  arguments: (arguments
    (object
      (pair
        value: (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
            (array
              [
                (string (string_fragment) @injection.content)
                (template_string (string_fragment) @injection.content)
              ])
            (object
              (pair
                value: [
                  (string (string_fragment) @injection.content)
                  (template_string (string_fragment) @injection.content)
                ]))
            (object
              (pair
                value: (array
                  [
                    (string (string_fragment) @injection.content)
                    (template_string (string_fragment) @injection.content)
                  ])))
            (object
              (pair
                value: (object
                  (pair
                    value: [
                      (string (string_fragment) @injection.content)
                      (template_string (string_fragment) @injection.content)
                    ]))))
          ]))))
  (#set! injection.language "arktype"))

; Root ArkType calls with nested object value strings: type({ user: { id: "string" } })
(call_expression
  function: (identifier) @_ark_fn
  (#match? @_ark_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
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
  (#match? @_ark_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*)$")
  arguments: (arguments
    (array
      [
        (string (string_fragment) @injection.content)
        (template_string (string_fragment) @injection.content)
        (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
          ])
        (object
          (pair
            value: [
              (string (string_fragment) @injection.content)
              (template_string (string_fragment) @injection.content)
            ]))
        (object
          (pair
            value: (array
              [
                (string (string_fragment) @injection.content)
                (template_string (string_fragment) @injection.content)
              ])))
        (object
          (pair
            value: (object
              (pair
                value: [
                  (string (string_fragment) @injection.content)
                  (template_string (string_fragment) @injection.content)
                ]))))
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
  (#match? @_ark_receiver_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  (#match? @_ark_method "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    [
      (string (string_fragment) @injection.content)
      (template_string (string_fragment) @injection.content)
    ])
  (#set! injection.language "arktype"))

; Fallback for ArkType chain methods on identifier/member receivers.
; Covers const schema = type(...); schema.merge({...}) style calls.
(call_expression
  function: (member_expression
    object: [
      (identifier)
      (member_expression)
    ]
    property: (property_identifier) @_ark_method)
  (#match? @_ark_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
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
  (#match? @_ark_receiver_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  (#match? @_ark_method "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    (object
      (pair
        value: [
          (string (string_fragment) @injection.content)
          (template_string (string_fragment) @injection.content)
        ])))
  (#set! injection.language "arktype"))

; Fallback for ArkType chain methods on identifier/member receivers with object value strings.
(call_expression
  function: (member_expression
    object: [
      (identifier)
      (member_expression)
    ]
    property: (property_identifier) @_ark_method)
  (#match? @_ark_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
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
  (#match? @_ark_receiver_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  (#match? @_ark_method "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    (object
      (pair
        value: (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
            (array
              [
                (string (string_fragment) @injection.content)
                (template_string (string_fragment) @injection.content)
              ])
            (object
              (pair
                value: [
                  (string (string_fragment) @injection.content)
                  (template_string (string_fragment) @injection.content)
                ]))
            (object
              (pair
                value: (array
                  [
                    (string (string_fragment) @injection.content)
                    (template_string (string_fragment) @injection.content)
                  ])))
            (object
              (pair
                value: (object
                  (pair
                    value: [
                      (string (string_fragment) @injection.content)
                      (template_string (string_fragment) @injection.content)
                    ]))))
          ]))))
  (#set! injection.language "arktype"))

; Fallback for ArkType chain methods on identifier/member receivers with object->array value strings.
(call_expression
  function: (member_expression
    object: [
      (identifier)
      (member_expression)
    ]
    property: (property_identifier) @_ark_method)
  (#match? @_ark_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  arguments: (arguments
    (object
      (pair
        value: (array
          [
            (string (string_fragment) @injection.content)
            (template_string (string_fragment) @injection.content)
            (array
              [
                (string (string_fragment) @injection.content)
                (template_string (string_fragment) @injection.content)
              ])
            (object
              (pair
                value: [
                  (string (string_fragment) @injection.content)
                  (template_string (string_fragment) @injection.content)
                ]))
            (object
              (pair
                value: (array
                  [
                    (string (string_fragment) @injection.content)
                    (template_string (string_fragment) @injection.content)
                  ])))
            (object
              (pair
                value: (object
                  (pair
                    value: [
                      (string (string_fragment) @injection.content)
                      (template_string (string_fragment) @injection.content)
                    ]))))
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
  (#match? @_ark_receiver_fn "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
  (#match? @_ark_method "^(type|generic|scope|define|match|fn|module|[aA]rk[a-zA-Z]*|and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
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

; Fallback for ArkType chain methods on identifier/member receivers with nested object value strings.
(call_expression
  function: (member_expression
    object: [
      (identifier)
      (member_expression)
    ]
    property: (property_identifier) @_ark_method)
  (#match? @_ark_method "^(and|or|case|in|extends|ifExtends|intersect|merge|exclude|extract|overlaps|subsumes|to|satisfies)$")
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
