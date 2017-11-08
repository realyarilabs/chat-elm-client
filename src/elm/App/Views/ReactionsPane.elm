module App.Views.ReactionsPane exposing (..)

{-| Views with tabs for emoji and gifs
-}

import App.Giphy.Utils exposing (..)
import App.Styles.Utilities as CssUtils exposing (..)
import App.Types exposing (..)
import App.Views.StateHelpers as StateHelpers exposing (getReactionsTab, getStopAutoScroll)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onMouseUp, onSubmit)
import Yarimoji as Ymoji exposing (emojidb)


reactionsTabsView : Model -> Html Msg
reactionsTabsView model =
    let
        reactTabState =
            getReactionsTab model

        tabsContent =
            case reactTabState of
                0 ->
                    div
                        [ CssUtils.styleList [ cursor_pointer ]
                        ]
                        [ listOfEmojis model.newMessage
                        ]

                _ ->
                    div
                        [ CssUtils.styleList [ align_center, cursor_pointer ]
                        ]
                        [ input
                            [ id
                                "gifSearchBox"
                            , placeholder
                                "Find some gifs"
                            , onInput GifSearchBoxInput
                            ]
                            []
                        , if model.gifs |> List.isEmpty then
                            text "No gifs found."
                          else
                            listOfGifs model.gifs
                        ]

        myClass idx =
            classList
                [ ( "tab-selected", reactTabState == idx )
                , ( "anim-fade", True )
                ]

        tabs =
            [ ( "Smileys", 0 ), ( "Gifs", 1 ) ]
                |> List.map
                    (\( label, idx ) ->
                        a [ onClick <| ReactionsSelectTab idx, myClass idx ] [ text label ]
                    )
    in
        div
            [ class "tab-wrapper"
            ]
            [ div
                []
                [ div [ class "tab-nav" ]
                    tabs
                , div [ class "tab-contents" ]
                    [ tabsContent
                    ]
                ]
            ]


listOfGifs : List String -> Html Msg
listOfGifs gifsURLs =
    let
        showGIF id =
            img
                [ style
                    [ ( "border-radius", "15%" )
                    , ( "margin", "4px" )
                    ]
                , src <| giphyFixedHeightSmall id
                , width 60
                , height 50
                , ReactionsSelectTab -1
                    |> onMouseUp
                , giphyOriginal id
                    |> SetMessageAndSend
                    |> onClick
                ]
                []
    in
        gifsURLs
            |> List.map showGIF
            |> div
                [ style
                    [ ( "text-align", "center" ) ]
                ]


listOfEmojis : String -> Html Msg
listOfEmojis newMessage =
    let
        styleEmj =
            style
                [ ( "margin", "5px" )
                , ( "display", "inline-block" )
                , ( "font-size", "1.533em" )
                ]

        showEmojis ( emj, key ) =
            div
                [ styleEmj
                , onMouseUp (ReactionsSelectTab -1)
                , onClick (SetNewMessage <| newMessage ++ " " ++ emj)
                ]
                [ text emj ]
    in
        Ymoji.emojidb
            |> List.map showEmojis
            |> div []


reactionsButtons : Int -> Html Msg
reactionsButtons recTabVal =
    span [ id "icons" ]
        [ span
            [ tooglePaneEvent recTabVal 0
            , class "btn-reactions"
            ]
            [ div [ class "icosvg-smile" ] []
            ]
        , span
            [ tooglePaneEvent recTabVal 1
            , class "btn-reactions"
            ]
            [ div [ class "icosvg-gif" ] []
            ]
        , span
            [ class "btn-reactions"
            ]
            [ div [ class "icosvg-more" ] []
            ]
        ]


toogleVal : Int -> Int -> Int
toogleVal tabIdx tabVal =
    if tabIdx == -1 then
        tabVal
    else
        -1


tooglePaneEvent : Int -> Int -> Html.Attribute Msg
tooglePaneEvent tabIdx tabVal =
    onClick (ReactionsSelectTab (toogleVal tabIdx tabVal))


view : Model -> Html Msg
view model =
    let
        reactTabState =
            getReactionsTab model

        reactionTabsView =
            if reactTabState /= -1 then
                reactionsTabsView model
            else
                span [] []

        customStyles =
            style [ ( "font-size", "1.8em" ) ]
    in
        span
            [ customStyles
            , CssUtils.styleList [ disable_select, align_vertical ]
            ]
            [ reactionTabsView
            , reactionsButtons reactTabState
            ]
