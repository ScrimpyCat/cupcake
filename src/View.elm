module View exposing (..)

import Html exposing (..)
import Types exposing (..)
import Search.View as Search
import Session.View as Session


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Search msg) (Search.render model.search)
        , map (\msg -> Session msg) (Session.render model.session)
        ]
