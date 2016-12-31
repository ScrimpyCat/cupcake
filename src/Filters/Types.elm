module Filters.Types exposing (..)

import Filter exposing (..)


type alias Model =
    { filters : List Filter
    }


type Msg
    = Add Filter
