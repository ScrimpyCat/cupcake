module Search.Criteria.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Search.Criteria.Types exposing (..)
import Search.Filter exposing (..)


render : Model -> Html Msg
render model =
    case model of
        Empty ->
            div []
                [ viewFilters []
                ]

        FilteringCriteria filters ->
            div []
                [ viewFilters filters
                ]


viewFilters : List Criteria -> Html Msg
viewFilters filters =
    let
        items =
            List.concatMap
                (\(Criteria filter active) ->
                    case filter of
                        Filter category ( query, _ ) ->
                            [ dt [ onClick (Toggle filter) ] [ text query, button [ onClick (Remove filter) ] [ text "Remove" ] ], dd [ onClick (Toggle filter) ] [ text (toString category) ] ]
                )
                filters
    in
        dl [] items
