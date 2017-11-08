module App.View exposing (..)

{-| -}

import App.CustomEvents.DomEvents as DomEvents exposing (onScroll)
import App.MessagesTypes exposing (..)
import App.Types as AppTypes exposing (..)
import App.Views.ReactionsPane as AVReactions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import App.Views.StateHelpers as StateHelpers exposing (..)


-- VIEW


view : Model -> Html Msg
view model =
    if getChatVisible model then
        widgetChat model
    else
        widgetBtn model


widgetBtn : Model -> Html Msg
widgetBtn model =
    div
        [ id "widget-btn"
        , class "shadow-1"
        , onClick ToggleChat
        ]
        [ div [ class "icosvg-yari" ] [] ]


widgetChat : Model -> Html Msg
widgetChat model =
    div
        [ class "widget-containner shadow-1"
        ]
        [ widgetChatHeader model
        , widgetChatContent model
        , widgetChatFooter model
        ]


widgetChatHeader : Model -> Html Msg
widgetChatHeader model =
    let
        title =
            div
                [ class "chat-title text-limit"
                ]
                [ model.headerData.chat_title
                    |> Maybe.withDefault ""
                    |> text
                ]

        hostStatus =
            div
                [ class "host-status text-limit" ]
                [ model.headerData.host_status
                    |> Maybe.withDefault ""
                    |> text
                ]

        statusOnlineCss isOnline =
            if isOnline == "online" then
                style [ ( "border", "1.2px solid #7FFF00" ) ]
            else
                style [ ( "border", "1.2px solid #FFF" ) ]

        mapAvatars i =
            div [ attribute "tooltip" i.displayName, attribute "tooltip-position" "right", attribute "tooltip-image" i.avatar ]
                [ img [ class "avatarHeader", statusOnlineCss i.status, src i.avatar ] []
                ]

        hostTeam =
            div []
                [ model.usersData
                    |> List.filter (\usr -> usr.userType /= "visitor")
                    |> List.map mapAvatars
                    |> div []
                ]

        closeBtn =
            div [ class "btn-close", onClick ToggleChat ]
                [ div [ class "ico-close" ] []
                ]
    in
        div
            [ class "chat-header"
            ]
            [ div
                []
                [ title
                , hostStatus
                , hostTeam
                , closeBtn
                ]
            ]


widgetChatContent : Model -> Html Msg
widgetChatContent model =
    div
        [ id "chat-body"
        , class "chat-body"
        , onClick FocusMessageBox
        ]
        [ ul
            [ id "msg-containner"
            , onScroll ScrollChat
            ]
          <|
            (List.reverse << List.map renderMessage) model.messages
        ]


renderMessage : MessageData -> Html Msg
renderMessage msg =
    let
        isAsystemMsg =
            String.startsWith "SYSTEM" msg.userId

        isHost =
            String.startsWith "host" msg.userId

        classListMsg =
            classList
                [ ( "message-host", String.startsWith "host" msg.userId )
                , ( "message-visitor", not isHost )
                ]

        avatar =
            "http://icons.iconarchive.com/icons/hopstarter/face-avatars/256/Male-Face-K3-icon.png"

        parseToHtml elem =
            case elem of
                Body data ->
                    div [ class "message-text-plain" ] [ text data.body ]

                Media data ->
                    let
                        payload =
                            data.content
                    in
                        div [ class "message-media" ] [ img [ src payload.url ] [] ]

                _ ->
                    toString elem |> text

        listOfParts =
            msg.parts
                |> List.map parseToHtml
    in
        if isAsystemMsg then
            li [ class "message-system" ] listOfParts
        else
            li [ classListMsg ]
                [ img [ src avatar, class "avatar" ] []
                , div [ class "bubble" ] listOfParts
                ]


widgetChatFooter : Model -> Html Msg
widgetChatFooter model =
    div
        [ class "chat-footer" ]
        [ newMessageForm model
        ]


newMessageForm : Model -> Html Msg
newMessageForm model =
    Html.form
        [ onSubmit SendMessage
        ]
        [ input [ id "messageBox", type_ "text", onInput SetNewMessage, value model.newMessage, placeholder "Compose your message...", class "new-message" ] []
        , AVReactions.view model
        ]
