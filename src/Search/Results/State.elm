module Search.Results.State exposing (init, update, subscriptions)

import Search.Results.Types exposing (..)
import Search.Criteria.Types as Criteria


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Find criteria ->
            case criteria of
                Criteria.Empty ->
                    ( Empty, Cmd.none )

                Criteria.FilteringCriteria filters ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
