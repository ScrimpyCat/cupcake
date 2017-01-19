module Search.Results.Types exposing (..)

import Search.Criteria.Types as Criteria
import Http


type Model
    = Empty
    | Results (List FoodItem)


type FoodItem
    = FoodItem String


type Msg
    = Find Criteria.Model
    | NewResults (Result Http.Error (List FoodItem))
