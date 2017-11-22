#!/bin/bash -ex

rm -rf out
rm -rf out.js
java -cp cljs-1.9.946.jar:src clojure.main compile.clj
cat out.js