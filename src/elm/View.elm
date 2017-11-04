module View exposing (..)

import Types exposing (..)
import State exposing (..)

import Html exposing (..)

-- import MimeType exposing (..)

import Stylesheet exposing (..)
import Layout exposing (..)

import Element exposing (..)

-- -- add_button : Html.Html Types.Msg
-- -- add_button =
-- --   button
-- --     [ --attribute "type" "file"
-- --     --, attribute "id" "upbtn"
-- --     -- , attribute "onchange" "onUpbtn();"
-- --      style
-- --         [ ("position", "fixed")
-- --         , ("border-radius", "50%")
-- --         , ("bottom", "calc(6vh + 20px)")
-- --         , ("right", "6wh")
-- --         , ("left", "calc(100vw - 14vh - 20px)")
-- --         , ("min-height", "20px")
-- --         , ("min-width", "20px")
-- --         , ("width", "8vh")
-- --         , ("height", "8vh")
-- --         , ("backgroundColor", "red")
-- --         , ("border", "none")
-- --         ]
-- --     , onClick (Ipfs_add "bla")
-- --     ]
-- --     [ img
-- --         [ --src maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
-- --           src "http://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/content/svg/production/ic_add_48px.svg"
-- --         , style
-- --             [ ("width", "100%") ]
-- --         ]
-- --         []
-- --
-- --     ]
--
-- -- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
-- -- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
-- -- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
-- -- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
-- -- QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg


view: Types.Model -> Html Types.Msg
view model =
  Element.viewport Stylesheet.stylesheet <|
    Layout.appshell model

    -- -- , mainview model
    -- -- , player model
    -- -- , add_button
    -- ]
