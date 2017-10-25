port module Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color exposing (..)
import MimeType exposing (..)

port acc_submit : String -> Cmd msg
port ipfs_get : String -> Cmd msg
port ipfs_answer : ( Answer -> msg) -> Sub msg

type alias Answer =
  { url: String
  , mime: String}

type alias File =
  { url : String
  , mime : (Maybe MimeType)}

type alias Model =
  { drawer_isopen : Bool
  , account_options_open : Bool
  , searchfield : String
  , files : List File
  }

type Msg
  = Acc_submit_msg String
  | Searchfield_msg String
  | Ipfs_get
  | Ipfs_get_by_hs String
  | Ipfs_answer Answer
  | Use_drawer Bool
  | Open_account_options Bool
