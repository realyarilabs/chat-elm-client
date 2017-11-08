module App.Data exposing (..)

{-| -}

import App.MessagesTypes as MessagesTypes exposing (..)
import App.Types as ATypes exposing (..)
import Json.Decode as JD exposing (Decoder, field, int, map, oneOf, string)
import Json.Decode.Pipeline as JDP exposing (decode, hardcoded, optional, required)
import Json.Encode as JE exposing (object, string)


-- decoders for MessageData


partDecoder : JD.Decoder Part
partDecoder =
    let
        bodyDec =
            JDP.decode BodyPart
                |> required "mime_type" JD.string
                |> required "body" JD.string

        mediaPayloadDec =
            JDP.decode MediaPayload
                |> required "url" JD.string
                |> required "size" JD.int
                |> required "expiration" JD.string

        mediaDec =
            JDP.decode MediaPart
                |> required "mime_type" JD.string
                |> required "content" mediaPayloadDec
    in
        JD.oneOf
            [ JD.map Body bodyDec
            , JD.map Media mediaDec
            , JD.map BadPayload JD.value
            ]


messageDataDecoder : JD.Decoder MessageData
messageDataDecoder =
    JDP.decode MessageData
        |> required "id" JD.string
        |> required "chat_id" JD.string
        |> required "parts" (JD.list partDecoder)
        |> required "user_id" JD.string
        |> required "inserted_at" JD.string
        |> required "updated_at" JD.string



--  Decoders User Data


userDataDecoder : JD.Decoder UserData
userDataDecoder =
    JDP.decode UserData
        |> required "user_id" JD.string
        |> required "avatar" JD.string
        |> required "display_name" JD.string
        |> required "status" JD.string
        |> required "user_type" JD.string


userParams : JE.Value
userParams =
    JE.object [ ( "user_id", JE.string "123" ) ]



-- Helpers for decode


decode : Decoder a -> JE.Value -> Result String a
decode =
    JD.decodeValue
