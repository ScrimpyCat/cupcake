module Session.Inactive.Login.State exposing (init, update, subscriptions)

import Session.Inactive.Login.Types exposing (..)
import Http
import Json.Decode


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
            case model of
                Empty ->
                    ( model, Cmd.none )

                Credentials email password ->
                    ( model, loginAccount email password )

        NewSession session ->
            case session of
                Ok token ->
                    ( Empty, Cmd.none )

                Err _ ->
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


loginAccount : String -> String -> Cmd Msg
loginAccount email password =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    ]
                , url = "http://localhost:4000?variables={\"email\":\"" ++ email ++ "\",\"password\":\"" ++ password ++ "\"}"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        mutation login($email: String!, $password: String!) {
                            loginUser(email: $email, password: $password) { token }
                        }
                        """
                , expect = Http.expectJson decodeSession
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send NewSession request


decodeSession : Json.Decode.Decoder String
decodeSession =
    Json.Decode.at [ "data", "loginUser", "token" ] Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
