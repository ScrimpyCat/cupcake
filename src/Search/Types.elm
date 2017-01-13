module Search.Types exposing (..)

import Search.Finder.Types as Finder
import Search.Criteria.Types as Criteria


type alias Model =
    { finder : Finder.Model
    , criteria : Criteria.Model
    }


type Msg
    = Finder Finder.Msg
    | Criteria Criteria.Msg
