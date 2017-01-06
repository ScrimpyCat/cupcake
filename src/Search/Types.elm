module Search.Types exposing (..)

import Filter exposing (..)
import Http


type Model
    = Empty
    | Autocomplete String (Maybe (List Filter))


type alias FilterSuggestions =
    { ingredients : List String
    , cuisines : List String
    , allergens : List String
    , diets : List String
    , regionalStyles : List String
    }


type Msg
    = Query String
    | Select Filter
    | NewSuggestions (Result Http.Error FilterSuggestions)
