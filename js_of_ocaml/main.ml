open Js_of_ocaml
module U = Js.Unsafe

let response_with event body =
  event##respondWith (U.new_obj (U.pure_js_expr "Response") [| U.inject body |])
  |> ignore

let () =
  U.global##addEventListener "fetch3" (fun event ->
      response_with event "event")
