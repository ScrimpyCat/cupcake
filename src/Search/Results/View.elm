module Search.Results.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Search.Results.Types exposing (..)


render : Model -> Html Msg
render model =
    case model of
        Empty ->
            div []
                []

        Results items ->
            div []
                [ viewFoodItems items
                ]


viewFoodItems : List FoodItem -> Html Msg
viewFoodItems foods =
    let
        items =
            List.map
                (\(FoodItem name) ->
                    li [] [ text name ]
                )
                foods
    in
        ol [] items
