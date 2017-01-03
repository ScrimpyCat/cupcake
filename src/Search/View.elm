module Search.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Search.Types exposing (..)
import Filter exposing (..)


render : Model -> Html Msg
render model =
    div []
        [ viewSearchBar model.query
        , viewSuggestions model.suggestions
        ]


viewSearchBar : Maybe String -> Html Msg
viewSearchBar query =
    let
        term =
            case model.query of
                Just query ->
                    query

                Nothing ->
                    ""
    in
        input [ type_ "text", placeholder "Find some food!", onInput Query, value term ]


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
