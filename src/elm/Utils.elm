module Utils exposing (..)

import String exposing (split)
import Types exposing (..)
import Json.Decode exposing (..)
import Dict exposing (Dict, get)
import List exposing (map3)
import Navigation exposing (..)
import Erl exposing (..)

maddrtourl : Maddr -> String
maddrtourl maddr =
  "https://ipfs.io/ipfs/" ++ maddr

-- get_mediatype : String -> String
-- get_mediatype mime =
--   case List.head (String.split "/" mime ) of
--     Just val -> val
--     Nothing -> "a"

get_mediatype : String -> Mediatype
get_mediatype name =
  if (String.right 4 name) == ".jpg" then
    Image
  else if (String.right 4 name) == ".ogg" then
    Audio
  else if (String.right 4 name) == ".mp4" then
    Video
  else if (String.right 4 name) == ".txt" then
    Text
  else
    Text

dec_dev_infos : String -> String
dec_dev_infos msg =
  case (decodeString (field "id" string) msg) of
    Ok val -> val
    Err val -> "err"

-- filesymbol : Types.File -> String
-- filesymbol file =
--   if file.mime == "Unknown filetype" then
--     maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
--   else if file.mime == "inode/directory" then
--     maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
--   else if (get_mediatype file.mime) == "image" then
--     maddrtourl file.maddr
--   else if (get_mediatype file.mime) == "audio" then
--     maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
--   else if (get_mediatype file.mime) == "video" then
--     maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
--   else
--     maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
--     --maddrtourl file.maddr

filesymbol : Types.File -> Maddr
filesymbol file =
  case (.mediatype file) of
    Folder ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
    Link ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
    Image ->
      maddrtourl (.multihash file)
    Audio ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
    Video ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
    Text ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_description_48px.svg"
    _ ->
      maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"

    -- maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_delete_48px.svg"
    -- maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_query_builder_48px.svg"


  -- if String.right 4 (.mediatype file) == "audio" then
  --   maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
  -- else
  --   maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"

--
-- type Mediatype
--   = Folder
--   | Link
--   | Image
--   | Audio
--   | Video
--   | Text


dag_node_to_file : Types.Dag_node -> Types.File
dag_node_to_file dag_node =
  { multihash = .multihash dag_node
  , name = "idk.ogg"
  , mediatype = Folder
  , pinnedby = [""]
  }

dag_link_to_file : Types.Dag_link -> Types.File
dag_link_to_file dag_link =
  { multihash = .multihash dag_link
  , name = .name dag_link
  , mediatype = get_mediatype (.name dag_link)
  , pinnedby = [""]
  }

-- get_page : Location -> Page
-- get_page loc =
--   case (.hash loc) of
--     "#acc_settings" -> Acc_settings
--     "#node_settings" -> Node_settings
--     "#history" -> History
--     "#browser" -> Browser [] --<| .hash loc
--     "#imager" -> Imager <| .pathname loc
--     "#video_p" -> Video_p <| .pathname loc
--     "#audio_p" -> Audio_p <| .pathname loc
--     "#text_p" -> Text_p <| .pathname loc
--     _ -> Browser []

action : String -> String -> Location
action intent hash =
  { href = ""
  , host = ""
  , hostname = ""
  , protocol = ""
  , origin = ""
  , port_ = ""
  , pathname = intent
  , search = ""
  , hash = hash
  , username = ""
  , password = ""
  }

decide : Types.Ipfs_answer -> Types.Msg
decide ipfs_answer =
  if (.answertype ipfs_answer) == "image answer" then
    Action_switch (Showing_img (.value ipfs_answer) (.hash ipfs_answer))
    -- Url_change (action "imager/" <| .value ipfs_answer)
  else if (.answertype ipfs_answer) == "audio answer" then
    Action_switch (Playing_audio (.value ipfs_answer) (.hash ipfs_answer))
    -- Url_change (action "audio_p/" <| .value ipfs_answer)
  else if (.answertype ipfs_answer) == "video answer" then
    Action_switch (Playing_video (.value ipfs_answer) (.hash ipfs_answer))
    -- Url_change (action "video_p/" <| .value ipfs_answer)
  else if (.answertype ipfs_answer) == "text answer" then
    Action_switch (Viewing_text (.value ipfs_answer) (.hash ipfs_answer))
    -- Url_change (action "text_p/" <| .value ipfs_answer)
  else if (.answertype ipfs_answer) == "dag answer" then
    -- Url_change (action "#browser/" <| .value ipfs_answer)
    Action_switch <|
      Browsing
      (List.map dag_link_to_file (.links (dag_json_to_dag_node (.value ipfs_answer))))
      (.hash ipfs_answer)
  else if (.answertype ipfs_answer) == "Upload_progress" then
    Upload_info [] --(.value ipfs_answer)
  else if (.answertype ipfs_answer) == "device_infos" then
    Device_infos (.value ipfs_answer)
  else
    Action_switch <|
      Browsing
      (List.map dag_link_to_file (.links (dag_json_to_dag_node (.value ipfs_answer))))
      (.hash ipfs_answer)
    -- Action_switch (Browsing [dag_node_to_file (dag_json_to_dag_node (.value ipfs_answer))] )

open : Types.File -> Types.Msg
open file =
  case (.mediatype file) of
    Folder ->
      Ipfs_dag_get (.multihash file)
    Link ->
      Ipfs_dag_get (.multihash file)
    Image ->
      Ipfs_cat {maddr = .multihash file, wanttype = "image answer"}
    Audio ->
      Ipfs_cat {maddr = .multihash file, wanttype = "audio answer"}
    Video ->
      Ipfs_cat {maddr = .multihash file, wanttype = "video answer"}
    Text ->
      Ipfs_cat {maddr = .multihash file, wanttype = "text answer"}
    _ ->
      Ipfs_dag_get (.multihash file)

  -- if String.right 4 (.name file) == ".ogg" then
  --   Ipfs_cat {maddr = .multihash file, wanttype = "audio answer"}
  -- else if String.right 4 (.name file) == ".jpg" then
  --   Ipfs_cat {maddr = .multihash file, wanttype = "image answer"}
  -- else
  --   Ipfs_dag_get (.multihash file)

-- play : Types.File -> Types.Action
-- play file =
--   -- if file.mime == "Unknown filetype" then
--   --   Browsing [file]
--   -- else if file.mime == "inode/directory" then
--   --   Browsing [file]
--   if (get_mediatype file.mime) == "image" then
--     Showing_img file.maddr
--   else if (get_mediatype file.mime) == "audio" then
--     Playing_audio file.maddr
--   else --(get_mediatype file.mime) == "video" then
--     Playing_video file.maddr
--   -- else
--   --   Browsing [file]


parse_ipld_json : Types.Ipld_node -> List (Dict String Value) --[Dict.fromList [(bla)]]
parse_ipld_json ipld_node =
  case (decodeString (field "links" (list (dict value ))) ipld_node) of
    Ok val -> val
    Err val -> []

--QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv

dag_json_to_dag_node : Types.Ipld_node -> Types.Dag_node --[Dict.fromList [(bla)]]
dag_json_to_dag_node ipld_node =
  { data = []
  , multihash =
      case (decodeString (field "multihash" (string)) ipld_node) of
        Ok val -> val
        Err val -> "mhash_err"
  , links = (dag_json_to_dag_links ipld_node)
  , size =
      case (decodeString (field "size" (int)) ipld_node) of
        Ok val -> val
        Err val -> 0
  }


dag_json_to_dag_links : Types.Ipld_node -> List Types.Dag_link --[Dict.fromList [(bla)]]
dag_json_to_dag_links ipld_node =
  List.map3
    (\a b c -> {name = a, multihash = b, size = c})
    (case (decodeString (field "links" (list (field "name" (string) ))) ipld_node) of
      Ok val -> val
      Err val -> ["name_err"]
    )
    (case (decodeString (field "links" (list (field "multihash" (string)) )) ipld_node) of
      Ok val -> val
      Err val -> ["mhash_err_link"])

    (case (decodeString (field "links" (list (field "size" int ))) ipld_node) of
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
