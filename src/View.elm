module View exposing (..)

import Html exposing (..)
import Types exposing (..)
import Search.View as Search


render : Model -> Html Msg
render model =
    div [] [ map (\msg -> Search msg) (Search.render model.search) ]
