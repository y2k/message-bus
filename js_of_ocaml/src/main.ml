open Js_of_ocaml
module U = Js.Unsafe

let response_with event body =
  event##respondWith
    (U.meth_call (U.pure_js_expr "Response") "json" [| U.inject body |])
  |> ignore

let () =
  U.global##addEventListener "fetch" (fun event ->
      let r = event##.request##.body in
      response_with event r)
