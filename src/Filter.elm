module Filter exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient
    | RegionalStyle


type Filter
    = Filter Category String
