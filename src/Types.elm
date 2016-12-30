module Types exposing (..)

import Search.Types as Search


type alias Model =
    { search : Search.Model
    }


type Msg
    = Search Search.Msg
