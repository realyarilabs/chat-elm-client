module App.Views.StateHelpers exposing (..)

import App.Types as AppTypes exposing (Model)


{-| This module have all helpers functions for manipulate records for all widget views states
-}
setStopAutoScroll : Bool -> Model -> Model
setStopAutoScroll value model =
    let
        viewsState =
            model.viewsState
    in
        { model | viewsState = { viewsState | stopAutoScroll = value } }


getStopAutoScroll : Model -> Bool
getStopAutoScroll model =
    (model.viewsState).stopAutoScroll


{--}
setReactionsTab : Int -> Model -> Model
setReactionsTab value model =
    let
        viewsState =
            model.viewsState
    in
        { model | viewsState = { viewsState | reactionsTab = value } }


getReactionsTab : Model -> Int
getReactionsTab model =
    (model.viewsState).reactionsTab


{--}
setChatVisible : Bool -> Model -> Model
setChatVisible value model =
    let
        viewsState =
            model.viewsState
    in
        { model | viewsState = { viewsState | chatVisible = value } }


getChatVisible : Model -> Bool
getChatVisible model =
    (model.viewsState).chatVisible
