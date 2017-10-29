module State exposing (..)

import Types exposing (..)
import MimeType exposing (..)
import Ports exposing (..)

model : Types.Model
model =
  { searchfield = ""
  , files = []
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Searchfield_msg msg ->
      ( {model | searchfield = msg}, Cmd.none )
    Ipfs_get ->
      (model, ipfs_get model.searchfield)
    Ipfs_pin msg ->
      (model, ipfs_pin msg)
    Ipfs_pin_ls msg ->
      (model, ipfs_pin_ls True)
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
