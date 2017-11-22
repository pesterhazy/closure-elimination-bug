(require 'cljs.build.api)

(cljs.build.api/build "src"
  { :output-to "out.js"
    :optimizations :advanced
    :pretty-print true })

(System/exit 0)
