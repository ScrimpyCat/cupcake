module Search.Types exposing (..)

import Filter exposing (..)


type alias Model =
    { query : String
    , suggestions : List Filter
    }


type Msg
    = Query String
    | Select Filter
