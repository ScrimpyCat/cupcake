module Types exposing (..)

import Search.Types as Search
import Session.Types as Session


type alias Model =
    { search : Search.Model
    , session : Session.Model
    }


type Msg
    = Search Search.Msg
    | Session Session.Msg
