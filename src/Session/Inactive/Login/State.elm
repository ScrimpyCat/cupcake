module Session.Inactive.Login.State exposing (init, update, subscriptions)

import Session.Inactive.Login.Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PromptCredentials ->
            ( (Credentials "" ""), Cmd.none )

        DismissCredentials ->
            ( Empty, Cmd.none )

        AuthenticateCredentials ->
            ( model, Cmd.none )

        Email email ->
            let
                credentials =
                    case model of
                        Empty ->
                            (Credentials email "")

                        Credentials _ password ->
                            (Credentials email password)
            in
                ( credentials, Cmd.none )

        Password password ->
            let
                credentials =
                    case model of
                        Empty ->
                            (Credentials "" password)

                        Credentials email _ ->
                            (Credentials email password)
            in
                ( credentials, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
