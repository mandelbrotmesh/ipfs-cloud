port module Main exposing (..)

import Html exposing (Html, text)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (..)

import Color exposing (..)
import Style exposing (..)
import Style.Color as Color
import Layout exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Element.Input exposing (search, text, disabled)

import String
import QRCode
import Svg
--import Svg.Attributes exposing (..)

--model

port acc_submit : String -> Cmd msg

type alias Model =
  { acc_psw : String
  , drawer_isopen : Bool
  }

model : Model
model =
  {
    acc_psw = "blub"
  , drawer_isopen = False
  }


--update : Msg -> Model -> (Model, Cmd Msg)

--type alias Acc_submit_msg = String

type Msg
  = Acc_submit_msg String
  | Use_drawer Bool

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acc_submit_msg msg ->
      ( model, acc_submit model.acc_psw )
    Use_drawer msg ->
      ({model | drawer_isopen = True}, Cmd.none)


--view


-- qrCodeView : String -> Html msg
-- qrCodeView message =
--     QRCode.encode message
--         |> Result.map QRCode.toSvg
--         |> Result.withDefault
--             (Html.text "Error while encoding to QRCode.")

-- type Styles
--   = None
--   | Menu
--


--
-- --
--
-- Menu =
--   row None
--     [ ]
--     [ el Drawer [] (Element.text "he")]
--
--     row None
--       []
--       [ el Menu
--           [ Element.Attributes.width (fill)
--           , Element.Attributes.height (fill)
--           ]
--           ( Element.text "hello")
--       ]
--


-- menu : Element Appshell_identifiers variation Msg
-- menu =
--   row None []
--     [
--
--
--     ]

      -- ]     --None [] appshellstyle
    --, Element.text "menu2"]

type Styles
  = None
  | Menustyle
  | Drawerstyle
  | Mainviewstyle


stylesheet =
  Style.styleSheet
    [ Style.style None []
    , Style.style Menustyle
        [ Color.background blue ]
    , Style.style Drawerstyle
        [ Color.background blue ]
    , Style.style Mainviewstyle
        [ Color.background yellow ]
    ]

menu : Element Styles variation Msg
menu =
  row None [ padding 20, width (fill), height (fill)]
    [ el Mainviewstyle [ alignRight ] empty
    , Element.image Mainviewstyle [ alignRight, height fill ]
      { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg"
      , caption = "open_drawer"
      }
    , Input.text None
        []
        { onChange = Acc_submit_msg
        , value = "shit"
        , label =
            Input.placeholder
                { label = Input.labelLeft (el None [ verticalCenter ] (Element.text "Yup"))
                , text = "Placeholder!"
                }
        , options = []
        }
        , Element.image Mainviewstyle [ alignRight, height fill ]
          { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg"
          , caption = "search"
          }
        , Element.image Mainviewstyle [ alignRight, height fill ]
          { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/content/svg/production/ic_add_48px.svg"
          , caption = "upload"
          }
        , Element.image Mainviewstyle [ alignRight, height fill ]
          { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg"
          , caption = "account_options"
          }

    ]

drawer : Element Styles variation msg
drawer =
  row None []
    [ Element.text "drawer"
    , Element.text "drawer"
    ]

mainview : Element Styles variation msg
mainview =
  row None []
    [ Element.text "main"
    , Element.text "main"
    ]

appshell menu drawer mainview =
  column None
    [ width (fill)
    , height (fill)
    ]
    [ el Menustyle
        [ width (fill)
        , height (fill) ]
        (menu)
    , el Mainviewstyle
        [ width (fill)
        , height (fillPortion 9) ]
        ( mainview )
    ]

view: Model -> Html Msg
view model =
  Element.viewport stylesheet <|
    appshell menu menu mainview


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
