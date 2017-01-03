module Search.Types exposing (..)

import Filter exposing (..)


type alias Model =
    { query : Maybe String
    , suggestions : List Filter
    }


type Msg
    = Query String
    | Select Filter
