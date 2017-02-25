module Session.Active.Logout.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Session.Active.Logout.Types exposing (..)
import Session.Active.Types exposing (Session)


render : Model -> Session -> Html Msg
render model session =
    div [] [ button [ onClick Logout ] [ text "Sign out" ] ]
