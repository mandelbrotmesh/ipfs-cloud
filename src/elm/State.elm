module State exposing (..)

import Types exposing (..)
-- import MimeType exposing (..)
import Ports exposing (..)
import Utils exposing (..)
import List exposing (filter)
import String exposing (contains, startsWith, toLower)
import Navigation exposing (Location, modifyUrl)

init : Types.Model
init =
  { action = Showing_img "" "QmUDhFjiVkHaQUvsViPm6ueM4WuV9ZeRm9JVnGD13ec9zS"
  , search = General ""
  , files = []
  , this_device = { peerid = "empty peerid", pins = [], last_update = 0 }
  , devices = []
  , uploads = []
  , drawer_isopen = False
  }

--  "QmUDhFjiVkHaQUvsViPm6ueM4WuV9ZeRm9JVnGD13ec9zS"
--  {maddr = "Qma7cGNxVCVHwcjzYzDgR34hPxeSg1FsFHUNk1ytz8XASY", mime = "inode/directory", ispinned = False}
--  {maddr = "QmTca4A43f4kEvzTouvYTegtp6KobixRqweV12NrvwwtFP", mime = "video/mp4", ispinned = False}
--  {maddr = "QmaMc3URC5Jqt3HrfP2beBkB56Y232YUqR3itguzup91je", mime = "audio/ogg", ispinned = False}

-- ipfs_cmd_send : Ipfs_cmd -> Cmd msg
-- ipfs_cmd_send msg =
--   case msg of
--     Ipfs_get msg ->
--       ipfs_cmd msg
--     Ipfs_pin msg ->
--       ipfs_cmd msg
--     Ipfs_pin_ls msg ->
--       ipfs_cmd msg

--url be like https://origin:port/action/ipfs/Qm...

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Action_switch val ->
      ( {model | action = val}
      , modifyUrl
          ( case val of
              Acc_settings -> "acc_settings"
              Node_settings -> "node_settings"
              History -> "history"
              Browsing fil hash -> hash
              Showing_img val hash -> hash
              Playing_audio val hash -> hash
              Playing_video val hash -> hash
              Viewing_text val hash -> hash
          )
      )
    -- Url_change location ->
      -- ({ model | page = (get_page location) }, modifyUrl (location.pathname ++ location.hash))-- Cmd.none)
    -- Browsing stuff maddr ->
      -- ({model | files = stuff, page = Browser stuff}, Cmd.none) --modifyUrl ("#browser/ipfs/" ++ maddr) )--Cmd.none) --stuff <| Utils.action "#browsing" ""}, Cmd.none)
    Search_msg msg ->
      ( {model | search = General msg}, Cmd.none )
    Open_drawer msg ->
      ( {model | drawer_isopen = msg}, Cmd.none)
    Ipfs_cat msg ->
      (model, ipfs_cmd {action = "cat", maddr = .maddr msg, wanttype = Just (.wanttype msg)} )
    Ipfs_add msg ->
      (model, ipfs_cmd {action= "add", maddr= msg, wanttype = Nothing})
    Ipfs_pin msg ->
      (model, ipfs_cmd {action= "pin", maddr= msg, wanttype = Just model.this_device.peerid})
    Ipfs_pin_ls msg ->
      (model, ipfs_cmd {action= "pin_ls", maddr= msg, wanttype = Nothing})
    Ipfs_dag_get msg ->
      (model, ipfs_cmd {action= "dag_get", maddr= msg, wanttype = Nothing})
    Ipfs_device_infos ->
      (model, ipfs_cmd {action= "device_infos", maddr="", wanttype = Nothing})
    Upload_info msg ->
      ( {model| uploads = msg}, Cmd.none )
    Device_infos msg ->
      ( { model | this_device =
            { peerid = Utils.dec_dev_infos msg
            , pins = model.this_device.pins
            , last_update = model.this_device.last_update
            }
        }
      , Cmd.none
      )

    -- Ipfs_cmd msg ->
    --   (model, ipfs_cmd_send msg )
    Ipfs_msg msg ->
      -- ( { model | page = Browser [] }, Cmd.none)
      ( { model | action = Browsing [] "" }, Cmd.none)

-- Browsing (Utils.dag_json_to_dag_node msg)

    -- Ipfs_asset_msg msg ->
    --   ( { model | action = Playing_audio msg }, Cmd.none)

    -- Acc_submit_msg msg ->
    --   ( model, acc_submit msg )
    -- Use_drawer msg ->
    --   ( {model | drawer_isopen = msg}, Cmd.none)
    -- Open_account_options msg ->
    --   ( {model | account_options_open = msg}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ ipfs_answer Utils.decide --Ipfs_msg
    -- , ipfs_asset Ipfs_asset_msg
    ]
    -- ipfs_answer Ipfs_msg
