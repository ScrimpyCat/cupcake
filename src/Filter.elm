module Filter exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient
    | Name
    | Price
    | RegionalStyle


type Filter
    = Filter Category String
