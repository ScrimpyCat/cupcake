module Session.Active.Profile.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Session.Active.Profile.Types exposing (..)
import Session.Active.Types exposing (Session)


render : Model -> Session -> Html Msg
render model _ =
    case model of
        User name ->
            div [] [ button [ onClick Edit ] [ text name ] ]

        Empty ->
            div [] []
