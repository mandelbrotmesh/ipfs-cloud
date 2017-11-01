module State exposing (..)

import Types exposing (..)
import MimeType exposing (..)
import Ports exposing (..)

model : Types.Model
model =
  { searchfield = ""
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
    Searchfield_msg msg ->
      ( {model | searchfield = msg}, Cmd.none )
    Ipfs_cat msg ->
      (model, ipfs_cmd {action = "cat", maddr = model.searchfield} )
    Ipfs_add msg ->
      (model, ipfs_cmd {action= "add", maddr= msg})
    Ipfs_pin msg ->
      (model, ipfs_cmd {action= "pin", maddr= msg})
    Ipfs_pin_ls msg ->
      (model, ipfs_cmd {action= "pin_ls", maddr= msg})
    -- Ipfs_cmd msg ->
    --   (model, ipfs_cmd_send msg )
    Ipfs_answer msg ->
      ( { model | files = msg }, Cmd.none )

    -- Acc_submit_msg msg ->
    --   ( model, acc_submit msg )
    -- Use_drawer msg ->
    --   ( {model | drawer_isopen = msg}, Cmd.none)
    -- Open_account_options msg ->
    --   ( {model | account_options_open = msg}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  ipfs_answer Ipfs_answer
  -- Sub.batch
  --   [ ipfs_answer Ipfs_answer ]
