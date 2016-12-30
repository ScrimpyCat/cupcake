module Search.State exposing (..)

import Search.Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Model "" []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Query query ->
            ( { model | query = query }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
