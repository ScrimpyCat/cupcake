module Session.Inactive.Register.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onWithOptions)
import Session.Inactive.Register.Types exposing (..)
import Json.Decode


render : Model -> Html Msg
render model =
    case model of
        Empty ->
            div [] [ button [ onClick PromptDetails ] [ text "Sign Up" ] ]

        Account { email, password, name, mobile } ->
            div
                [ id "modal"
                , onWithOptions "click"
                    Html.Events.defaultOptions
                    (Json.Decode.andThen
                        (\id ->
                            case id of
                                "modal" ->
                                    Json.Decode.succeed DismissDetails

                                _ ->
                                    Json.Decode.fail ""
                        )
                        (Json.Decode.at [ "target", "id" ] Json.Decode.string)
                    )
                ]
                [ input [ type_ "text", placeholder "Email", onInput Email, value email ] []
                , input [ type_ "password", placeholder "Password", onInput Password, value password ] []
                , input [ type_ "text", placeholder "Full Name", onInput Name, value name ] []
                , input [ type_ "text", placeholder "Mobile", onInput Mobile, value mobile ] []
                , button [ onClick CreateAccount ] [ text "Sign Up" ]
                ]
