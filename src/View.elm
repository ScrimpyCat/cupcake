module View exposing (..)

import Html exposing (..)
import Types exposing (..)
import Search.View as Search
import Filters.View as Filters


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Search msg) (Search.render model.search)
        , map (\msg -> Filters msg) (Filters.render model.filters)
        ]
