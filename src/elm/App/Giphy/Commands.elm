module App.Giphy.Commands exposing (..)

import App.Giphy.Utils exposing (..)
import App.Types exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Encode as JE
import Platform.Cmd
import Regex
import Task exposing (perform, succeed)


giphyID_decoder =
    string
        |> at [ "data", "id" ]


searchGIF : Int -> (Result Http.Error (List String) -> Msg) -> String -> Cmd Msg
searchGIF n msg query =
    let
        decoder =
            field "data" (list (field "id" string))

        url =
            "https://api.giphy.com/v1/gifs/search?api_key=" ++ apiKey ++ "&limit=" ++ toString n ++ "&q="

        apiQuery =
            query
                |> Http.encodeUri
                |> String.append url
    in
        Http.get apiQuery decoder
            |> Http.send msg


randomGif : Int -> (Result Http.Error String -> Msg) -> Cmd Msg
randomGif n msg =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=" ++ apiKey

        cmd =
            Http.get url giphyID_decoder
                |> Http.send msg
    in
        cmd
            |> List.repeat n
            |> Cmd.batch


translateGif : (Result Http.Error String -> Msg) -> String -> Cmd Msg
translateGif msg query =
    let
        url =
            "https://api.giphy.com/v1/gifs/translate?api_key=" ++ apiKey ++ "&s="

        apiQuery =
            query
                |> Http.encodeUri
                |> String.append url
    in
        Http.get apiQuery giphyID_decoder
            |> Http.send msg
