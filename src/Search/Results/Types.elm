module Search.Results.Types exposing (..)

import Search.Criteria.Types as Criteria
import Http


type Model
    = Empty


type Msg
    = Find Criteria.Model
