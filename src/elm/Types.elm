port module Types exposing (..)
import Time exposing (..)
import Navigation exposing (..)
--import MimeType exposing (..)

type alias Maddr
  = String

type Mediatype
  = Folder
  | Link
  | Image
  | Audio
  | Video
  | Text
  | Other


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
  , mediatype : Mediatype
  , pinnedby : List String
  -- , action : Msg
  }

type alias Device =
  { peerid : String
  , pins : List String
  , last_update : Time
  }



type Styles
  = None
  | Overlay
  | Drawerstyle
  | Drawerbuttonstyle
  | Menustyle
  | Menubuttonstyle
  | Searchbarstyle
  | Searchbarbuttonstyle
  | Browserstyle
  | Filestyle

type Search
  = General String
  | By_hash String
  | By_type String
  | By_peer String
  | Qr
  | Path (List String)
  | Inhistory


type alias Files =
  List File

-- type Action
--   = Account



type Action
  = Home
  | Acc_settings
  | Node_settings
  | Uploads
  | Devices
  | History
  | Browsing Files Maddr--Dag_node
  | Showing_img Url Maddr
  | Playing_audio Url Maddr
  | Playing_video Url Maddr
  | Viewing_text Url Maddr


type alias Model =
  { --action : Action
   action : Action
  , search : Search
  , files : Files
  , this_device : Device
  , devices : List Device
  , uploads : List Upload
  , drawer_isopen : Bool
  }

type alias Ipld_node = String

-- type alias Pin_list =
--   { maddr: List Maddr }

type alias Dag_link =
  { name : String
  , multihash : Maddr
  , size : Int
  }

type alias Connection
  = List String

type alias Upload =
  { dag_info : Dag_node
  , uploaded_portion : Int
  , peer : String
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
  , hash : String
  }



type alias Url = String
  --| Err
  --   { val_type : String
  -- , val : String }

type Msg
  = Search_msg String
  | Action_switch Action
  | Ext_url Navigation.Location
  -- | Url_change Navigation.Location
  -- | Browsing Files Maddr
  | Open_drawer Bool
  | Ipfs_cat {maddr : Maddr, wanttype: String}
  | Ipfs_add Maddr
  | Ipfs_pin Maddr
  | Ipfs_pin_ls Maddr
  | Ipfs_dag_get Maddr
  | Ipfs_device_infos
  | Upload_info (List Upload)
  | Device_infos String
  -- | Ipfs_cmd Ipfs_action
  | Ipfs_msg Ipfs_answer
  -- | Ipfs_asset_msg String

  -- | Ipfs_add Bool

  -- | Use_drawer Bool
  -- | Open_account_options Bool
