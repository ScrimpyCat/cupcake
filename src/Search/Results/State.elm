module Search.Results.State exposing (init, update, subscriptions)

import Search.Results.Types exposing (..)
import Search.Filter exposing (..)
import Search.Criteria.Types as Criteria
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
        Find criteria ->
            case criteria of
                Criteria.Empty ->
                    ( Empty, Cmd.none )

                Criteria.FilteringCriteria filters ->
                    let
                        activeFilters =
                            List.filterMap
                                (\(Criteria.Criteria filter active) ->
                                    case active of
                                        True ->
                                            Just filter

                                        False ->
                                            Nothing
                                )
                                filters
                    in
                        ( model, getResults activeFilters )

        NewResults response ->
            let
                x =
                    Debug.log "results: "
                        (case response of
                            Ok r ->
                                r

                            Err _ ->
                                [ FoodItem "" ]
                        )
            in
                ( model, Cmd.none )


convertTermToVariable : String -> String -> String
convertTermToVariable var term =
    case term of
        "" ->
            ""

        _ ->
            var ++ ":" ++ term


convertTermsToVariable : String -> List String -> String
convertTermsToVariable var terms =
    case terms of
        [] ->
            ""

        _ ->
            var ++ ":[" ++ (String.join "," terms) ++ "]"


formatNameField : List String -> List String
formatNameField terms =
    List.map (\term -> "{\"name\":" ++ term ++ "}") terms


convertFiltersToVariables : List Filter -> String
convertFiltersToVariables filters =
    let
        ( allergens, cuisines, diets, ingredients, name, prices, regionalStyles ) =
            List.foldl
                (\(Filter category phrase) ( allergens, cuisines, diets, ingredients, name, prices, regionalStyles ) ->
                    let
                        term =
                            "\"" ++ phrase ++ "\""
                    in
                        case category of
                            Allergen ->
                                ( term :: allergens, cuisines, diets, ingredients, name, prices, regionalStyles )

                            Cuisine ->
                                ( allergens, term :: cuisines, diets, ingredients, name, prices, regionalStyles )

                            Diet ->
                                ( allergens, cuisines, term :: diets, ingredients, name, prices, regionalStyles )

                            Ingredient ->
                                ( allergens, cuisines, diets, term :: ingredients, name, prices, regionalStyles )

                            Name ->
                                ( allergens, cuisines, diets, ingredients, term, prices, regionalStyles )

                            Price ->
                                ( allergens, cuisines, diets, ingredients, name, term :: prices, regionalStyles )

                            RegionalStyle ->
                                ( allergens, cuisines, diets, ingredients, name, prices, term :: regionalStyles )
                )
                ( [], [], [], [], "", [], [] )
                filters
    in
        --TODO: format price and region fields
        String.join ","
            (List.filter (\argument -> (String.length argument) > 0)
                [ (convertTermsToVariable "\"allergens\"" (formatNameField allergens))
                , (convertTermsToVariable "\"cuisines\"" (formatNameField cuisines))
                , (convertTermsToVariable "\"diets\"" (formatNameField diets))
                , (convertTermsToVariable "\"ingredients\"" (formatNameField ingredients))
                , (convertTermToVariable "\"name\"" name)
                , (convertTermsToVariable "\"prices\"" prices)
                , (convertTermsToVariable "\"regionalStyles\"" regionalStyles)
                ]
            )


getResults : List Filter -> Cmd Msg
getResults filters =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    ]
                , url = "http://localhost:4000?variables={" ++ (convertFiltersToVariables filters) ++ "}"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        query results($allergens: [AllergenInput], $cuisines: [CuisineInput], $diets: [DietInput], $ingredients: [IngredientInput], $name: String) {
                            foods(allergens: $allergens, cuisines: $cuisines, diets: $diets, ingredients: $ingredients, name: $name) { name }
                        }
                        """
                , expect = Http.expectJson decodeResults
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send NewResults request


decodeResults : Json.Decode.Decoder FoodItems
decodeResults =
    let
        fields =
            Json.Decode.map
                (\foods ->
                    List.map (\name -> FoodItem name) foods
                )
                (Json.Decode.field "foods" (Json.Decode.list (Json.Decode.field "name" Json.Decode.string)))
    in
        Json.Decode.field "data" fields


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
