port module Main exposing (..)

import Html exposing(..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


import QRCode
import Svg
import Svg.Attributes exposing (..)
import Time exposing (..)



--model

port acc_submit : String -> Cmd msg

type alias Model =
  { acc_psw : String
  }

model : Model
model =
  {
    acc_psw = "blub"
  }


--update : Msg -> Model -> (Model, Cmd Msg)

type alias Acc_submit_msg = String

type Msg
  = Acc_submit_msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acc_submit_msg ->
      ( model, acc_submit model.acc_psw )


--view

qrCodeView : String -> Html msg
qrCodeView message =
    QRCode.encode message
        |> Result.map QRCode.toSvg
        |> Result.withDefault
            (Html.text "Error while encoding to QRCode.")

view: Model -> Html Msg
view model =
  div [] [qrCodeView "hi"]


main : Program Never Model Msg
main =
  Html.program
  { init = ( model, Cmd.none )
  , view = view
  , subscriptions = \model ->
    Sub.none
  , update = update
  }


-----------------------------------------------------------------------------
      --QmbE4MMHw79uNCjMgLRsdTTgdmvfGKwxscxKQ4Y691w75g full
      -- QmXWkw8mjqmKgjsCetLyaemm2VUNdVQRCDoLPY4maYvvkk start border

      --QmUWPaBcQKznN4Kgw9KtNvvdqKG9FGCDCJx3X2TTFktbpW folder

      --icon main QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmTbadbXSBSr1Zm8e9sayUF1micckMndqn5wgX59VKqRdZ",
      -- menu_style] [] ],
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmPMmt2pj8wTRK4m2qkd1TqcVJF3rejtryhiX3E3DEVhG4",
      -- menu_style] [] ],
      --
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmeZKWi7ee8sgeF624XKwrt5DCKDU12nuqKu7nBdftsgP5",
      -- menu_style] [] ],
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmXouWeoxjr99SdWqnjJXtEzycMMFZVaAsk4psKStS1Chw",
      -- menu_style] [] ],
      --
      -- div [] [ input [placeholder "search", width 100 ] [], button [height 60, width 60] [text "go"] ],
      --
      -- div [] [
      -- audio [src "http://media.w3.org/2010/07/bunny/04-Death_Becomes_Fur.mp4",
      --   type_ "audio/mp4",
      --   controls True] []
      -- ]
      -- ]
