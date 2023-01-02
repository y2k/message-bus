open Js_of_ocaml

module Fetch = struct
  module U = Js_of_ocaml.Js.Unsafe

  let get_headers req =
    U.global ##. Array##from req##.headers##entries
    |> Js.to_array
    |> Array.map (fun x ->
           match Js.to_array x with
           | [|key; value|] ->
               (Js.to_string key, Js.to_string value)
           | _ ->
               failwith "unreachable" )

  let log_headrs req =
    (* req##.headers##entries##toString *)
    (* |> Js.to_string *)
    (* |> Printf.printf "Headers3: %s\n" ; *)
    get_headers req |> Array.iter (fun (k, v) -> Printf.printf "%s: %s\n" k v) ;
    print_endline ""
  (* |> Js.to_array *)
  (* |> Array.map (fun x -> Js.to_string x) *)
  (* |> Array.iter print_endline *)

  let make_response (body : string) =
    U.new_obj U.global ##. Response [|U.inject body|]

  let post (url : string) (body : string) =
    U.global##fetch (U.inject url)
      (U.obj
         [| ("method", U.inject "post")
          ; ("body", U.inject body)
          ; ("headers", U.obj [|("content-type", U.inject "application/json")|])
         |] )
end

(* application/json *)
let fetch req =
  req##text##then_ (fun body ->
      Fetch.log_headrs req ;
      let json = Js.to_string body in
      let url =
        Printf.sprintf "https://api.telegram.org/bot%s/deletemessage" "<token>"
      in
      match Core.handle json with
      | Some body ->
          let promise = Fetch.post url body in
          promise##then_ (fun _ -> Fetch.make_response "")
      | None ->
          Fetch.make_response "" )

let () = Js.export "fetch" fetch
