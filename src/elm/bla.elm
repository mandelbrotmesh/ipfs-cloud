
type Styles
  = None
  | Menustyle
  | Drawerstyle
  | Mainviewstyle
  | Searchbarstyle


stylesheet =
  Style.styleSheet
    [ Style.style None []
    , Style.style Menustyle
        [ Color.background blue, Font.size 60]
    , Style.style Drawerstyle
        [ Color.background blue ]
    , Style.style Mainviewstyle
        [ Color.background white ]
    , Style.style Searchbarstyle
        [ Color.background gray ]
    ]

menu : Element Styles variation Msg
menu =
  row None [ padding 14, spacing 12, height fill,  width fill, spread]
    [ Element.image None [ width (fillPortion 2), maxWidth (px 140) ]
      { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/navigation/svg/production/ic_menu_48px.svg"
      , caption = "open_drawer"
      }
    , Input.text Searchbarstyle
        [ height fill, width (fillPortion 1), padding 14]
        { onChange = Acc_submit_msg
        , value = "shit"
        , label = Input.labelRight
              ( Element.image Searchbarstyle [ height fill, width (fillPortion 1), maxWidth (px 140)]
                { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg"
                , caption = "search"
                }
              )
        , options = []
        }
        -- , Element.image Mainviewstyle [ alignRight, height fill, width (fillPortion 1) ]
        --   { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/action/svg/production/ic_search_48px.svg"
        --   , caption = "search"
        --   }
        -- , Element.image Mainviewstyle [ alignRight, height fill, width (fillPortion 1)]
        --   { src = "https://ipfs.io/ipfs/QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/content/svg/production/ic_add_48px.svg"
        --   , caption = "upload"
        --   }
        , Element.image None [ width (fillPortion 2), maxWidth (px 140)  ]
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
        , height (fillPortion 1) ]
        (menu)
    , el Mainviewstyle
        [ width (fill)
        , height (fillPortion 11) ]
        ( mainview )
    ]
