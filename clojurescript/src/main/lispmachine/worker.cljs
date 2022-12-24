(ns lispmachine.worker)

(defn- fetch [request env]
  (let [path (.-pathname (js/URL. request.url))
        r1 (.exec #"/([a-z]+)/(\d+)" path)]
    (if (and (= "GET" request.method) (some? r1))
      (->
       env.MESSAGE_LOG
       (.prepare "SELECT id, topic, data FROM log WHERE topic = ?1 AND id >= ?2 ORDER BY id LIMIT 1")
       (.bind (.at r1 1) (.at r1 2))
       (.first)
       (.then
        (fn [xs]
          (if (some? xs)
            (js/Response.
             (js/atob xs.data)
             (clj->js {:headers
                       {:x-id xs.id
                        :content-type "application/octet-stream"}}))
            (js/Response. "" #js{:status 204})))))
      (let [r1 (.exec #"/([a-z]+)" path)]
        (if (and (= "POST" request.method) (some? r1))
          (->
           (.text request)
           (.then
            (fn [ab]
              (->
               env.MESSAGE_LOG
               (.prepare "INSERT INTO log (topic, data) VALUES (?1, ?2)")
               (.bind (.at r1 1) (js/btoa ab))
               (.run)
               (.then
                (fn [r] (js/Response. "" #js{:status 204}))))))))))))

(def eventHandlers #js {:fetch fetch})
