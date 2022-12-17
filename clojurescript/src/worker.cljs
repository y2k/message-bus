(ns worker)

; async fetch(request, env, ctx) {
; 	return new Response("Hello from Y2k");
; },

;; isTrusted
;; request
;; \_ body,bodyUsed,headers,cf,signal,redirect,url,method

(js/addEventListener
 "fetch"
 (fn [event]
   (.respondWith
    event
    (js/Response. (str
                   "request: " event.request
                   "\n\\ request.url: " event.request.url
                   "\n\\ isTrusted: " event.isTrusted
                   "\n\\ body: " event.request.body
                   "\n\\ bodyUsed: " event.request.bodyUsed
                   "\n\\ headers: "
                   (->>
                    (vec event.request.headers)
                    (reduce (fn [a [k v]] (assoc a (keyword k) v)) {})))))))
