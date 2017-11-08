module App.Styles.General exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (style)


{-
   Colors
-}


bgBtns : String
bgBtns =
    "#fcbd11"


fontColorBtn : String
fontColorBtn =
    "#ffffff"


actionColorBtn : String
actionColorBtn =
    "#000000"


widgetBg : String
widgetBg =
    "#ffffff"


mainMenuBg : String
mainMenuBg =
    "#2F3047"



{-
   Styles for yarilabs_chat
-}


sendNewMsg : Attribute msg
sendNewMsg =
    style
        [ ( "margin-left", "5px" )
        , ( "margin-right", "5px" )
        , ( "color", "#1A237E" )
        ]


sendNewMsgOpt : Attribute msg
sendNewMsgOpt =
    style
        [ ( "margin-top", "17px" ) ]


flexContainer : Attribute msg
flexContainer =
    style
        [ ( "display", "-webkit-box" )
        , ( "display", "-ms-flexbox" )
        , ( "display", "flex" )
        , ( "-ms-flex-wrap", "nowrap" )
        , ( "flex-wrap", "nowrap" )
        , ( "-webkit-box-orient", "horizontal" )
        , ( "-webkit-box-direction", "normal" )
        , ( "-ms-flex-direction", "row" )
        , ( "flex-direction", "row" )
        ]


tooltipAvatarCss : Attribute msg
tooltipAvatarCss =
    style
        [ ( "width", "75px" )
        , ( "height", "75px" )
        ]
