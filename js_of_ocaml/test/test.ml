open Alcotest

let samples =
  [ (None, {|{}|})
  ; ( None
    , {|{"update_id":569999999,"message":{"message_id":4699,"from":{"id":249999999,"is_bot":false,"first_name":"JohnDoe","username":"johndoe","language_code":"en"},"chat":{"id":249999999,"first_name":"JohnDoe","username":"johndoe","type":"private"},"date":1699999999,"text":"hello"}}|}
    )
  ; ( Some {|{"chat_id":-1001000000000,"message_id":12000}|}
    , {|{"update_id":560000000,"message":{"message_id":12000,"from":{"id":240000000,"is_bot":false,"first_name":"Alex","username":"alex000","language_code":"en"},"chat":{"id":-1001000000000,"title":"GroupName","type":"supergroup"},"date":1600000000,"new_chat_participant":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_member":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_members":[{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"}]}}|}
    ) ]
  |> List.map (fun (expected, input) ->
         test_case "test" `Quick (fun _ ->
             check (option string) "" expected (Core.handle input) ) )

let () = run "tests" [("", samples)]
