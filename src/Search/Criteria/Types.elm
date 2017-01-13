module Search.Criteria.Types exposing (..)

import Search.Filter exposing (..)


type Criteria
    = Criteria Filter Bool


type Model
    = Empty
    | FilteringCriteria (List Criteria)


type Msg
    = Add Filter
    | Toggle Filter
    | Remove Filter
