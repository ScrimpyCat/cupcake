module Search.Finder.Types exposing (..)

import Search.Filter exposing (..)
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
