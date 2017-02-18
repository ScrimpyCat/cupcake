module Session.Inactive.View exposing (..)

import Html exposing (..)
import Session.Inactive.Types exposing (..)
import Session.Inactive.Login.View as Login
import Session.Inactive.Register.View as Register


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Login msg) (Login.render model.login)
        , map (\msg -> Register msg) (Register.render model.register)
        ]
