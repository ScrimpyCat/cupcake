module Search.State exposing (init, update, subscriptions)

import Search.Types exposing (..)
import Filter exposing (..)
import Http
import Json.Decode
import Time


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                                [ List.map (\name -> Filter Ingredient name) suggestions.ingredients
                                , List.map (\name -> Filter Cuisine name) suggestions.cuisines
                                , List.map (\name -> Filter Allergen name) suggestions.allergens
                                , List.map (\name -> Filter Diet name) suggestions.diets
                                , List.map (\name -> Filter RegionalStyle name) suggestions.regionalStyles
                                ]
                    in
                        ( Autocomplete query (Just filters), Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewSuggestions (Err r) ->
            ( model, Cmd.none )


getSuggestions : String -> Cmd Msg
getSuggestions query =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept-Language" "en")
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
