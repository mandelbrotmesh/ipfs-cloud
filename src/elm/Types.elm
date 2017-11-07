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
  , wanttype : Maybe String
  }

type alias File =
  { multihash : Maddr
  , name : String
  , mime : Mime
  , pinnedby : List String
  , action : Msg
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
  = Browsing Dag_node --Files
  | Showing_img Maddr
  | Playing_audio Maddr
  | Playing_video Maddr

type Media
  = Image
  | Audio
  | Video
  | Text

type alias Model =
  { action : Action
  , searchfield : String
  , files : Files
  }

type alias Ipld_node = String

-- type alias Pin_list =
--   { maddr: List Maddr }

type alias Dag_link =
  { name : String
  , multihash : Maddr
  , size : Int
  }

type alias Dag_node =
  { data : List Int
  , links : List Dag_link
  , multihash : Maddr
  , size : Int
  }

type alias Ipfs_answer =
  { answertype : String
  , value : String
  }

type alias Url = String
  --| Err
  --   { val_type : String
  -- , val : String }

type Msg
  = Searchfield_msg String
  | Action_switch Action
  | Ipfs_cat {maddr : Maddr, wanttype: String}
  | Ipfs_add Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Maddr
  | Ipfs_dag_get Maddr
  -- | Ipfs_cmd Ipfs_action
  | Ipfs_msg Ipfs_answer
  -- | Ipfs_asset_msg String

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
