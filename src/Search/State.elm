module Search.State exposing (init, update, subscriptions)

import Search.Types exposing (..)
import Filter exposing (..)
import Http
import Json.Decode
import Time
import Regex


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Query "" ->
            ( Empty, Cmd.none )

        Query query ->
            case model of
                Empty ->
                    ( Autocomplete query Nothing, getSuggestions query )

                Autocomplete _ suggestions ->
                    {- Possibly pass the old suggestions state to the request
                       to the server query. So it can either apply temporary
                       filtering to the previous results while waiting for
                       new results to come in. Or possibly just remove it
                       entirely, in which case this case statement could be
                       replaced with the same result.
                    -}
                    ( Autocomplete query Nothing, getSuggestions query )

        Select filter ->
            ( Empty, Cmd.none )

        NewSuggestions (Ok suggestions) ->
            case model of
                Autocomplete query _ ->
                    let
                        filters =
                            List.concat
                                [ [ (Filter Name query) ]
                                , List.map (\name -> Filter Ingredient name) suggestions.ingredients
                                , List.map (\name -> Filter Cuisine name) suggestions.cuisines
                                , List.map (\name -> Filter Allergen name) suggestions.allergens
                                , List.map (\name -> Filter Diet name) suggestions.diets
                                , List.map (\name -> Filter RegionalStyle name) suggestions.regionalStyles
                                , List.map (\name -> Filter Price name) (getPrices query)
                                ]
                    in
                        ( Autocomplete query (Just filters), Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewSuggestions (Err r) ->
            ( model, Cmd.none )


currencySymbols : List String
currencySymbols =
    [ "$"
    ]


getPrices : String -> List String
getPrices query =
    --TODO: Fix regex to be less greedy
    let
        prices =
            Regex.find (Regex.AtMost 2) (Regex.regex ("(?![" ++ (List.foldr (++) "" currencySymbols) ++ "])\\d+\\.?\\d*")) query

        ranges =
            case prices of
                [ a, b ] ->
                    [ a.match ++ " - " ++ b.match ]

                [ { match } ] ->
                    let
                        base =
                            case String.toFloat match of
                                Ok value ->
                                    truncate value

                                Err _ ->
                                    0
                    in
                        --TODO: Don't do subtractions if base will be below 0
                        [ match
                        , "0 - " ++ match
                        , (toString (base - 20)) ++ " - " ++ match
                        , (toString (base - 10)) ++ " - " ++ match
                        , match ++ " - " ++ (toString (base + 10))
                        , match ++ " - " ++ (toString (base + 20))
                        ]

                _ ->
                    []
    in
        ranges


getSuggestions : String -> Cmd Msg
getSuggestions query =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    ]
                , url = "http://localhost:4000?variables={\"term\":\"" ++ query ++ "\"}"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        query suggestions($term: String!) {
                            ingredients(name: $term) { name }
                            cuisines(name: $term) { name }
                            allergens(name: $term) { name }
                            diets(name: $term) { name }
                            regions(find: $term) { style }
                        }
                        """
                , expect = Http.expectJson decodeSuggestions
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send NewSuggestions request


decodeSuggestions : Json.Decode.Decoder FilterSuggestions
decodeSuggestions =
    let
        fields =
            Json.Decode.map5
                (\ingredients cuisines allergens diets regionalStyles ->
                    { ingredients = ingredients
                    , cuisines = cuisines
                    , allergens = allergens
                    , diets = diets
                    , regionalStyles = regionalStyles
                    }
                )
                (Json.Decode.field "ingredients" (Json.Decode.list (Json.Decode.field "name" Json.Decode.string)))
                (Json.Decode.field "cuisines" (Json.Decode.list (Json.Decode.field "name" Json.Decode.string)))
                (Json.Decode.field "allergens" (Json.Decode.list (Json.Decode.field "name" Json.Decode.string)))
                (Json.Decode.field "diets" (Json.Decode.list (Json.Decode.field "name" Json.Decode.string)))
                (Json.Decode.field "regions" (Json.Decode.list (Json.Decode.field "style" Json.Decode.string)))
    in
        Json.Decode.field "data" fields


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
