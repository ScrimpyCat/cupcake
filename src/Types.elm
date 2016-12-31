module Types exposing (..)

import Search.Types as Search
import Filters.Types as Filters


type alias Model =
    { search : Search.Model
    , filters : Filters.Model
    }


type Msg
    = Search Search.Msg
    | Filters Filters.Msg
