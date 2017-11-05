module Layout exposing (..)

import Style exposing (..)
import Types exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Element.Events exposing (..)
import Dict exposing (Dict, get)
import Json.Decode exposing (..)
import Html
import Html.Attributes as Hattr
-- import Html.Events exposing (..)

import Utils exposing(..)

appshell : Types.Model -> Element Styles variation Msg
appshell model =
  column None
    [ width fill, height fill ]
    [ menu model
    , mainview model
    ]

menu : Types.Model -> Element Styles variation Msg
menu model =
  screen
    ( el Menustyle
        [ width fill, height (px 60) ]
        ( row None
            [ height (px 60), width fill, padding 10, spacing 10, spread ]
            [ button Menubuttonstyle
                [ width (px 40), height (px 40)]
                ( image None
                    [ width (px 40), height (px 40) ]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg")
                    , caption = "open_drawer"
                    }
                )
            , row None
                [ width fill ]
                [ Input.text Searchbarstyle
                    [ width fill, padding 10 ]
                    { onChange = Searchfield_msg
                    , value = ""
                    , label =  Input.placeholder
                                { label = Input.labelLeft ( empty )
                                , text = "search"
                                }
                    , options = []
                    }
                , button Searchbarbuttonstyle
                    [ width (px 40), height (px 40), onClick (Types.Ipfs_dag_get model.searchfield) ]
                    ( image None
                        [ width (px 40), height (px 40) ]
                        { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg")
                        , caption = "start_search"
                        }
                    )
                ]
            , button Menubuttonstyle
                [ width (px 40), height (px 40) ]
                ( image None
                    [ width (px 40), height (px 40), onClick (Ipfs_add "bla") ]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg")
                    , caption = "upload_file"
                    }
                )

            ]

        )
    )


mainview : Types.Model -> Element Styles variation Msg
mainview model =
  column None
    [ width fill, height fill ]
    [ el None [ width fill, height (px 60) ] ( empty )
    , case model.action of
        Browsing dag_node ->
          browser dag_node
        Showing_img maddr->
          show_img maddr
        Playing_audio maddr ->
          audio_player maddr
        Playing_video maddr ->
          video_player maddr
    ]


browser : Types.Dag_node -> Element Styles variation Msg
browser dag_node =
  el Browserstyle
    [ width fill, height fill]
    ( row None
        [ width fill, height fill, padding 20, spacing 10]
        ( List.concatMap file_view (.links dag_node) )
    )
  -- grid MyGridStyle [ --attributes
  --                 ]
  --   { columns = [ px 180, px 180, px 180, px 180 ]
  --   , rows =
  --       [ px 120
  --       , px 120
  --       , px 120
  --       , px 120
  --       ]
  --   , cells =
  --       [ ( List.concatMap file_view files ) ]
  --
  --       -- [ cell
  --       --     { start = ( 0, 0 )
  --       --     , width = 1
  --       --     , height = 1
  --       --     , content = el Box [] (text "box")
  --       --     }
  --       -- , cell
  --       --     { start = ( 1, 1 )
  --       --     , width = 1
  --       --     , height = 2
  --       --     , content = el Box [] (text "box")
  --       --     }
  --       --
  --       -- ]
  --
  --   }

  -- el Browserstyle
  --   [ style
  --       [ ("display", "flex")
  --       , ("flex-wrap", "wrap")
  --       , ("padding", "2vh")
  --       , ("padding-top", "calc(8vh + 60px)")
  --       , ("min-height", "calc(90vh - 60px)")
  --       , ("backgroundColor", "rgba(229, 229, 229, 1)")
  --       ]
  --   ]


show_img : Types.Maddr -> Element Styles variaion Msg
show_img maddr =
  el None
    [ width fill]
    ( image None
        [ width (px 120), height (px 120) ]
        { src = (maddrtourl maddr)
        , caption = "image"
        }
    )

audio_player : Types.Maddr -> Element Styles variation Msg
audio_player maddr =
  el None
    [ width fill ]
    ( html ( Html.audio
        [ Hattr.src (maddrtourl maddr)
        , Hattr.controls True
        , Hattr.style
          [ ("width", "100vw")
          , ("overflow-x", "hidden")
          ]
        ]
        [])
    )

video_player : Types.Maddr -> Element Styles variation Msg
video_player maddr =
  el None
    [ width fill ]
    ( html ( Html.video
        [ Hattr.src (maddrtourl maddr)
        , Hattr.controls True
        , Hattr.style
            [ ("width", "100vw")
            , ("height", "calc(100vmin - 60px)")
            , ("backgroundColor", "rgba(3, 3, 3, 1)")
            , ("overflow-x", "hidden")
            ]
        ]
        [])
    )


file_view : Types.Dag_link -> List (Element Styles variaion Msg)
file_view dag_link =
  [ el Filestyle
      [ width (px 120), height (px 180), padding 5 ]
      ( column None
          [ width fill, height fill]
          [ row None
              [ width fill, alignRight]
              [ image None
                  [ width (px 20), height (px 20), onClick (Ipfs_pin (.multihash dag_link) ) ]--file.maddr) ]
                  { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
                      -- if file.ispinned == False then
                      --   (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
                      -- else
                      --   (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")

                  , caption = "pin_content"
                  }
              ,  image None
                  [ width (px 20), height (px 20) ]
                  { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg")
                  , caption = "more_options"
                  }

              ]
          , image None
              [ width fill, height (px 100)] --, onClick (Action_switch ( play file )) ]
              { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg") --(Utils.filesymbol file)
              , caption = "play_file"
              }
          , html
              ( Html.p
                  [ Hattr.style
                      [ ("overflow-x", "hidden")
                      , ("overflow-y", "ellipsis")
                      , ("text-overflow", "ellipsis")
                      , ("max-height", "50px")
                      , ("width", "110px")
                      , ("margin", "0")
                      , ("word-break", "break-all" )
                      ]
                  ]
                  [ Html.text (.name dag_link) ] --(.maddr file) ]
              )
          -- , paragraph None
          --     [ width fill, height (px 50)]
          --     [ text (.maddr file) ]
          ]
      )
  ]
