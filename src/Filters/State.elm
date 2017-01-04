module Filters.State exposing (init, update, subscriptions)

import Filters.Types exposing (..)
import Filter exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Model Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add filter ->
            case model.filters of
                Nothing ->
                    ( { model | filters = Just [ filter ] }, Cmd.none )

                Just filters ->
                    ( { model | filters = Just (filter :: filters) }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
