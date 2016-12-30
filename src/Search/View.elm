module Search.View exposing (render)

import Html exposing (..)
import Types exposing (..)


render : Model -> Html Msg
render model =
    div []
        [ input [ type_ "text", placeholder "Find some food!", onInput Query ] []
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
                            [ dt [] [ text query ], dd [] [ text (toString category) ] ]
                )
                suggestions
    in
        dl [] items
