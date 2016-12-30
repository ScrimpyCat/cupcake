module Search.Types exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient


type Filter
    = Filter Category String


type alias Model =
    { query : String
    , suggestions : List Filter
    }


type Msg
    = Query String
