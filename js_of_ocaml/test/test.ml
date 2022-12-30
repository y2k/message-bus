(* open Core *)
open Alcotest

let test_1 () =
  check (option int) "" (Some 12000)
    (Core.handle
       {|{"update_id":560000000,"message":{"message_id":12000,"from":{"id":240000000,"is_bot":false,"first_name":"Alex","username":"alex000","language_code":"en"},"chat":{"id":-1001000000000,"title":"GroupName","type":"supergroup"},"date":1600000000,"new_chat_participant":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_member":{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"},"new_chat_members":[{"id":1300000000,"is_bot":true,"first_name":"Docker","username":"docker_bot"}]}}|} )

let test_2 () =
  check (option int) "" None
    (Core.handle
       {|{"update_id":569999999,"message":{"message_id":4699,"from":{"id":249999999,"is_bot":false,"first_name":"JohnDoe","username":"johndoe","language_code":"en"},"chat":{"id":249999999,"first_name":"JohnDoe","username":"johndoe","type":"private"},"date":1699999999,"text":"hello"}}|} )

let test_3 () = check (option int) "" None (Core.handle {|{}|})

let () =
  run "tests"
    [ ( ""
      , [ test_case "test #1" `Quick test_1
        ; test_case "test #2" `Quick test_2
        ; test_case "test #3" `Quick test_3 ] ) ]