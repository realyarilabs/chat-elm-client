module App.Styles.Utilities exposing (..)

{-| -}

import Html.Attributes exposing (style)
import App.Styles.General as Styles exposing (..)


{-| create a styles list
-}
styleList list =
    list
        |> List.concat
        |> style



------------------------------------------------------------------------ Styles
-- cursor


cursor_pointer =
    [ ( "cursor", "pointer" ) ]


cursor_help =
    [ ( "cursor", "help" ) ]


cursor_wait =
    [ ( "cursor", "wait" ) ]



-- align elements


align_center =
    [ ( "margin-right", "auto" )
    , ( "margin-left", "auto" )
    ]


align_left =
    [ ( "margin-right", "auto" )
    , ( "margin-left", "0" )
    ]


align_right =
    [ ( "margin-right", "0" )
    , ( "margin-left", "auto" )
    ]


align_vertical =
    [ ( "margin-top", "auto" )
    , ( "margin-bottom", "auto" )
    ]



-- padding


padding_top n =
    [ ( "padding-top", n ++ "px" ) ]


padding val =
    [ ( "padding", val ) ]



-- margin


margin_top n =
    [ ( "margin-top", n ++ "px" ) ]



-- limit length's


limit_width : String -> List ( String, String )
limit_width val =
    [ ( "width", val ) ]


limit_height : String -> List ( String, String )
limit_height val =
    [ ( "height", val ) ]



-- text Utilities


text_center =
    [ ( "text-align", "center" ) ]


text_left =
    [ ( "text-align", "left" ) ]


text_right =
    [ ( "text-align", "right" ) ]


text_justify =
    [ ( "text-align", "justify" ) ]



-- display


display_inline_block =
    [ ( "display", "inline-block" ) ]


display_block =
    [ ( "display", "block" ) ]



-- text limit not show


text_limit_hidden =
    [ ( "overflow", "hidden" )
    , ( "white-space", "nowrap" )
    , ( "text-overflow", "ellipsis" )
    ]



-- select


disable_select =
    [ ( "-moz-user-select", "none" )
    , ( "-ms-user-select", "none" )
    , ( "-webkit-user-select", "none" )
    , ( "user-select", "none" )
    ]
