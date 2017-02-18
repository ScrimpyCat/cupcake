module Session.View exposing (..)

import Html exposing (..)
import Session.Types exposing (..)
import Session.Active.View as Active
import Session.Inactive.View as Inactive


render : Model -> Html Msg
render model =
    case model of
        ActiveSession activeModel ->
            div [] [ map (\msg -> Active msg) (Active.render activeModel) ]

        InactiveSession inactiveModel ->
            div [] [ map (\msg -> Inactive msg) (Inactive.render inactiveModel) ]
