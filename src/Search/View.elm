module Search.View exposing (..)

import Html exposing (..)
import Search.Types exposing (..)
import Search.Finder.View as Finder
import Search.Criteria.View as Criteria


render : Model -> Html Msg
render model =
    div []
        [ map (\msg -> Finder msg) (Finder.render model.finder)
        , map (\msg -> Criteria msg) (Criteria.render model.criteria)
        ]
