module App.Phx.Phx exposing (..)

{-|

    Module with helpers for working with phoenix state
-}

import App.Data as AppData exposing (..)
import App.MessagesTypes as MessageTypes exposing (..)
import App.Types as AppTypes exposing (..)
import Json.Decode as JD exposing (..)
import Json.Encode as JE exposing (object, string)
import Phoenix.Channel exposing (..)
import Phoenix.Push exposing (init, withPayload)
import Phoenix.Socket exposing (init, on)
import App.CustomEvents.DomEvents as DomEvents exposing (..)
import App.Phx.Types as PhxTypes exposing (..)
import App.Commands as Commands exposing (sleepAndSend)


{-| phx init model
-}
initPhxSocket : String -> Phoenix.Socket.Socket Msg
initPhxSocket socketServer =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.on "new:msg" "rooms:lobby" (sendToApp ReceiveChatMessage)
        |> Phoenix.Socket.on "new:media_msg" "rooms:lobby" (sendToApp ReceiveChatMessage)
        |> Phoenix.Socket.withHeartbeatInterval 30
        |> Phoenix.Socket.withDebug


{-| phx msg
-}
phoenixUpdate : Model -> Phoenix.Socket.Msg Msg -> ( Model, Cmd Msg )
phoenixUpdate model msg =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


{-| Helper for compose routing msg's to the app
-}
sendToApp : (msg -> PhxMsg) -> msg -> Msg
sendToApp msg =
    (PhxApp << msg)


{-| PhxApp msg router
-}
msgRouter : PhxMsg -> Model -> ( Model, Cmd Msg )
msgRouter phxmsg model =
    case phxmsg of
        ReceiveChatMessage raw ->
            receiveChatMsg model raw [ (scrollToBottomCmd (model.viewsState).stopAutoScroll) ]

        JoinChannel _ ->
            joinChannel model ""

        LeaveChannel ->
            leaveChannel model ""

        ShowJoinedMessage channelName ->
            showJoinedMessage model channelName

        ShowLeftMessage channelName ->
            showLeftMessage model channelName


{-| Scroll to bottom
-}
scrollToBottomCmd : Bool -> Cmd Msg
scrollToBottomCmd stopAutoScroll =
    DomEvents.toBottomViewPortTask stopAutoScroll
        |> Commands.sleepAndSend 0.5 NoOp


{-| Helper for send new messages
-}
sendNewMessage : Model -> ( Model, Cmd Msg )
sendNewMessage model =
    let
        newMessage =
            model.newMessage
                |> String.toLower
    in
        if String.endsWith ".gif" newMessage then
            sendGifMessage model
        else
            sendOnlyTextMessage model


sendGifMessage : Model -> ( Model, Cmd Msg )
sendGifMessage model =
    let
        payload =
            JE.object [ ( "user", JE.string "user" ), ( "url", JE.string model.newMessage ) ]

        push_ =
            Phoenix.Push.init "new:media_msg" "rooms:lobby"
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ model.phxSocket
    in
        ( { model | newMessage = "", phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


sendOnlyTextMessage : Model -> ( Model, Cmd Msg )
sendOnlyTextMessage model =
    let
        payload =
            JE.object [ ( "user", JE.string "user" ), ( "body", JE.string model.newMessage ) ]

        push_ =
            Phoenix.Push.init "new:msg" "rooms:lobby"
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ model.phxSocket
    in
        ( { model | newMessage = "", phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


{-| Helper for receive new message
-}
receiveChatMsg : Model -> JE.Value -> List (Cmd Msg) -> ( Model, Cmd Msg )
receiveChatMsg model raw cmdLst =
    case JD.decodeValue AppData.messageDataDecoder raw of
        Ok messageDec ->
            let
                tmp =
                    messageDec |> Debug.log "OK"
            in
                (!) { model | messages = messageDec :: model.messages } cmdLst

        Err error ->
            let
                tmp =
                    error |> Debug.log "ERR "
            in
                (!) model []


{-| Join in to a channel
-}
joinChannel : Model -> String -> ( Model, Cmd Msg )
joinChannel model channelName =
    let
        channel =
            Phoenix.Channel.init "rooms:lobby"
                |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin (always (sendToApp ShowJoinedMessage "rooms:lobby"))
                |> Phoenix.Channel.onClose (always (sendToApp ShowLeftMessage "rooms:lobby"))

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


leaveChannel : Model -> String -> ( Model, Cmd Msg )
leaveChannel model channelName =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave "rooms:lobby" model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


showJoinedMessage : Model -> String -> ( Model, Cmd Msg )
showJoinedMessage model channelName =
    ( { model | messages = (MessageData "" "" [ Body (BodyPart "text/plain" ("Joined on " ++ channelName)) ] "" "" "") :: model.messages }
    , Cmd.none
    )


showLeftMessage : Model -> String -> ( Model, Cmd Msg )
showLeftMessage model channelName =
    ( { model | messages = (MessageData "" "" [ Body (BodyPart "text/plain" ("Left from " ++ channelName)) ] "" "" "") :: model.messages }
    , Cmd.none
    )
