module Filter exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient
    | Price
    | RegionalStyle


type Filter
    = Filter Category String
