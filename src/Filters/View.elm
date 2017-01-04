module Filters.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Filters.Types exposing (..)
import Filter exposing (..)


render : Model -> Html Msg
render model =
    case model.filters of
        Nothing ->
            div []
                [ viewFilters []
                ]

        Just filters ->
            div []
                [ viewFilters filters
                ]


viewFilters : List Filter -> Html Msg
viewFilters filters =
    let
        items =
            List.concatMap
                (\filter ->
                    case filter of
                        Filter category query ->
                            [ dt [] [ text query ], dd [] [ text (toString category) ] ]
                )
                filters
    in
        dl [] items
