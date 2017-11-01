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

-- type Ipfs_action
--   = Ipfs_get
--   | Ipfs_pin
--   | Ipfs_pin_ls

type alias Ipfs_cmd =
  { action: String
  , maddr: Maddr
  }

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
  | Ipfs_cat Maddr
  | Ipfs_add Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Maddr
  -- | Ipfs_cmd Ipfs_action
  | Ipfs_answer (List File)

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
