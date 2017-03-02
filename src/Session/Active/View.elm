module Session.Active.View exposing (..)

import Html exposing (..)
import Session.Active.Types exposing (..)
import Session.Active.Logout.View as Logout
import Session.Active.Profile.View as Profile


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Logout msg) (Logout.render model.logout model.session)
        , map (\msg -> Profile msg) (Profile.render model.profile model.session)
        ]
