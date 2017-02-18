module Session.Inactive.Login.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onWithOptions)
import Session.Inactive.Login.Types exposing (..)
import Json.Decode


render : Model -> Html Msg
render model =
    case model of
        Empty ->
            div [] [ button [ onClick PromptCredentials ] [ text "Sign In" ] ]

        Credentials email password ->
            div
                [ id "modal"
                , onWithOptions "click"
                    Html.Events.defaultOptions
                    (Json.Decode.andThen
                        (\id ->
                            case id of
                                "modal" ->
                                    Json.Decode.succeed DismissCredentials

                                _ ->
                                    Json.Decode.fail ""
                        )
                        (Json.Decode.at [ "target", "id" ] Json.Decode.string)
                    )
                ]
                [ input [ type_ "text", placeholder "Email", onInput Email, value email ] []
                , input [ type_ "password", placeholder "Password", onInput Password, value password ] []
                , button [ onClick AuthenticateCredentials ] [ text "Sign In" ]
                ]
