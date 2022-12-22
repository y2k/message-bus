(ns lispmachine.worker)

(defn- fetch [request env]
  (->
   env.MESSAGE_LOG
   (.prepare "SELECT topic, data FROM log ORDER BY _id LIMIT 10")
   (.all)
   (.then (fn [xs] (js/Response.json xs.results)))))

(def eventHandlers #js {:fetch fetch})
