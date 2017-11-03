module Layout exposing (..)

import Style exposing (..)
import Types exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Element.Events exposing (..)

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
  el Menustyle
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
                [ width (px 40), height (px 40) ]
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
                [ width (px 40), height (px 40) ]
                { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_file_upload_48px.svg")
                , caption = "upload_file"
                }
            )

        ]

    )


mainview : Types.Model -> Element Styles variation Msg
mainview model =
  case model.action of
    Browsing files ->
      browser files
    Showing_img maddr->
      show_img maddr
    Playing_audio maddr ->
      audio_player maddr
    Playing_video maddr ->
      video_player maddr



browser : Types.Files -> Element Styles variation Msg
browser files =
  el Browserstyle
    [ width fill, height fill]
    ( row None
        [ width fill, height fill, padding 20, spacing 10, spread]
        ( List.concatMap file_view files )
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
    []
    ( html ( Html.audio
        [ Hattr.src (maddrtourl maddr)
        , Hattr.controls True
        , Hattr.style
          [ ("width", "100vw")
          ]
        ]
        [])
    )

video_player : Types.Maddr -> Element Styles variation Msg
video_player maddr =
  el None
    []
    ( html ( Html.video
        [ Hattr.src (maddrtourl maddr)
        , Hattr.controls True
        , Hattr.style
            [ ("width", "100vw")
            ]
        ]
        [])
    )

file_view : Types.File -> List (Element Styles variaion Msg)
file_view file =
  [ el Filestyle
      [ width (px 120), height (px 180), padding 5 ]
      ( column None
          [ width fill, height fill]
          [ row None
              [ width fill, alignRight]
              [ image None
                  [ width (px 20), height (px 20), onClick (Ipfs_pin file.maddr) ]
                  { src =
                      if file.ispinned == False then
                        (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
                      else
                        (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")

                  , caption = "pin_content"
                  }
              ,  image None
                  [ width (px 20), height (px 20) ]
                  { src = (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg")
                  , caption = "more_options"
                  }

              ]
          , image None
              [ width fill, height (px 100), onClick (Action_switch ( play file )) ]
              { src = (Utils.filesymbol file)
              , caption = "play_file"
              }
          , paragraph None
              [ width fill, height (px 50)]
              [ text (.maddr file) ]
          ]
      )
  ]
  --
  --
  -- [ div
  --     [ style
  --         [ ("margin", "5px")
  --         , ("width", "120px")
  --         -- , ("max-width", "140px")
  --         , ("height", "180px")
  --         , ("backgroundColor", "rgba(255, 255, 255, 1")
  --         , ("box-shadow", "3px 3px 3px #888888")
  --         , ("padding", "5px")
  --         ]
  --     ]
  --     [ div
  --         [ style
  --             [("display", "flex")
  --             , ("flex-direction", "row-reverse")
  --             ]
  --         ]
  --         [ --text file.mime
  --          img
  --             [ src (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_more_vert_48px.svg") --"https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_expand_more_48px.svg"
  --             , style
  --                 [ ("width", "20px")
  --                 , ("height", "20px")
  --                 , ("fill", "gray")
  --                 ]
  --             ]
  --             []
  --           , img
  --             [ src
  --                 ( if file.ispinned == False then
  --                     (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_border_24px.svg")
  --                   else
  --                     (maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/toggle/svg/production/ic_star_24px.svg")
  --                 )
  --             , style
  --                 [ ("width", "20px")
  --                 , ("height", "20px")
  --                 , ("fill", "gray")
  --                 ]
  --             , onClick (Ipfs_pin file.maddr)
  --             ]
  --             []
  --         ]
  --     , img
  --         [ src (filesymbol file) --(.mime hs) --(filesymbol hs)
  --         , style
  --             [ ("width", "120px")
  --             , ("max-height", "100px")
  --             , ("fill", "gray")]
  --         , onClick (Action_switch ( play file )) --"QmTca4A43f4kEvzTouvYTegtp6KobixRqweV12NrvwwtFP"))--"QmaMc3URC5Jqt3HrfP2beBkB56Y232YUqR3itguzup91je"))
  --         ]
  --         []
  --         --(.mime hs) --(filesymbol hs)
  --     , p
  --         [ style
  --             [ ("overflow-x", "hidden")
  --             , ("overflow-y", "ellipsis")
  --             , ("text-overflow", "ellipsis")
  --             , ("max-height", "50px")
  --             , ("width", "120px")
  --             , ("margin", "0")
  --             , ("word-break", "break-all" )
  --
  --             -- , ("position", "absolute")
  --             -- , ("top", "100px")
  --             ]
  --         ]
  --         [text (.maddr file) ]
  --     ]
  --   ]
