module Stylesheet exposing (..)

import Types exposing (..)
import Style exposing(..)
import Style.Color as Color
import Color exposing (..)
import Style.Shadow as Shadow
import Style.Border as Border

-- overlaystyle =
--   style
--     [ ("position", "fixed")
--     , ("width", "100vw")
--     , ("height", "100vh")
--     , ("top", "0")
--     , ("left", "100vw")
--     , ("bottom", "0")
--     , ("right", "0")
--     , ("backgroundColor", "rgba(0, 0, 0, 0.5)")
--     , ("z-index", "2")
--     ]

stylesheet : StyleSheet Styles variation
stylesheet =
  Style.styleSheet
    [ Style.style None []
    , Style.style Menustyle
        [ --Color.text darkGrey
          Color.background (Color.rgba 240 40 40 1)
        , Shadow.box
            { offset = ( 0, 3 )
            , size = 3
            , blur = 2
            , color = (Color.rgba  80 80 80 1)
            }
        ]
    , Style.style Menubuttonstyle
        [ Color.background (Color.rgba 0 0 0 0)
        , Border.none
        ]
    , Style.style Searchbarstyle
        [ Color.background (Color.rgba 136 136 136 1)
        , Border.roundTopLeft 5
        , Border.roundBottomLeft 5
        ]
    , Style.style Searchbarbuttonstyle
        [ Color.background (Color.rgba 80 80 80 1)
        , Border.roundTopRight 5
        , Border.roundBottomRight 5
        ]
    , Style.style Browserstyle
        [ Color.background (Color.rgba 229 229 229 1)
        ]
    , Style.style Filestyle
        [ Color.background white
        , Shadow.box
            { offset = ( 0, 3 )
            , size = 3
            , blur = 2
            , color = (Color.rgba  80 80 80 1)
            }
        ]
    ]
