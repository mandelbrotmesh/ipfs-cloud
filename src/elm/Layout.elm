module Layout exposing (..)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color as Color

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Element.Input exposing (search, text, disabled)

type Test =
  String

-- type Styles
--   = None
--   | Menustyle
--   | Drawerstyle
--   | Mainviewstyle
--
-- type Msg
--   = Acc_submit_msg String
--   | Use_drawer Bool
--
-- stylesheet =
--   Style.styleSheet
--     [ Style.style None []
--     , Style.style Menustyle
--         [ Color.background blue ]
--         [ Color.background blue ]
--     , Style.style Drawerstyle
--     , Style.style Mainviewstyle
--         [ Color.background yellow ]
--     ]
