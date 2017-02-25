module Session.Active.Logout.State exposing (init, update, subscriptions)

import Session.Active.Logout.Types exposing (..)
import Session.Active.Types exposing (Session)
import Http
import Json.Decode


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> Session -> ( Model, Cmd Msg )
update msg model session =
    case msg of
        Logout ->
            ( model, logoutAccount session )

        _ ->
            ( model, Cmd.none )


logoutAccount : String -> Cmd Msg
logoutAccount session =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    ]
                , url = "http://localhost:4000?variables={\"session\":\"" ++ session ++ "\"}"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        mutation logout($session: String!) {
                            logoutUser(session: { token: $session }) { token }
                        }
                        """
                , expect = Http.expectJson decodeSession
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send RevokeSession request


decodeSession : Json.Decode.Decoder String
decodeSession =
    Json.Decode.at [ "data", "logoutUser", "token" ] (Json.Decode.null "")


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
