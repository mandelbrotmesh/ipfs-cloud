module State exposing (..)

import Types exposing (..)
import MimeType exposing (..)


model : Types.Model
model =
  { drawer_isopen = False
  , account_options_open = False
  , searchfield = ""
  , files = []
      -- [ { url = "dasd", mime = (parseMimeType "image/jpeg")}
      -- , { url = "dasd", mime = (parseMimeType "audio/mp3")}
      -- , { url = "Qntekfjsdaklfalöfksjföaldfdaldjlösfj", mime = (parseMimeType "video/mp4")}
      -- , { url = "Qntekfjsdaklfalöfksjföaldfdaldjlösfj", mime = (parseMimeType "")}
      -- ]
  }

answertofile : Types.Answer -> Types.File
answertofile answer =
  { url = answer.url
  , mime =
    ( parseMimeType answer.mime) }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acc_submit_msg msg ->
      ( model, acc_submit msg )
    Searchfield_msg msg ->
      ( {model | searchfield = msg}, Cmd.none )
    Ipfs_get ->
      ( model, ipfs_get model.searchfield )
    Ipfs_get_by_hs msg ->
      ( model, ipfs_get msg )
    Ipfs_answer msg ->
      ( {model | files =
        ( (answertofile msg) ::model.files) }, Cmd.none )
    Use_drawer msg ->
      ( {model | drawer_isopen = msg}, Cmd.none)
    Open_account_options msg ->
      ( {model | account_options_open = msg}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  ipfs_answer Ipfs_answer
