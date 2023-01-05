open Alcotest
open Core
module M = Core.StringMap

let make_tests ?headers rules =
  let make_msg body =
    let open Core in
    { env=
        StringMap.singleton "S_TOKEN" "token" |> StringMap.add "TG_TOKEN" "123"
    ; headers=
        Option.value headers
          ~default:
            (StringMap.singleton "x-telegram-bot-api-secret-token" "token")
    ; body }
  in
  List.map
    (fun (expected, input) ->
      let expected =
        expected
        |> Option.map (fun x ->
               {url= "https://api.telegram.org/bot123/deleteMessage"; body= x} )
      in
      test_case "test" `Quick (fun _ ->
          let cmd_fmt =
            Fmt.record
              [ Fmt.field "url" (fun x -> x.url) Fmt.string
              ; Fmt.field "body" (fun x -> x.body) Fmt.string ]
          in
          check
            (option (of_pp cmd_fmt))
            "" expected
            (Core.handle (make_msg input)) ) )
    rules

let samples =
  [ (None, {|{}|})
  ; ( None
    , {|{"update_id":569999999,"message":{"message_id":4699,"from":{"id":249999999,"is_bot":false,"first_name":"JohnDoe","username":"johndoe","language_code":"en"},"chat":{"id":249999999,"first_name":"JohnDoe","username":"johndoe","type":"private"},"date":1699999999,"text":"hello"}}|}
    )
  ; ( Some {|{"chat_id":-1001000000000,"message_id":12000}|}
    , {|{"update_id":560000000,"message":{"message_id":12000,"from":{"id":240000000,"is_bot":false,"first_name":"Alex","username":"alex000","language_code":"en"},"chat":{"id":-1001000000000,"title":"GroupName","type":"supergroup"},"date":1600000000,"new_chat_participant":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_member":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_members":[{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"}]}}|}
    ) ]
  |> make_tests

let auth_base =
  [ (None, {|{}|})
  ; ( None
    , {|{"update_id":569999999,"message":{"message_id":4699,"from":{"id":249999999,"is_bot":false,"first_name":"JohnDoe","username":"johndoe","language_code":"en"},"chat":{"id":249999999,"first_name":"JohnDoe","username":"johndoe","type":"private"},"date":1699999999,"text":"hello"}}|}
    )
  ; ( None
    , {|{"update_id":560000000,"message":{"message_id":12000,"from":{"id":240000000,"is_bot":false,"first_name":"Alex","username":"alex000","language_code":"en"},"chat":{"id":-1001000000000,"title":"GroupName","type":"supergroup"},"date":1600000000,"new_chat_participant":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_member":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_members":[{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"}]}}|}
    )
  ; ( None
    , {|{"update_id":560000000,"message":{"message_id":12000,"from":{"id":240000000,"is_bot":false,"first_name":"Alex","username":"alex000","language_code":"en"},"chat":{"id":-1001000000000,"title":"GroupName","type":"supergroup"},"date":1600000000,"new_chat_participant":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_member":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_members":[{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"}]}}|}
    ) ]

let auth = auth_base |> make_tests ~headers:M.empty

let auth2 =
  auth_base
  |> make_tests
       ~headers:(M.singleton "x-telegram-bot-api-secret-token" "token2")

let () =
  run "tests" [("message parse", samples); ("auth", auth); ("auth2", auth2)]
