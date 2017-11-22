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
