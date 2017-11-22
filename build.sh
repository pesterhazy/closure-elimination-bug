#!/bin/bash

set -euo pipefail

rm -rf out
rm -rf out.js
java -cp cljs-1.9.946.jar:src clojure.main compile.clj
pretty-js < out.js > out.pretty.js

perl -i.bak -pe 's/find_ns_obj_STAR_\(global/find_ns_obj_STAR_\(goog.global/g' out/cljs/core.js

java -cp cljs-1.9.946.jar com.google.javascript.jscomp.CommandLineRunner --compilation_level ADVANCED --js out/'**.js' --manage_closure_dependencies --closure_entry_point bug.core --closure_entry_point process.env --js_output_file advanced.js
pretty-js < advanced.js > advanced.pretty.js
