module Search.Types exposing (..)

import Filter exposing (..)


type Model
    = Empty
    | Autocomplete String (Maybe (List Filter))


type Msg
    = Query String
    | Select Filter
