module Filters.Types exposing (..)

import Filter exposing (..)


type alias Model =
    { filters : Maybe (List Filter)
    }


type Msg
    = Add Filter
