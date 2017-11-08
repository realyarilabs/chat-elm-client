module App.CustomEvents.DomEvents exposing (onScroll, onKeyDown, toBottomViewPort, toBottomViewPortTask)

{-| Custom Events for dom actions like focus, scroll events, keyboard events, etc)
@docs onScroll, onKeyDown, toBottomViewPort, toBottomViewPortTask
-}

import Html exposing (..)
import Html.Events exposing (on, keyCode)
import App.CustomEvents.Types exposing (..)
import Json.Decode as JD
import Dom.Scroll
import Task exposing (Task)
import App.Types exposing (..)


{-
   Keyboard event
-}


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (JD.map tagger keyCode)


{-| event Scroll
-}
onScroll : (ScrollEvent -> msg) -> Html.Attribute msg
onScroll tagger =
    Html.Events.on "scroll" (JD.map tagger onScrollJsonParser)


{-| Decoders for onScroll type
-}
onScrollJsonParser : JD.Decoder ScrollEvent
onScrollJsonParser =
    JD.map3 ScrollEvent
        (JD.at [ "target", "scrollHeight" ] JD.int)
        (JD.at [ "target", "scrollTop" ] JD.int)
        (JD.at [ "target", "clientHeight" ] JD.int)


{-| -}
toBottomViewPort : Bool -> Cmd Msg
toBottomViewPort stopAutoScroll =
    if stopAutoScroll then
        Cmd.none
    else
        Dom.Scroll.toBottom "msg-containner"
            |> Task.attempt (always NoOp)


{-| -}
toBottomViewPortTask stopAutoScroll =
    if stopAutoScroll then
        Task.succeed ()
    else
        Dom.Scroll.toBottom "msg-containner"
