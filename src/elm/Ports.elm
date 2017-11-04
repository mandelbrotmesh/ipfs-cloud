port module Ports exposing (..)
import Types exposing (..)
--
-- port ipfs_get : Types.Maddr -> Cmd msg
-- port ipfs_pin : Types.Maddr -> Cmd msg
-- port ipfs_pin_ls : Bool -> Cmd msg --List Types.File

port ipfs_cmd : Types.Ipfs_cmd -> Cmd msg
port ipfs_answer : (Types.Ipfs_answer -> msg) -> Sub msg -- (List Types.File -> msg) -> Sub msg


-- port acc_submit : String -> Cmd msg
-- port ipfs_add : Bool -> Cmd msg
