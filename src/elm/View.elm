module View exposing (..)

import Types exposing (..)
import State exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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

menubuttonstyle =
  style
    [ ("vertical-align", "center")
    , ("height", "6vh")
    , ("width", "6vh")
    , ("min-height","60px")
    , ("min-width", "60px")
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
        , ("min-height", "70px")
        , ("box-shadow", "0px 5px 5px #888888")
        , ("position", "fixed")
        , ("top", "0vh")
        ]
    ]
    [ button
        [ menubuttonstyle
        , style
            [ ("left", "0")
            , ("margin", "1vh")]
        , onClick (Types.Use_drawer True)
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
            , ("min-height", "60px")
            , ("width", "calc(100vw - 20vh - 120px)")
            , ("margin", "1vh")
            , ("left", "calc(60px + 8vh)")
            , ("border-radius", "1vh")
            , ("border", "none")
            , ("backgroundColor", "gray")
            , ("font-size", "4vh")
            , ("padding-left", "2vh")
            , ("padding-right", "2vh")
            ]
        , onInput (Types.Acc_submit_msg)
        ]
        []
    , button
        [ menubuttonstyle
        , style
            [ ("right", "calc(10vh + 60px)")
            , ("margin", "1vh")
            , ("border-radius", "1vh")
            ]
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
            [ ("right", "0")
            , ("margin", "1vh")
            ]
        , onClick (Types.Open_account_options True)
        ]
        [ img
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg"
            , style [("width", "100%")]
            ]
            []
        ]

    ]

mainview : Html.Html Types.Msg
mainview =
  div
    [ style
        [ ("display", "flex")
        , ("flex-wrap", "wrap")
        , ("margin", "2vh")
        , ("margin-top", "calc(8vh + 60px)")
        -- , ("flex-basis", "400px")
        ]
    ]
    (List.concatMap
      (\hs ->
        [ div
            [ style
                [ ("margin", "1vh")
                , ("width", "140px")
                , ("max-width", "200px")
                , ("height", "200px")

                ]
            ]
            [ img
                [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
                , style
                    [("width", "100%")
                    , ("fill", "gray")]
                ]
                []
            , p
                [ style
                    [ ("overflow", "hidden")
                    , ("text-overflow", "ellipsis")
                    ]
                ]
                [text hs]
            ]
        ]
      ) model.files)


confa : List String -> List (Html.Html msg)
confa hasher =
  List.concatMap (\hs -> [div [] [text hs]] ) hasher


view: Types.Model -> Html Types.Msg
view model =
  div
    []
    [ appshell
    , mainview
    ]
