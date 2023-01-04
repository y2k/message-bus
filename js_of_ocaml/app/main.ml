open Js_of_ocaml

module Utils = struct
  module U = Js_of_ocaml.Js.Unsafe
  module StringMap = Map.Make (String)

  let entries_to_string_map entries =
    U.global ##. Array##from entries
    |> Js.to_array
    |> Array.fold_left
         (fun a e ->
           let k = e##at 0 in
           let v = e##at 1 in
           if Js.typeof k = Js.string "string" then
             StringMap.add (Js.to_string k) (Js.to_string v) a
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

  let get_entries obj = U.global ##. Object##entries obj

  let log_error e = U.global##.console##error e
end

(* application/json *)
let fetch req env =
  req##text##then_ (fun body ->
      match
        Core.handle
          { env= Utils.entries_to_string_map (Utils.get_entries env)
          ; headers= Utils.entries_to_string_map req##.headers
          ; body= Js.to_string body }
      with
      | Some cmd ->
          let promise = Utils.post cmd.url cmd.body in
          (promise##catch (fun e -> Utils.log_error e))##then_ (fun _ ->
              Utils.make_response "" )
      | None ->
          Utils.make_response "" )

let () = Js.export "fetch" fetch
