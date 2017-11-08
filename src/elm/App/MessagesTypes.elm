module App.MessagesTypes exposing (..)

import Json.Encode as JE exposing (Value)


type alias BodyPart =
    { mimeType : String
    , body : String
    }


type Part
    = Body BodyPart
    | Media MediaPart
    | BadPayload JE.Value


type alias MediaPart =
    { mimeType : String
    , content : MediaPayload
    }


type alias MediaPayload =
    { url : String
    , size : Int
    , expiration : String
    }


type alias MessageData =
    { id : String
    , chatId : String
    , parts : List Part
    , userId : String
    , insertedAt : String
    , updatedAt : String
    }
