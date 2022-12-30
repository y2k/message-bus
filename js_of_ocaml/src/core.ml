module J = Yojson.Safe
module U = Yojson.Safe.Util

let handle (body : string) : int option =
  let message = J.from_string body |> U.member "message" in
  if U.keys message |> List.mem "new_chat_member" then
    Some (message |> U.member "message_id" |> U.to_int)
  else None