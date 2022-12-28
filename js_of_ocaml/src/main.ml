open Js_of_ocaml
module U = Js.Unsafe

let response_with event body =
  event##respondWith
    (U.meth_call (U.pure_js_expr "Response") "json" [| U.inject body |])
  |> ignore

let () =
  U.global##addEventListener "fetch" (fun event ->
      event##.request##text##then_ (fun json ->
          print_endline @@ "JSON: " ^ json;
          response_with event json)
      (* let jp = event##.request##json in *)
      (* jp##then_ (fun json -> response_with event json) *))
