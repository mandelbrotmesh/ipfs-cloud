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
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg"
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
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg"
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
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg"
            , style [("width", "100%")]
            ]
            []
        ]

    ]




add_button : Html.Html Types.Msg
add_button =
  button
    [ --attribute "type" "file"
    --, attribute "id" "upbtn"
    -- , attribute "onchange" "onUpbtn();"
     style
        [ ("position", "fixed")
        , ("border-radius", "50%")
        , ("bottom", "calc(6vh + 20px)")
        , ("right", "6wh")
        , ("left", "calc(100vw - 14vh - 20px)")
        , ("min-height", "20px")
        , ("min-width", "20px")
        , ("width", "8vh")
        , ("height", "8vh")
        , ("backgroundColor", "red")
        , ("border", "none")
        ]
    , onClick (Ipfs_add "bla")
    ]
    [ img
        [ --src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
          src "http://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/content/svg/production/ic_add_48px.svg"
        , style
            [ ("width", "100%") ]
        ]
        []

    ]


-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
-- "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"

get_mediatype : String -> String
get_mediatype mime =
  case List.head (String.split "/" mime ) of
    Just val -> val
    Nothing -> "a"

filesymbol : Types.File -> String
filesymbol file =
  if file.mime == "Unknown filetype" then
    "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
  else if (get_mediatype file.mime) == "image" then
    maddrtourl file.maddr
  else if (get_mediatype file.mime) == "audio" then
    "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
  else if (get_mediatype file.mime) == "video" then
    "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
  else
    "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
    --maddrtourl file.maddr

mainview : Types.Model -> Html.Html Types.Msg
mainview model =
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
    ( List.concatMap file_view model.files )

file_view : Types.File -> List (Html.Html Types.Msg)
file_view file =
  [ div
      [ style
          [ ("margin", "5px")
          , ("width", "100px")
          -- , ("max-width", "140px")
          , ("height", "150px")
          , ("backgroundColor", "rgba(255, 255, 255, 1")
          , ("box-shadow", "5px 5px 5px #888888")
          , ("padding", "5px")
          ]
      ]
      [ div
          [ style [("height", "100px")]]
          [ img
              [ src (filesymbol file) --(.mime hs) --(filesymbol hs)
              , style
                  [ ("width", "100px")
                  , ("fill", "gray")]
              ]
              []
          ]
      , p
          [ style
              [ ("overflow", "hidden")
              , ("text-overflow", "ellipsis")
              , ("max-height", "50px")
              , ("margin", "0")
              , ("word-break", "break-all" )

              -- , ("position", "absolute")
              -- , ("top", "100px")
              ]
          ]
          [text (.maddr file) ]
      ]
    ]


maddrtourl : Maddr -> String
maddrtourl maddr =
  "https://ipfs.io/ipfs/" ++ maddr

confa : List String -> List (Html.Html msg)
confa hasher =
  List.concatMap (\hs -> [div [] [text hs]] ) hasher


view: Types.Model -> Html Types.Msg
view model =
  div
    []
    [ appshell
    , mainview model
    , add_button
    ]
