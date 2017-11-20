import View exposing(..)

import Types exposing (..)
import Html exposing (..)
import State exposing (..)
-- import Ports exposing(ipfs_cmd)
main : Program Never Types.Model Types.Msg
main =
  Html.program
  { init = ( model, Cmd.none ) --javascript handles init async; Ports.ipfs_cmd {action = "Pin_ls", maddr = ""} )
  , view = view
  , subscriptions = subscriptions
    -- \model -> Sub.none
  , update = State.update
  }

-- QmRHMb4KoWzWYnRHcgouzQWC1nWtzVRH4YK4b8JB2jZrXsQmRHMb4KoWzWYnRHcgouzQWC1nWtzVRH4YK4b8JB2jZrXs
