module App.State exposing (init, subscriptions, update)

{-|

@docs update, init

-}

import App.Commands as GiphyCmd exposing (send)
import App.Configs as Configs exposing (..)
import App.Giphy.Commands as GiphyCmd exposing (..)
import App.Giphy.Utils exposing (..)
import App.Phx.Phx as AppPhx exposing (..)
import App.Phx.Types as AppPhxTypes exposing (..)
import App.Types as AppTypes exposing (..)
import App.Views.StateHelpers as StateHelpers exposing (..)
import Dom
import Phoenix.Socket exposing (init, on)
import Task exposing (perform, succeed)
import Time
import Yarimoji as Ymoji exposing (yariMojiTranslate)


-- UPDATE


update : AppTypes.Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FocusResult result ->
            case result of
                Err (Dom.NotFound id) ->
                    ( model, Cmd.none )

                Ok () ->
                    ( model, Cmd.none )

        FocusGifSearchBox ->
            ( StateHelpers.setReactionsTab 1 model, Dom.focus "gifSearchBox" |> Task.attempt FocusResult )

        FocusMessageBox ->
            ( StateHelpers.setReactionsTab -1 model, Dom.focus "messageBox" |> Task.attempt FocusResult )

        ScrollChat e ->
            ( StateHelpers.setStopAutoScroll (not <| e.scrollPos == e.scrollHeight - e.visibleHeight) model, Cmd.none )

        ToggleChat ->
            ( model
                |> StateHelpers.setChatVisible (not model.viewsState.chatVisible)
                |> StateHelpers.setReactionsTab -1
            , Task.perform (AppPhx.sendToApp JoinChannel) (Task.succeed ())
            )

        ReactionsSelectTab idx ->
            let
                commands =
                    if idx /= 1 then
                        Cmd.none
                    else
                        GiphyCmd.send FocusGifSearchBox
            in
            ( StateHelpers.setReactionsTab idx model, commands )

        PhoenixMsg msg ->
            AppPhx.phoenixUpdate model msg

        PhxApp phxMsg ->
            AppPhx.msgRouter phxMsg model

        SendMessage ->
            if model.newMessage |> String.startsWith "@gif " then
                (!) model
                    [ model.newMessage
                        |> String.dropLeft 4
                        |> translateGif PostGif
                    ]
            else
                AppPhx.sendNewMessage model

        SetMessageAndSend str ->
            (!) { model | newMessage = str } [ send SendMessage, send FocusMessageBox ]

        SetNewMessage str ->
            let
                newModel =
                    translateEmojis str model
            in
            (!) newModel [ send FocusMessageBox ]

        GifSearchBoxInput input ->
            (!) { model | gifInput = input } []

        ReceiveGifs result ->
            case result of
                Err _ ->
                    (!) model []

                Ok listIDs ->
                    case listIDs of
                        [] ->
                            { model | gifs = [] } ! []

                        x :: xs ->
                            { model | gifs = List.append listIDs model.gifs |> List.take numberGifsInPane } ! []

        PostGif result ->
            case result of
                Err _ ->
                    (!) model []

                Ok id ->
                    (!) model
                        [ id
                            |> giphyOriginal
                            |> SetMessageAndSend
                            |> send
                        ]

        Tick _ ->
            let
                cmd =
                    if model.gifInput /= model.gifLastInput then
                        if model.gifInput |> String.isEmpty |> not then
                            [ searchGIF numberGifsInPane ReceiveGifs model.gifInput ]
                        else
                            [ initGifRequest ]
                    else
                        []
            in
            (!) { model | gifLastInput = model.gifInput } cmd

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
        , Time.every Time.second Tick
        ]



-- MODEL


init : ( Model, Cmd Msg )
init =
    (!) initModel [ initGifRequest ]


initModel : Model
initModel =
    { headerData = Configs.initDemoHeaderData
    , usersData = Configs.initUsersDataDemo
    , phxSocket = AppPhx.initPhxSocket Configs.wsServer
    , messages = []
    , newMessage = ""
    , viewsState = initViewState
    , gifs = []
    , gifInput = ""
    , gifLastInput = ""
    , initialGifKeyword = Configs.initialGifKeyword
    }


initGifRequest : Cmd Msg
initGifRequest =
    initModel.initialGifKeyword
        |> searchGIF Configs.numberGifsInPane ReceiveGifs


initViewState : ViewsState
initViewState =
    { chatVisible = False
    , reactionsTab = -1
    , stopAutoScroll = False
    }



{- translate emojis -}


translateEmojis : String -> Model -> Model
translateEmojis str model =
    if Ymoji.yariCheckEmoji model.newMessage then
        { model | newMessage = Ymoji.yariMojiTranslateAll str }
    else
        { model | newMessage = str }
