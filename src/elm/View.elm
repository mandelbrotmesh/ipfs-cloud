module View exposing (..)

import Types exposing (..)
import State exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing(split)
-- import Array exposing(get)
-- import MimeType exposing (..)

overlaystyle =
  style
    [ ("position", "fixed")
    , ("width", "100vw")
    , ("height", "100vh")
    , ("top", "0")
    , ("left", "100vw")
    , ("bottom", "0")
    , ("right", "0")
    , ("backgroundColor", "rgba(0, 0, 0, 0.5)")
    , ("z-index", "2")
    ]

menubuttonstyle : Attribute msg
menubuttonstyle =
  style
    [ ("vertical-align", "center")
    , ("height", "6vh")
    , ("width", "6vh")
    , ("min-height","40px")
    , ("min-width", "40px")
    , ("backgroundColor", "rgba(0, 0, 0, 0)")
    , ("border", "none")
    , ("position", "absolute")
    , ("cursor", "pointer")
    ]

account_menu : Html.Html Types.Msg
account_menu =
  div
    []
    []

appshell : Html.Html Types.Msg
appshell  =
  div
    [ style
        [ ("backgroundColor", "red")
        , ("width", "100vw")
        , ("height", "8vh")
        , ("min-height", "50px")
        , ("box-shadow", "0px 5px 5px #888888")
        , ("position", "fixed")
        , ("top", "0vh")
        ]
    ]
    [ button
        [ menubuttonstyle
        , style
            [ ("left", "10px")
            , ("margin", "1vh")]
        -- , onClick (Types.Use_drawer True)
        ]
        [ img
            [ src (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg")
            , style [("width", "100%")]
            ]
            []
        ]
    -- here the other menu elements
    , input
        [ style
            [ ("position", "absolute")
            , ("height", "6vh")
            , ("min-height", "40px")
            , ("width", "calc(100vw - 20vh - 80px)")
            , ("margin", "1vh")
            , ("left", "calc(40px + 8vh)")
            , ("border-radius", "1vh")
            , ("border", "none")
            , ("backgroundColor", "gray")
            , ("font-size", "4vh")
            , ("padding-left", "2vh")
            , ("padding-right", "calc(2vh + 60px)")
            , ("box-sizing", "border-box")
            ]
        , onInput Types.Searchfield_msg
        ]
        []
    , button
        [ menubuttonstyle
        , style
            [ ("right", "calc(10vh + 40px)")
            , ("margin", "1vh")
            , ("border-radius", "0px 1vh 1vh 0px")
            , ("backgroundColor", "rgba(80, 80, 80, 1)")
            ]
        , onClick (Types.Ipfs_cat model.searchfield)
        ]
        [ img
            [ src (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg")
            , style [("width", "100%")]
            ]
            [ ]
        ]
    , button
        [ menubuttonstyle
        , style
            [ ("right", "10px")
            , ("margin", "1vh")
            ]
        -- , onClick (Types.Open_account_options True)
        ]
        [ img
            [ src (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg") --(maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg")
            , style [("width", "100%")]
            , onClick (Ipfs_add "bla")
            ]
            []
        ]

    ]




-- add_button : Html.Html Types.Msg
-- add_button =
--   button
--     [ --attribute "type" "file"
--     --, attribute "id" "upbtn"
--     -- , attribute "onchange" "onUpbtn();"
--      style
--         [ ("position", "fixed")
--         , ("border-radius", "50%")
--         , ("bottom", "calc(6vh + 20px)")
--         , ("right", "6wh")
--         , ("left", "calc(100vw - 14vh - 20px)")
--         , ("min-height", "20px")
--         , ("min-width", "20px")
--         , ("width", "8vh")
--         , ("height", "8vh")
--         , ("backgroundColor", "red")
--         , ("border", "none")
--         ]
--     , onClick (Ipfs_add "bla")
--     ]
--     [ img
--         [ --src maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
--           src "http://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/content/svg/production/ic_add_48px.svg"
--         , style
--             [ ("width", "100%") ]
--         ]
--         []
--
--     ]


-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
-- QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg

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

play : Types.File -> Types.Action
play file =
  if file.mime == "Unknown filetype" then
    Browsing [file]
  else if file.mime == "inode/directory" then
    Browsing [file]
  else if (get_mediatype file.mime) == "image" then
    Showing_img file.maddr
  else if (get_mediatype file.mime) == "audio" then
    Playing_audio file.maddr
  else if (get_mediatype file.mime) == "video" then
    Playing_video file.maddr
  else
    Browsing [file]

file_view : Types.File -> List (Html.Html Types.Msg)
file_view file =
  [ div
      [ style
          [ ("margin", "5px")
          , ("width", "120px")
          -- , ("max-width", "140px")
          , ("height", "180px")
          , ("backgroundColor", "rgba(255, 255, 255, 1")
          , ("box-shadow", "3px 3px 3px #888888")
          , ("padding", "5px")
          ]
      ]
      [ div
          [ style
              [("display", "flex")
              , ("flex-direction", "row-reverse")
              ]
          ]
          [ --text file.mime
           img
              [ src (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg") --"https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_expand_more_48px.svg"
              , style
                  [ ("width", "20px")
                  , ("height", "20px")
                  , ("fill", "gray")
                  ]
              ]
              []
            , img
              [ src
                  ( if file.ispinned == False then
                      (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
                    else
                      (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
                  )
              , style
                  [ ("width", "20px")
                  , ("height", "20px")
                  , ("fill", "gray")
                  ]
              , onClick (Ipfs_pin file.maddr)
              ]
              []
          ]
      , img
          [ src (filesymbol file) --(.mime hs) --(filesymbol hs)
          , style
              [ ("width", "120px")
              , ("max-height", "100px")
              , ("fill", "gray")]
          , onClick (Action_switch ( play file )) --"QmTca4A43f4kEvzTouvYTegtp6KobixRqweV12NrvwwtFP"))--"QmaMc3URC5Jqt3HrfP2beBkB56Y232YUqR3itguzup91je"))
          ]
          []
          --(.mime hs) --(filesymbol hs)
      , p
          [ style
              [ ("overflow-x", "hidden")
              , ("overflow-y", "ellipsis")
              , ("text-overflow", "ellipsis")
              , ("max-height", "50px")
              , ("width", "120px")
              , ("margin", "0")
              , ("word-break", "break-all" )

              -- , ("position", "absolute")
              -- , ("top", "100px")
              ]
          ]
          [text (.maddr file) ]
      ]
    ]

-- confa : List String -> List (Html.Html msg)
-- confa hasher =
--   List.concatMap (\hs -> [div [] [text hs]] ) hasher

maddrtourl : Maddr -> String
maddrtourl maddr =
  "https://ipfs.io/ipfs/" ++ maddr

browser : Types.Files -> Html Types.Msg
browser files =
  div
    [ style
        [ ("display", "flex")
        , ("flex-wrap", "wrap")
        , ("padding", "2vh")
        , ("padding-top", "calc(8vh + 60px)")
        , ("min-height", "calc(90vh - 60px)")
        , ("backgroundColor", "rgba(229, 229, 229, 1)")
        ]
    ]
    ( List.concatMap file_view files )

show_img : Types.Maddr -> Html Types.Msg
show_img maddr =
  div
    []
    [ img
        [ src (maddrtourl maddr)
        , style [("width", "100vw")]
        ]
        []
    ]

audio_player : Types.Maddr -> Html Types.Msg
audio_player maddr =
  div
    []
    [ audio
        [ src (maddrtourl maddr)
        , controls True
        , style
            [ ("width", "100vw")
            ]
        ]
        []
    ]

video_player : Types.Maddr -> Html Types.Msg
video_player maddr =
  div
    [
    ]
    [ video
        [ src (maddrtourl maddr)
        , controls True
        , style
            [ ("width", "100vw")
            ]
        ]
        []
    ]


view: Types.Model -> Html Types.Msg
view model =
  div
    []
    [ appshell
    , case model.action of
        Browsing files ->
          browser files
        Showing_img maddr->
          show_img maddr
        Playing_audio maddr ->
          audio_player maddr
        Playing_video maddr ->
          video_player maddr

    -- , mainview model
    -- , player model
    -- , add_button
    ]
