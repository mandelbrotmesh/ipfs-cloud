port module Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color exposing (..)

port acc_submit : String -> Cmd msg

type alias Model =
  { drawer_isopen : Bool
  , account_options_open : Bool
  , files : List String
  }

type Msg
  = Acc_submit_msg String
  | Use_drawer Bool
  | Open_account_options Bool
