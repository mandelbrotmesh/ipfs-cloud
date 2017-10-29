port module Types exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color exposing (..)
import MimeType exposing (..)

type alias Maddr
  = String

type alias Mime
  = String

type alias File =
  { maddr : Maddr
  , mime : Mime
  }

type alias Model =
  { searchfield : String
  , files : (List File)
  }

type Msg
  = Searchfield_msg String
  | Ipfs_get --Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Bool
  | Ipfs_answer (List File)

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
