module State exposing (..)

import Types exposing (..)

model : Types.Model
model =
  { drawer_isopen = False
  , account_options_open = False
  , files =
      [ "Qnlkfjsdaklfalöfksjföaldfdaldjlösfj"
      , "q3sfddddddddddddddddddddddddddddddddddn"
      , "sldkfjlkjsdlf"
      , "fsdklfljslk"
      , "q3sfddddddddddddddddddddddddddddddddddn"
      , "sldkfjlkjsdlf"
      , "fsdklfljslk"
      , "q3sfddddddddddddddddddddddddddddddddddn"
      , "sldkfjlkjsdlf"
      , "fsdklfljslk"
      , "q3sfddddddddddddddddddddddddddddddddddn"
      , "sldkfjlkjsdlf"
      , "fsdklfljslk"
      ]
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acc_submit_msg msg ->
      ( model, acc_submit msg )
    Ipfs_get msg ->
      ( model, ipfs_get msg )
    Ipfs_answer msg ->
      ( {model | files = msg }, Cmd.none )
    Use_drawer msg ->
      ( {model | drawer_isopen = msg}, Cmd.none)
    Open_account_options msg ->
      ( {model | account_options_open = msg}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  ipfs_answer Ipfs_answer
