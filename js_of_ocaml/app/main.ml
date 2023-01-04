open Js_of_ocaml

module Utils = struct
  module U = Js_of_ocaml.Js.Unsafe
  module StringMap = Map.Make (String)

  let object_to_string_map obj =
    obj |> Js.object_keys |> Js.to_array
    |> Array.fold_left
         (fun a k ->
           if Js.typeof k = Js.string "string" then
             StringMap.add (Js.to_string k) (U.get obj k |> Js.to_string) a
           else a )
         StringMap.empty

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
      match
        Core.handle
          { env= Utils.object_to_string_map env
          ; headers= Utils.object_to_string_map req##.headers
          ; body= Js.to_string body }
      with
      | Some cmd ->
          let promise = Utils.post cmd.url cmd.body in
          promise##then_ (fun _ -> Utils.make_response "")
      | None ->
          Utils.make_response "" )

let () = Js.export "fetch" fetch
