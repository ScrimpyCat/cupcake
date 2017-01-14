module Util exposing (..)

{-| Common utilities that may be useful throughout the application.
-}


{-| Forward a message with state and operate on it. This is used to conveniently
link messages together.

    forward DoStuff update ( model, effects )

Forward functions can also be chained like so:

    ( model, effects )
    |> forward DoStuff update
    |> forward MoreStuff update
-}
forward : msg -> (msg -> model -> ( model, Cmd effectMsg )) -> ( model, Cmd effectMsg ) -> ( model, Cmd effectMsg )
forward msg forwarder ( currentModel, currentEffects ) =
    let
        ( model, newEffects ) =
            forwarder msg currentModel

        effects =
            Cmd.batch
                [ currentEffects
                , newEffects
                ]
    in
        ( model, effects )
