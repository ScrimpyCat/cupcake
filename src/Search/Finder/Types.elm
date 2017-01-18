module Search.Finder.Types exposing (..)

import Search.Filter exposing (..)
import Http


type Model
    = Empty
    | Autocomplete String (Maybe (List Filter))


type alias FilterSuggestions =
    { ingredients : List ( String, Maybe ID )
    , cuisines : List ( String, Maybe ID )
    , allergens : List ( String, Maybe ID )
    , diets : List ( String, Maybe ID )
    , regionalStyles : List ( String, Maybe ID )
    }


type Msg
    = Query String
    | Select Filter
    | NewSuggestions (Result Http.Error FilterSuggestions)
