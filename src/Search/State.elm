module Search.State exposing (init, update, subscriptions)

import Search.Types exposing (..)
import Filter exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Model Nothing []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Query query ->
            ( { model | query = Just query }, Cmd.none )

        Select filter ->
            ( { model | query = Nothing, suggestions = [] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
