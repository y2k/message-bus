open Js_of_ocaml

let fetch req =
  req##text##then_ (fun body ->
      let json = Js.to_string body in
      Core.handle json |> ignore )

let () = Js.export "fetch" fetch