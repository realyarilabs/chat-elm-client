module App.Configs exposing (..)

import App.Types as AppTypes exposing (..)


{- Address for ws phx server -}


wsServer : String
wsServer =
    -- "ws://localhost:4000/socket/websocket"
    "wss://mercurio-chat.herokuapp.com/socket/websocket"



{- ==============================   General Configs ========================= -}


initDemoHeaderData : ChatHeaderData
initDemoHeaderData =
    { chat_title = Just "👋 Questions ? chat with us!"
    , host_status = Just "Was last active 1 hour ago. Usually answers in 1 hour."
    }


initUsersDataDemo : List UserData
initUsersDataDemo =
    [ UserData "1" "http://www.iconninja.com/files/782/881/288/avatar-black-face-angry-icon.png" "Vitor" "online" "visitor"
    , UserData "2" "http://icons.iconarchive.com/icons/hopstarter/face-avatars/256/Male-Face-K3-icon.png" "Xavier" "offline" "host"
    , UserData "3" "https://www.shareicon.net/data/2015/12/14/207818_face_300x300.png" "Samurai" "online" "host"
    , UserData "4" "https://www.shareicon.net/download/2015/12/14/207814_face_300x300.png" "Helder" "online" "host"
    , UserData "5" "http://icons.iconarchive.com/icons/hopstarter/face-avatars/256/Male-Face-A3-icon.png" "Ricardo" "online" "host"
    , UserData "6" "http://www.iconarchive.com/download/i47466/hopstarter/face-avatars/Male-Face-F1.ico" "Filipe" "online" "host"
    , UserData "7" "http://www.iconarchive.com/download/i47414/hopstarter/face-avatars/Female-Face-FC-4.ico" "Susana" "offline" "host"
    , UserData "1" "http://www.iconninja.com/files/782/881/288/avatar-black-face-angry-icon.png" "Vitor" "online" "host"
    ]


numberGifsInPane : Int
numberGifsInPane =
    8


initialGifKeyword : String
initialGifKeyword =
    "emotion"
