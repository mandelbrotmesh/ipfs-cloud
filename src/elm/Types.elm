port module Types exposing (..)

--import MimeType exposing (..)

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
  , ispinned : Bool
  }

type Styles
  = None
  | Menustyle
  | Menubuttonstyle
  | Searchbarstyle
  | Searchbarbuttonstyle
  | Browserstyle
  | Filestyle


type alias Files =
  List File

type Action
  = Browsing Files
  | Showing_img Maddr
  | Playing_audio Maddr
  | Playing_video Maddr


type alias Model =
  { action : Action
  , searchfield : String
  , files : Files
  }

type Msg
  = Searchfield_msg String
  | Action_switch Action
  | Ipfs_cat Maddr
  | Ipfs_add Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Maddr
  -- | Ipfs_cmd Ipfs_action
  | Ipfs_answer Files

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
