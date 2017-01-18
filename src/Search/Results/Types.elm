module Search.Results.Types exposing (..)

import Search.Criteria.Types as Criteria
import Http


type Model
    = Empty


type FoodItem
    = FoodItem String


type alias FoodItems =
    List FoodItem


type Msg
    = Find Criteria.Model
    | NewResults (Result Http.Error FoodItems)
