module App.Phx.Types exposing (..)

import Json.Encode as JE exposing (Value)


type PhxMsg
    = ReceiveChatMessage JE.Value
    | JoinChannel ()
    | LeaveChannel
    | ShowJoinedMessage String
    | ShowLeftMessage String
