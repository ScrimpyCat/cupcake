module Search.Filter exposing (..)


type Category
    = Allergen
    | Cuisine
    | Diet
    | Ingredient
    | Name
    | Price
    | RegionalStyle


type alias ID =
    String


type Filter
    = Filter Category ( String, Maybe ID )
