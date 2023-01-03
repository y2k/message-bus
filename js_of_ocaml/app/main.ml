open Js_of_ocaml

module Utils = struct
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

  let make_string_env env =
    let module StringMap = Map.Make (String) in
    env |> Js.object_keys |> Js.to_array
    |> Array.fold_left
         (fun a k ->
           if Js.typeof k = Js.string "string" then
             StringMap.add (Js.to_string k) (U.get env k |> Js.to_string) a
           else (
             print_endline ("ERROR: " ^ (Js.typeof k |> Js.to_string)) ;
             a ) )
         StringMap.empty

  let log_headers req env =
    get_headers req |> Array.iter (fun (k, v) -> Printf.printf "%s: %s\n" k v) ;
    print_endline ""

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
let fetch req env =
  req##text##then_ (fun body ->
      let url =
        Printf.sprintf "https://api.telegram.org/bot%s/deletemessage" "<token>"
      in
      match
        Core.handle
          (Utils.make_string_env env)
          (Utils.get_headers req) (Js.to_string body)
      with
      | Some body ->
          let promise = Utils.post url body in
          promise##then_ (fun _ -> Utils.make_response "")
      | None ->
          Utils.make_response "" )

let () = Js.export "fetch" fetch
