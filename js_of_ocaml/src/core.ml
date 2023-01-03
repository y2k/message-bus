module J = Yojson.Safe
module U = Yojson.Safe.Util

let handle _env _headers (body : string) =
  match J.from_string body |> U.member "message" with
  | `Null ->
      None
  | message ->
      if U.keys message |> List.mem "new_chat_member" then
        Some
          ( `Assoc
              [ ("chat_id", message |> U.member "chat" |> U.member "id")
              ; ("message_id", message |> U.member "message_id") ]
          |> Yojson.Safe.to_string )
      else None
