module J = Yojson.Safe
module U = Yojson.Safe.Util
module StringMap = Map.Make (String)

type http_msg_props =
  {env: string StringMap.t; headers: string StringMap.t; body: string}

type http_cmd_props = {url: string; body: string}

let handle_ ({body; env; _} : http_msg_props) =
  match J.from_string body |> U.member "message" with
  | `Null ->
      None
  | message ->
      if U.keys message |> List.mem "new_chat_member" then
        let url =
          Printf.sprintf "https://api.telegram.org/bot%s/deletemessage"
            (StringMap.find "TG_TOKEN" env)
        in
        Some
          { url
          ; body=
              `Assoc
                [ ("chat_id", message |> U.member "chat" |> U.member "id")
                ; ("message_id", message |> U.member "message_id") ]
              |> Yojson.Safe.to_string }
      else None

let handle'' ({env; headers; _} as msg) =
  let hst = StringMap.find_opt "x-telegram-bot-api-secret-token" headers in
  let st = StringMap.find_opt "S_TOKEN" env in
  match (st, hst) with
  | Some st, Some hst when st = hst ->
      handle_ msg
  | _ ->
      None

let handle (msg : http_msg_props) : http_cmd_props option =
  let result = handle'' in
  result
