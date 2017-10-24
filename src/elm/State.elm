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
    Use_drawer msg ->
      ({model | drawer_isopen = msg}, Cmd.none)
    Open_account_options msg ->
      ({model | account_options_open = msg}, Cmd.none)
