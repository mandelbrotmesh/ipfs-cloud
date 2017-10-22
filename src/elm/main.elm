port module Main exposing (..)

import Color exposing (..)

-- import Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import MimeType exposing (..)

import String
import QRCode
import Svg
import List exposing (map)
--model

port acc_submit : String -> Cmd msg


type alias Model =
  { drawer_isopen : Bool
  , account_options_open : Bool
  , files : List String
  }


model : Model
model =
  { drawer_isopen = False
  , account_options_open = False
  , files =
      ["Qn"]
  }


--update : Msg -> Model -> (Model, Cmd Msg)

--type alias Acc_submit_msg = String

type Msg
  = Acc_submit_msg String
  | Use_drawer Bool
  | Open_account_options Bool

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acc_submit_msg msg ->
      ( model, acc_submit msg )
    Use_drawer msg ->
      ({model | drawer_isopen = msg}, Cmd.none)
    Open_account_options msg ->
      ({model | account_options_open = msg}, Cmd.none)

--view


-- qrCodeView : String -> Html msg
-- qrCodeView message =
--     QRCode.encode message
--         |> Result.map QRCode.toSvg
--         |> Result.withDefault
--             (Html.text "Error while encoding to QRCode.")

menubuttonstyle =
  style
    [ ("vertical-align", "center")
    , ("height", "6vh")
    , ("width", "6vh")
    , ("backgroundColor", "rgba(0, 0, 0, 0)")
    , ("border", "none")
    , ("position", "absolute")
    , ("top", "1vh")
    , ("cursor", "pointer")]

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

account_menu : Html.Html Msg
account_menu =
  div
    []
    []

appshell : Html.Html Msg
appshell  =
  div
    [ style
        [ ("backgroundColor", "red")
        , ("width", "100vw")
        , ("height", "8vh")
        ]
    ]
    [ button
        [ menubuttonstyle
        , style [ ("left", "1vh") ]
        , onClick (Use_drawer True)
        ]
        [ img
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg"
            , style [("width", "100%")]
            ]
            []
        ]
    , input
        [ style
            [ ("position", "absolute")
            , ("height", "6vh")
            , ("width", "calc(100vw - 18vh)")
            , ("top", "1vh")
            , ("left", "8vh")
            , ("border-radius", "1vh")
            , ("border", "none")
            , ("backgroundColor", "gray")
            , ("font-size", "4vh")
            , ("padding-left", "2vh")
            ]
        , onInput (Acc_submit_msg)
        ]
        []
    , button
        [ menubuttonstyle
        , style
            [ ("right", "10vh")
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
        , style [ ("right", "1vh")]
        , onClick (Open_account_options True)
        ]
        [ img
            [ src "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg", style [("width", "100%")]]
            []
        ]

    ]


confa : List String -> List (Html.Html msg)
confa hasher =
  List.concatMap (\hs -> [div [] [text hs]] ) hasher


view: Model -> Html Msg
view model =
  appshell

  -- div
  --   []
  --   (confa model.files)


main : Program Never Model Msg
main =
  Html.program
  { init = ( model, Cmd.none )
  , view = view
  , subscriptions = \model ->
    Sub.none
  , update = update
  }


-----------------------------------------------------------------------------


-- acc_menu : Html Msg
-- acc_menu =
--   div
--     []
--     [text "new_acc"]
--
--
--
-- menu_style : Attribute Msg
-- menu_style =
--   style
--     [ ("backgroundColor", "purple")
--     , ("width", "100vw")
--     , ("height", "10vh")
--     ]
--
-- account_button_style : Attribute Msg
-- account_button_style =
--   style
--     [ ("width", "10vh")
--     , ("height", "10vh")
--     , ("position", "absolute")
--     , ("right", "0")
--     , ("font-size", "10vh")
--     , ("hover", "background-color: blue")
--     ]
--
-- add_button_style : Attribute Msg
-- add_button_style =
--   style
--     [ ("width", "10vh")
--     , ("height", "10vh")
--     , ("position", "absolute")
--     , ("right", "10vh")
--     , ("font-size", "10vh")
--     , ("hover", "background-color: blue")
--     ]
--
-- menu : Html Msg
-- menu =
--   div [ menu_style ]
--   [ input
--       [ style [ ("width", "calc(100vw - 21vh)")
--               , ("position", "absolute")
--               , ("left", "1vh")
--               , ("right", "20vh")
--               , ("top", "1vh")
--               , ("bottom", "91vh")
--               ]
--       ]
--       []
--   , i
--       [ class "material-icons"
--       , add_button_style
--       ]
--       [ text "add" ]
--   , i
--       [ class "material-icons"
--       , account_button_style
--       , onClick (Use_acc_menu True)
--       ]
--       [ text "account_box" ]
--
--   ]
--
-- layout_style : Attribute Msg
-- layout_style =
--   style
--     [ ("backgroundColor", "grey")
--     , ("width", "100vw")
--     , ("height", "100vh")
--     ]
--
--
--
-- layout : (Html Msg, Html Msg, Html Msg) -> Html Msg
-- layout (menus, drawer, main) =
--   div [ layout_style ] [ menus, text "hello" ]
--
--
--
--
--
--   -- Svg.svg
--   --     [ width "100vw", height "10vh"]
--   --     [ Svg.rect [ x "0", y "0", width "100vw", height "20vh", fill "#0B79CE" ] []
--   --     , Svg.rect [ x "2.5vw", y "2.5vh", width "5vh", height "5vh", onClick (Use_drawer True)] []
--   --     , Svg.rect [ x "92.5vw", y "2.5vh", width "5vh", height "5vh", onClick (Use_acc_menu True)] []
--
--
--       --Svg.image [ x "5", y "5", width "5vw", height "5vh", xlinkHref ""] []
--       --, Svg.image [ width "100px", height "100px", Mic.menu] []
--     --  ]


-----------------------------------------------------------------------------
      --QmbE4MMHw79uNCjMgLRsdTTgdmvfGKwxscxKQ4Y691w75g full
      -- QmXWkw8mjqmKgjsCetLyaemm2VUNdVQRCDoLPY4maYvvkk start border

      --QmUWPaBcQKznN4Kgw9KtNvvdqKG9FGCDCJx3X2TTFktbpW folder

      --icon main QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmTbadbXSBSr1Zm8e9sayUF1micckMndqn5wgX59VKqRdZ",
      -- menu_style] [] ],
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmPMmt2pj8wTRK4m2qkd1TqcVJF3rejtryhiX3E3DEVhG4",
      -- menu_style] [] ],
      --
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmeZKWi7ee8sgeF624XKwrt5DCKDU12nuqKu7nBdftsgP5",
      -- menu_style] [] ],
      --
      -- button [] [ img [src "https://ipfs.io/ipfs/QmXouWeoxjr99SdWqnjJXtEzycMMFZVaAsk4psKStS1Chw",
      -- menu_style] [] ],
      --
      -- div [] [ input [placeholder "search", width 100 ] [], button [height 60, width 60] [text "go"] ],
      --
      -- div [] [
      -- audio [src "http://media.w3.org/2010/07/bunny/04-Death_Becomes_Fur.mp4",
      --   type_ "audio/mp4",
      --   controls True] []
      -- ]
      -- ]
