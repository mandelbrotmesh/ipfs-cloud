import View exposing(..)

import Types exposing (..)
import Html exposing (..)
import State exposing (..)
-- import Ports exposing(ipfs_cmd)
import Navigation
import Utils exposing (action)

bla = Utils.action "#imager" ""

main : Program Never Types.Model Types.Msg
main =
  -- Html.program
  Navigation.program
  -- (\url ->  Ext_url url)-- Url_change
  (\url ->
    case String.left 4 (.search url) of
      "ext=" -> Ipfs_msg <| Ipfs_dag_get <| String.dropLeft 4 <| .search url
      _ -> Ext_url url
    )
  { init = (\url -> (init url, Cmd.none)) --javascript handles init async; Ports.ipfs_cmd {action = "Pin_ls", maddr = ""} )
  , view = view
  , subscriptions = subscriptions
    -- \model -> Sub.none
  , update = State.update
  }

-- QmRHMb4KoWzWYnRHcgouzQWC1nWtzVRH4YK4b8JB2jZrXsQmRHMb4KoWzWYnRHcgouzQWC1nWtzVRH4YK4b8JB2jZrXs
-- <| Utils.action "#imager" ""
