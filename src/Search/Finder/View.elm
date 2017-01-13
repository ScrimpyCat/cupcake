module Search.Finder.View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Search.Finder.Types exposing (..)
import Search.Filter exposing (..)


render : Model -> Html Msg
render model =
    case model of
        Empty ->
            div []
                [ viewSearchBar ""
                , viewSuggestions []
                ]

        Autocomplete query Nothing ->
            div []
                [ viewSearchBar query
                , viewSuggestions []
                ]

        Autocomplete query (Just suggestions) ->
            div []
                [ viewSearchBar query
                , viewSuggestions suggestions
                ]


viewSearchBar : String -> Html Msg
viewSearchBar term =
    input [ type_ "text", placeholder "Find some food!", onInput Query, value term ] []


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
