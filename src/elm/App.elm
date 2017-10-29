import View exposing(..)

import Types exposing (..)
import Html exposing (..)
import State exposing (..)
import Ports exposing(ipfs_pin_ls)
main : Program Never Types.Model Types.Msg
main =
  Html.program
  { init = ( model, Ports.ipfs_pin_ls True )
  , view = view
  , subscriptions = subscriptions
    -- \model -> Sub.none
  , update = State.update
  }
