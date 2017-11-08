module App exposing (..)

-- MAIN

import App.State as State exposing (init, subscriptions, update)
import App.Types as AppTypes exposing (Model, Msg)
import App.View as View exposing (view)
import Html exposing (program)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
