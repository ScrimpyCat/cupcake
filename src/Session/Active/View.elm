module Session.Active.View exposing (..)

import Html exposing (..)
import Session.Active.Types exposing (..)
import Session.Active.Logout.View as Logout


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Logout msg) (Logout.render model.logout model.session)
        ]
