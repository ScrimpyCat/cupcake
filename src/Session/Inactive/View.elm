module Session.Inactive.View exposing (..)

import Html exposing (..)
import Session.Inactive.Types exposing (..)
import Session.Inactive.Login.View as Login


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Login msg) (Login.render model.login)
        ]
