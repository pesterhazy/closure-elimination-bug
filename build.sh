#!/bin/bash

set -euo pipefail

rm -rf out
rm -rf out.js
java -cp cljs-1.9.946.jar:src clojure.main compile.clj
pretty-js < out.js > out.pretty.js

java -cp cljs-1.9.946.jar com.google.javascript.jscomp.CommandLineRunner --compilation_level ADVANCED --js out/'**.js' --manage_closure_dependencies --closure_entry_point bug.core --js_output_file advanced.js --third_party
