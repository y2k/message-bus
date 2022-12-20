(ns worker)

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

(js/addEventListener
 "fetch"
 (fn [event]
   (->
    (.prepare js/MESSAGE_LOG "SELECT * FROM log")
    (.all)
    (.then (fn [x] (js/Response.json x)))
    (.then (fn [x] (.respondWith event x)))
    )
   ))




   #_(.respondWith
    event
    (js/Response.json (clj->js {:a 1}))
    ;; (js/Response. (str
    ;;                "request: " event.request
    ;;                "\n\\ request.url: " event.request.url
    ;;                "\n\\ isTrusted: " event.isTrusted
    ;;                "\n\\ body: " event.request.body
    ;;                "\n\\ bodyUsed: " event.request.bodyUsed
    ;;                "\n\\ headers: "
    ;;                (->>
    ;;                 (vec event.request.headers)
    ;;                 (reduce (fn [a [k v]] (assoc a (keyword k) v)) {})
    ;;                 )))

   )
