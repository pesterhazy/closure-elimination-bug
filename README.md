This repo illustrates the case when Google Closure compiler eliminates assignments.

```clojure
(ns bug.core
  (:require
    [goog.object :as gobj]))


(defn get-obj []
  (js/document.querySelector "body"))


(defn ^:export aaa []
  (js/console.log "aaa start")
  (gobj/set (get-obj) "className" "+++aaa+++")
  (js/console.log "aaa end"))


(defn ^:export bbb []
  (js/console.log "bbb start")
  (set! (.-className (get-obj)) "+++bbb+++")
  (js/console.log "bbb end"))


(defn ^:export ccc []
  (js/console.log "ccc start")
  (aset (get-obj) "className" "+++ccc+++")
  (js/console.log "ccc end"))
```

compiles by ClojureScript down to:

```javascript
// Compiled by ClojureScript 1.9.946 {:static-fns true, :optimize-constants true}
goog.provide('bug.core');
goog.require('cljs.core');
goog.require('cljs.core.constants');
goog.require('goog.object');
bug.core.get_obj = (function bug$core$get_obj(){
return document.querySelector("body");
});
bug.core.aaa = (function bug$core$aaa(){
console.log("aaa start");

var G__4263_4266 = bug.core.get_obj();
var G__4264_4267 = "className";
var G__4265_4268 = "+++aaa+++";
goog.object.set(G__4263_4266,G__4264_4267,G__4265_4268);

return console.log("aaa end");
});
goog.exportSymbol('bug.core.aaa', bug.core.aaa);
bug.core.bbb = (function bug$core$bbb(){
console.log("bbb\u00A0start");

bug.core.get_obj().className = "+++bbb+++";

return console.log("bbb end");
});
goog.exportSymbol('bug.core.bbb', bug.core.bbb);
bug.core.ccc = (function bug$core$ccc(){
console.log("ccc start");

(bug.core.get_obj()["className"] = "+++ccc+++");

return console.log("ccc end");
});
goog.exportSymbol('bug.core.ccc', bug.core.ccc);
```

which then gets compressed by Closure Compiler to:

```javascript
l("bug.core.aaa", function() {
  console.log("aaa start");
  return console.log("aaa end");
});
l("bug.core.bbb", function() {
  console.log("bbb start");
  return console.log("bbb end");
});
l("bug.core.ccc", function() {
  console.log("ccc start");
  return console.log("ccc end");
});
```

**Expected: assignments are not deleted.**

Strangely enough, adding `^:export` to `get-obj` stops GCC from deleting `get-obj` and restores assignments:

```javascript
function I() {
  return document.querySelector("body");
}
l("bug.core.get_obj", I);
l("bug.core.aaa", function() {
  console.log("aaa start");
  I().className = "+++aaa+++";
  return console.log("aaa end");
});
l("bug.core.bbb", function() {
  console.log("bbb start");
  I().className = "+++bbb+++";
  return console.log("bbb end");
});
l("bug.core.ccc", function() {
  console.log("ccc start");
  I().className = "+++ccc+++";
  return console.log("ccc end");
});
```