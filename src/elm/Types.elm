port module Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color exposing (..)

port acc_submit : String -> Cmd msg
port ipfs_get : String -> Cmd msg
port ipfs_answer : ( File -> msg) -> Sub msg

type alias File =
  { url : String
  , mime : String}

type alias Model =
  { drawer_isopen : Bool
  , account_options_open : Bool
  , files : List File
  }

type Msg
  = Acc_submit_msg String
  | Ipfs_get String
  | Ipfs_answer File
  | Use_drawer Bool
  | Open_account_options Bool
