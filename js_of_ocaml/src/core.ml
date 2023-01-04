module J = Yojson.Safe
module U = Yojson.Safe.Util

module StringMap = struct
  include Map.Make (String)

  let pp _ ppf m =
    Format.fprintf ppf "{" ;
    iter (fun k v -> Format.fprintf ppf "\"%s\": \"%s\"; " k v) m ;
    Format.fprintf ppf "}"
end

type http_msg_props =
  {env: string StringMap.t; headers: string StringMap.t; body: string}
[@@deriving show]

type http_cmd_props = {url: string; body: string} [@@deriving show]

let handle' ({body; env; _} : http_msg_props) =
  match J.from_string body |> U.member "message" with
  | `Null ->
      None
  | message ->
      if U.keys message |> List.mem "new_chat_member" then
        let url =
          Printf.sprintf "https://api.telegram.org/bot%s/deleteMessage"
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
      handle' msg
  | _ ->
      None

let handle (msg : http_msg_props) : http_cmd_props option =
  print_endline @@ "LOG:MSG: " ^ show_http_msg_props msg ^ "\n" ;
  let result = handle'' msg in
  Option.iter
    (fun x -> print_endline @@ "LOG:CMD: " ^ show_http_cmd_props x ^ "\n")
    result ;
  result
