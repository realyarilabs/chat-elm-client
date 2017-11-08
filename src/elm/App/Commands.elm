module App.Commands exposing (..)

import Task exposing (perform, succeed, andThen, sequence)
import Process exposing (sleep)
import Time exposing (second)


send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity


{-| Sleep X seconds and send a Cmd msg
-}
sleepAndSend : Float -> a -> Task.Task x () -> Cmd a
sleepAndSend howManySecs msg task =
    [ Process.sleep (second * howManySecs)
    , task
    ]
        |> Task.sequence
        |> Task.attempt (always msg)
