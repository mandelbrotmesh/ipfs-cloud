module Utils exposing (..)

import String exposing (split)
import Types exposing (..)
import Json.Decode exposing (..)
import Dict exposing (Dict, get)
import List exposing (map3)

maddrtourl : Maddr -> String
maddrtourl maddr =
  "https://ipfs.io/ipfs/" ++ maddr

get_mediatype : String -> String
get_mediatype mime =
  case List.head (String.split "/" mime ) of
    Just val -> val
    Nothing -> "a"

filesymbol : Types.File -> String
filesymbol file =
  if file.mime == "Unknown filetype" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
  else if file.mime == "inode/directory" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
  else if (get_mediatype file.mime) == "image" then
    maddrtourl file.maddr
  else if (get_mediatype file.mime) == "audio" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
  else if (get_mediatype file.mime) == "video" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
  else
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
    --maddrtourl file.maddr

-- play : Types.File -> Types.Action
-- play file =
--   if file.mime == "Unknown filetype" then
--     Browsing [file]
--   else if file.mime == "inode/directory" then
--     Browsing [file]
--   else if (get_mediatype file.mime) == "image" then
--     Showing_img file.maddr
--   else if (get_mediatype file.mime) == "audio" then
--     Playing_audio file.maddr
--   else if (get_mediatype file.mime) == "video" then
--     Playing_video file.maddr
--   else
--     Browsing [file]


parse_ipld_json : Types.Ipld_node -> List (Dict String Value) --[Dict.fromList [(bla)]]
parse_ipld_json ipld_node =
  case (decodeString (field "links" (list (dict value ))) ipld_node) of
    Ok val -> val
    Err val -> []

parse_ipld_rec : Types.Ipld_node -> List Types.Cid_rec --[Dict.fromList [(bla)]]
parse_ipld_rec ipld_node =
  List.map3
    (\a b c -> {cid = a, name = b, size = c})
    (case (decodeString (field "links" (list (field "Cid" (field "/" (string)) ))) ipld_node) of
      Ok val -> val
      Err val -> [""])

    (case (decodeString (field "links" (list (field "Name" (string) ))) ipld_node) of
      Ok val -> val
      Err val -> [""]
    )
    (case (decodeString (field "links" (list (field "Size" int ))) ipld_node) of
      Ok val -> val
      Err val -> [0]
    )


-- parse_d : List (Dict String Value) -> { cid : String}--, name : String, size : a}
-- parse_d nlist =
--   map ( \dag_node ->
--     { cid =
--         case (get "Name" dag_node) of
--           Just val -> val
--           Nothing -> ""
--         -- case (get "Cid" dag_node) of
--         --   Just val ->
--         --     ( case (decodeString (field "/" (string)) val) of
--         --         Ok vals -> vals
--         --         Err vals -> "" )
--         --   Nothing -> ""
--
--
--         -- case dag_node of
--         --   Value
--         -- case (decodeString (field "Cid" (string)) dag_node) of
--         --   Ok val -> val
--         --   Err val -> "bla"
--
--
--     }
--     ) nlist
    -- , name =
    --     case (get "Name" dag_node) of
    --       Just val -> val
    --       Nothing -> ""
    -- , size =
    --     case (get "Size" dag_node) of
    --       Just val -> val
    --       Nothing -> 0
    --
    --
    --
    -- }
    --
    -- ) nlist

-- get_cid dnode =
--   case (get "Cid" dnode) of
--     Just val -> val
--     Nothing -> ""
--
-- get_name dnode =
--   case (get "Name" dnode) of
--     Just val -> val
--     Nothing -> "bla"


-- getlinks : Types.Ipld_node -> List Types.Maddr
-- getlinks ipld_node =
--   case ( decodeString
--     ( field "links"
--         ( list
--             ( field "Cid"
--                 ( field "/" (string) )
--             )
--         )
--     ) ipld_node ) of
--       Ok val -> val
--       Err val -> ["Err"]
--
-- name = decodeString (field "links" (list (field "Name" (string) )))
--
-- map decodeString
--   ( field "links"
--       ( list
--           ( field "Cid"
--               ( field "/" (string) )
--           )
--       )
--   ) ipld_node )
