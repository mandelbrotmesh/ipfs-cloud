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

type alias Cid_rec =
  { cid : String
  , name : String
  , size : Int
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
  = Browsing Ipld_node --Files
  | Showing_img Maddr
  | Playing_audio Maddr
  | Playing_video Maddr


type alias Model =
  { action : Action
  , searchfield : String
  , files : Files
  }

type alias Ipld_node = String

-- type alias Pin_list =
--   { maddr: List Maddr }


type alias Ipfs_answer = String

type Msg
  = Searchfield_msg String
  | Action_switch Action
  | Ipfs_cat Maddr
  | Ipfs_add Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Maddr
  | Ipfs_dag_get Maddr
  -- | Ipfs_cmd Ipfs_action
  | Ipfs_msg Ipfs_answer

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
