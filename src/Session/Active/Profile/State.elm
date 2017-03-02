module Session.Active.Profile.State exposing (init, update, subscriptions)

import Session.Active.Profile.Types exposing (..)
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
        GetDetails ->
            ( model, getDetails session )

        UserDetails (Ok user) ->
            ( User user, Cmd.none )

        UserDetails (Err _) ->
            -- TODO: workout what to do here
            ( Empty, Cmd.none )

        Edit ->
            ( model, Cmd.none )


getDetails : String -> Cmd Msg
getDetails session =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    , (Http.header "Authorization" ("Bearer " ++ session))
                    ]
                , url = "http://localhost:4000"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        query {
                            user {
                                name
                            }
                        }
                        """
                , expect = Http.expectJson decodeDetails
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send UserDetails request


decodeDetails : Json.Decode.Decoder String
decodeDetails =
    Json.Decode.at [ "data", "user", "name" ] Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
