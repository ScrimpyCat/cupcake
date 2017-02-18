module Session.Active.State exposing (..)

import Session.Active.Types exposing (..)
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        effects =
            Cmd.batch
                []
    in
        ( { session = "" }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewSession session ->
            ( { model | session = session }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []
