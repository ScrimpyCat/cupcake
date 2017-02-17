module Session.Inactive.State exposing (..)

import Session.Inactive.Types exposing (..)
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        effects =
            Cmd.batch
                []
    in
        ( {}
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []
