module State exposing (..)

import Types exposing (..)
-- import MimeType exposing (..)
import Ports exposing (..)
import Utils exposing (..)

model : Types.Model
model =
  { action = Showing_img "QmUDhFjiVkHaQUvsViPm6ueM4WuV9ZeRm9JVnGD13ec9zS" --[] --[ {maddr = "Qma7cGNxVCVHwcjzYzDgR34hPxeSg1FsFHUNk1ytz8XASY", mime = "inode/directory", ispinned = False}
                      -- , {maddr = "QmTca4A43f4kEvzTouvYTegtp6KobixRqweV12NrvwwtFP", mime = "video/mp4", ispinned = False}
                      -- , {maddr = "QmaMc3URC5Jqt3HrfP2beBkB56Y232YUqR3itguzup91je", mime = "audio/ogg", ispinned = False}
                      -- ]
  , searchfield = ""
  , files = []
  }

-- ipfs_cmd_send : Ipfs_cmd -> Cmd msg
-- ipfs_cmd_send msg =
--   case msg of
--     Ipfs_get msg ->
--       ipfs_cmd msg
--     Ipfs_pin msg ->
--       ipfs_cmd msg
--     Ipfs_pin_ls msg ->
--       ipfs_cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Action_switch msg ->
      ( {model | action = msg}, Cmd.none)
    Searchfield_msg msg ->
      ( {model | searchfield = msg}, Cmd.none )
    Ipfs_cat msg ->
      (model, ipfs_cmd {action = "cat", maddr = .maddr msg, wanttype = Just (.wanttype msg)} )
    Ipfs_add msg ->
      (model, ipfs_cmd {action= "add", maddr= msg, wanttype = Nothing})
    Ipfs_pin msg ->
      (model, ipfs_cmd {action= "pin", maddr= msg, wanttype = Nothing})
    Ipfs_pin_ls msg ->
      (model, ipfs_cmd {action= "pin_ls", maddr= msg, wanttype = Nothing})
    Ipfs_dag_get msg ->
      (model, ipfs_cmd {action= "dag_get", maddr= msg, wanttype = Nothing})
    -- Ipfs_cmd msg ->
    --   (model, ipfs_cmd_send msg )
    Ipfs_msg msg ->
      ( { model | action = Utils.decide msg}, Cmd.none)

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
    [ ipfs_answer Ipfs_msg
    -- , ipfs_asset Ipfs_asset_msg
    ]
    -- ipfs_answer Ipfs_msg
