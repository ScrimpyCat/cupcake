module Search.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Search.Types exposing (..)


render : Model -> Html Msg
render model =
    div []
        [ input [ type_ "text", placeholder "Find some food!", onInput Query, value model.query ] []
        , viewSuggestions model.suggestions
        ]


viewSuggestions : List Filter -> Html Msg
viewSuggestions suggestions =
    let
        items =
            List.concatMap
                (\filter ->
                    case filter of
                        Filter category query ->
                            [ dt [ onClick (Select filter) ] [ text query ], dd [ onClick (Select filter) ] [ text (toString category) ] ]
                )
                suggestions
    in
        dl [] items
