import View exposing(..)

import Types exposing (..)
import Html exposing (..)
import State exposing (..)

main : Program Never Types.Model Types.Msg
main =
  Html.program
  { init = ( model, Cmd.none )
  , view = view
  , subscriptions = \model ->
    Sub.none
  , update = State.update
  }
