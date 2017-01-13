module Search.Types exposing (..)

import Search.Finder.Types as Finder
import Search.Criteria.Types as Criteria
import Search.Results.Types as Results


type alias Model =
    { finder : Finder.Model
    , criteria : Criteria.Model
    , results : Results.Model
    }


type Msg
    = Finder Finder.Msg
    | Criteria Criteria.Msg
    | Results Results.Msg
