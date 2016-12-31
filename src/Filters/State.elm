module Filters.State exposing (init, update, subscriptions)

import Filters.Types exposing (..)
import Filter exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Model []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add filter ->
            ( { model | filters = filter :: model.filters }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
