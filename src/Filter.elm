module Filter exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient


type Filter
    = Filter Category String
