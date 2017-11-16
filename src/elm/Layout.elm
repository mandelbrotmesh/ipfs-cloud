module Layout exposing (..)

import Style exposing (..)
import Types exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Element.Events exposing (..)
import Dict exposing (Dict, get)
import Json.Decode exposing (..)
import Html exposing (program)
import Html.Attributes as Hattr
import QRCode
-- import Html.Events exposing (..)
import State

import Utils exposing(..)



appshell : Types.Model -> Element Styles variation Msg
appshell model =
  row None
    [ width fill, height fill]
    [ column None
        [ width fill, height fill ]
        [ menu model
        , el None [ width fill, height (px 60) ] ( empty )
        , row None
            [ width fill, height fill ]
            [ drawer model
            , mainview model
            ]
        ]

    ]

searchfield : Types.Model -> Element Styles variation Msg
searchfield model =
  row None
    [ width fill, minWidth (px 20)]
    [ Input.text Searchbarstyle
        [ width fill, padding 10, minWidth (px 20)]
        { onChange = Search_msg
        , value = ""
        , label =  Input.placeholder
                    { label = Input.hiddenLabel "" --Input.labelLeft ( empty )
                    , text = "search"
                    }
        , options = []
        }
    , button Searchbarbuttonstyle
        [ width (px 40)
        , height (px 40)
        , onClick
            (Types.Ipfs_dag_get
              ( case model.search of
                  General query -> query
                  _ -> ""
              )
            )
        ]--model.search) ]
        ( image None
            [ width (px 40), height (px 40) ]
            { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg")
            , caption = "start_search"
            }
        )
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
                    [ width (px 40), height (px 40) , onClick (Open_drawer (not model.drawer_isopen) )]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg")
                    , caption = "open_drawer"
                    }
                )
            , searchfield model
            -- , row None
            --     [ width fill, minWidth (px 20)]
            --     [ Input.text Searchbarstyle
            --         [ width fill, padding 10, minWidth (px 20)]
            --         { onChange = Searchfield_msg
            --         , value = ""
            --         , label =  Input.placeholder
            --                     { label = Input.hiddenLabel "" --Input.labelLeft ( empty )
            --                     , text = "search"
            --                     }
            --         , options = []
            --         }
            --     , button Searchbarbuttonstyle
            --         [ width (px 40), height (px 40), onClick (Types.Ipfs_dag_get model.searchfield) ]
            --         ( image None
            --             [ width (px 40), height (px 40) ]
            --             { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg")
            --             , caption = "start_search"
            --             }
            --         )
            --     ]
            , button Menubuttonstyle
                [ width (px 40), height (px 40) ]
                ( image None
                    [ width (px 40), height (px 40), onClick (Ipfs_add "bla") ]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg")
                    , caption = "upload_file"
                    }
                -- , text "bla"
                )

            ]

        )
    )

drawer : Types.Model -> Element Styles variation Msg
drawer model =
  el Drawerstyle
    [ width (px 200), height fill,
      case model.drawer_isopen of
        False -> hidden
        _ -> height fill

    ]
    ( column None [ height fill, width fill, xScrollbar]
        [ text "hello"
        , button Drawerbuttonstyle
            [ width fill, height (px 40), padding 4, onClick (Action_switch Account) ]
            ( row None
                [ width fill, height fill]
                [ image None
                    [ width (px 40), height fill ]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg")
                    , caption = "account_settings"
                    }
                , text "account settings"
                ]
            )
        , button Drawerbuttonstyle
            [ width fill, height (px 40), padding 4, onClick (Action_switch Account) ]
            ( row None
                [ width fill, height fill]
                [ image None
                    [ width (px 40), height fill ]
                    { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_account_circle_48px.svg")
                    , caption = "account_settings"
                    }
                , text "node settings"
                ]
            )
        ]
    )



mainview : Types.Model -> Element Styles variation Msg
mainview model =
  column None
    [ width fill, height fill ]
    [ case model.action of
        Account ->
          account model
        Browsing files ->
          browser files
        Showing_img maddr->
          show_img maddr
        Playing_audio maddr ->
          audio_player maddr
        Playing_video maddr ->
          video_player maddr
        Viewing_text maddr ->
          text_viewer maddr
    ]

qrCodeView : String -> Html.Html msg
qrCodeView message =
    QRCode.encode message
        |> Result.map QRCode.toSvg
        |> Result.withDefault
            (Html.text "Error while encoding to QRCode.")

account : Types.Model -> Element Styles variation Msg
account model =
  el None
  [ width fill, height fill ]
  ( column None
      [ width fill, height fill ]
      [ text <| "device info " ++ model.this_device.peerid ++ "peerid: " ++ "peerid"
      , text <| "devices []"
      , text <| "add device "
      , html (qrCodeView "test")

      ]
  )



browser : Types.Files -> Element Styles variation Msg
browser files =
  el Browserstyle
    [ width fill, height fill]
    ( wrappedRow None
        [ width fill, height fill, padding 20, spacing 10]
        (
          List.map file_view files --(dag_node_to_file dag_node) )
          -- ::( dag_links_file_view (.links dag_node))
        )
    )



-- dag_links_file_view : List Types.Dag_link -> List (Element Styles variation Msg)
-- dag_links_file_view dag_links =
  -- List.map file_view (List.map dag_link_to_file dag_links)

  -- List.concatMap (\f -> [file_view f])
  -- (List.map dag_link_to_file dag_links)
  --




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
        { src = maddr
        , caption = "image"
        }
    )

audio_player : Types.Maddr -> Element Styles variation Msg
audio_player maddr =
  el None
    [ width fill ]
    ( html ( Html.audio
        [ Hattr.src maddr --(maddrtourl maddr)
        , Hattr.controls True
        , Hattr.style
          [ ("width", "100%")
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
        [ Hattr.src maddr
        , Hattr.controls True
        , Hattr.style
            [ ("width", "100%")
            , ("height", "calc(100vmin - 60px)")
            , ("backgroundColor", "rgba(3, 3, 3, 1)")
            , ("overflow-x", "hidden")
            ]
        ]
        [])
    )

text_viewer : Types.Maddr -> Element Styles variation Msg
text_viewer maddr =
  el None
    [ width fill ]
    ( text "stub"--html ( Html.object
    --     [ Hattr.data maddr --(maddrtourl maddr)
    --     -- , Hattr.type_ "text/plain"
    --     , Hattr.style
    --       [ ("width", "100vw")
    --       , ("overflow-x", "hidden")
    --       , ("word-break", "break-all")
    --       ]
    --     ]
    --     [])
    )


file_view : Types.File -> Element Styles vatiation Msg
file_view file =
  el Filestyle
    [ width (px 120), height (px 180), padding 5 ]
    ( column None
        [ width fill, height fill]
        [ row None
            [ width fill, alignRight]
            [ image None
                [ width (px 20), height (px 20), onClick (Ipfs_pin (.multihash file) ) ]--file.maddr) ]
                { src = --(maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
                    if file.pinnedby == [""] then
                      (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
                    else
                      (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")

                , caption = "pin_content"
                }
            ,  image None
                [ width (px 20), height (px 20) ] --, onClick  ]
                { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg")
                , caption = "more_options"
                }

            ]
        , image None
            [ width fill, height (px 100), onClick (open file) ] --onClick (open (.maddr file))] --, onClick (Action_switch ( play file )) ]
            { src = Utils.filesymbol file --(.multihash file) --(maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
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
                [ Html.text (.name file) ] --(.maddr file) ]
            )
        -- , paragraph None
        --     [ width fill, height (px 50)]
        --     [ text (.maddr file) ]
        ]
    )



-- file_view : Types.Dag_link -> List (Element Styles variation Msg)
-- file_view dag_link =
--   [ el Filestyle
--       [ width (px 120), height (px 180), padding 5 ]
--       ( column None
--           [ width fill, height fill]
--           [ row None
--               [ width fill, alignRight]
--               [ image None
--                   [ width (px 20), height (px 20), onClick (Ipfs_pin (.multihash dag_link) ) ]--file.maddr) ]
--                   { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
--                       -- if file.ispinned == False then
--                       --   (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
--                       -- else
--                       --   (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
--
--                   , caption = "pin_content"
--                   }
--               ,  image None
--                   [ width (px 20), height (px 20) ]
--                   { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg")
--                   , caption = "more_options"
--                   }
--
--               ]
--           , image None
--               [ width fill, height (px 100), onClick (open dag_link)] --, onClick (Action_switch ( play file )) ]
--               { src = maddrtourl (Utils.filesymbol dag_link) --(maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg") --(Utils.filesymbol file)
--               , caption = "play_file"
--               }
--           , html
--               ( Html.p
--                   [ Hattr.style
--                       [ ("overflow-x", "hidden")
--                       , ("overflow-y", "ellipsis")
--                       , ("text-overflow", "ellipsis")
--                       , ("max-height", "50px")
--                       , ("width", "110px")
--                       , ("margin", "0")
--                       , ("word-break", "break-all" )
--                       ]
--                   ]
--                   [ Html.text (.name dag_link) ] --(.maddr file) ]
--               )
--           -- , paragraph None
--           --     [ width fill, height (px 50)]
--           --     [ text (.maddr file) ]
--           ]
--       )
--   ]
