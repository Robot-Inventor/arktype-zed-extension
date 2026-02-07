("(" @open ")" @close)

(("'" @open "'" @close) (#set! rainbow.exclude))
(("\"" @open "\"" @close) (#set! rainbow.exclude))

((regex "/" @open "/" @close) (#set! rainbow.exclude))
