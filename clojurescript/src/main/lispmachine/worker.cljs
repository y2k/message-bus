(ns lispmachine.worker)

; async fetch(request, env, ctx) {
; 	return new Response("Hello from Y2k");
; },

;; isTrusted
;; request
;; \_ body,bodyUsed,headers,cf,signal,redirect,url,method


 ;; if (pathname === "/api/beverages")  {
    ;;   const { results } = await env.<BINDING_NAME>.prepare(
    ;;     "SELECT * FROM Customers WHERE CompanyName = ?"
    ;;   )
    ;;     .bind("Bs Beverages")
    ;;     .all();
    ;;   return Response.json(results)
    ;; }

#_(js/addEventListener
 "fetch"
 (fn [event]
   (->
    #_(.prepare js/MESSAGE_LOG "SELECT * FROM log")
    #_(.all)
    (js/Promise.resolve 0)
    (.then (fn [x] (js/Response.json "hello")))
    (.then (fn [x] (.respondWith event x)))
    )
   ))

(def eventHandlers
 #js {:fetch
      (fn [request env]
        (js/Response. (str "ML:" (js/Object.keys env)))
        #_(->
         env.MESSAGE_LOG
         (.prepare "SELECT * FROM log")
         (.all)
         (.then (js/Response.))))})

#_(def ^:export fetch
  (fn [req]
    (js/Response. "hello world")))

#_(js/addEventListener
 "fetch"
  (fn [event]
    (.respondWith
      event
      #_(js/Response.json (.get js/MESSAGES "foo"))
      (js/Response.json js/MESSAGE_LOG)
      )))
