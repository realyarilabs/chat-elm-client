module App.Types exposing (..)

{-| -}

import App.CustomEvents.Types exposing (ScrollEvent)
import App.MessagesTypes exposing (..)
import App.Phx.Types exposing (PhxMsg)
import Dom exposing (Error)
import Http exposing (Error)
import Phoenix.Socket exposing (Msg)


type Msg
    = SendMessage
    | FocusGifSearchBox
    | FocusMessageBox
    | FocusResult (Result Dom.Error ())
    | SetNewMessage String
    | SetMessageAndSend String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | PhxApp PhxMsg
    | ToggleChat
    | ReactionsSelectTab Int
    | GifSearchBoxInput String
    | ReceiveGifs (Result Http.Error (List String))
    | PostGif (Result Http.Error String)
    | Tick Float
    | ScrollChat ScrollEvent
    | NoOp


type alias Model =
    { headerData : ChatHeaderData
    , usersData : List UserData
    , phxSocket : Phoenix.Socket.Socket Msg
    , messages : List MessageData
    , newMessage : String
    , viewsState : ViewsState
    , gifs : List String
    , gifInput : String
    , gifLastInput : String
    , initialGifKeyword : String
    }


type alias ViewsState =
    { chatVisible : Bool
    , reactionsTab : Int
    , stopAutoScroll : Bool
    }


type alias ChatHeaderData =
    { chat_title : Maybe String
    , host_status : Maybe String
    }


type alias UserData =
    { userID : String
    , avatar : String
    , displayName : String
    , status : String
    , userType : String
    }
