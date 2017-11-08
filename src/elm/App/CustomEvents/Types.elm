module App.CustomEvents.Types exposing (ScrollEvent)


type alias ScrollEvent =
    { scrollHeight : Int
    , scrollPos : Int
    , visibleHeight : Int
    }
