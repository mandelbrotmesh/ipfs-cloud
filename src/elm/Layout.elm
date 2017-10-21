module Layout exposing (..)

import Html exposing (Html)
import Color exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


appshell : Html.Html msg
appshell =
  svg
    [ width "100vw"
    , height "200"]
    [ g
        [ width "480"
        , height "80"]
        [ rect
            [ x "0"
            , y "0"
            , fill "rgba(255,25,25,1)"
            , width "480"
            , height "80"
            ]
            []
        , image --menubutton
            [ xlinkHref "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg"
            , width "80"
            ]
            []

        , g
            []
            [ rect
                [ fill "rgba(182,182,182,1)"
                , x "100"
                , y "10"
                , width "280"
                , height "60"
                , rx "12"
                , ry "12"
                ] []

            ]
        , image --menubutton
            [ xlinkHref "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg"
            , x "320"
            , y "10"
            , width "60"

            ]
            []

        , image --menubutton
            [ xlinkHref "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg"
            , x "400"
            , width "80"
            ]
            []
        ]
    ]
