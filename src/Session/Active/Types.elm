module Session.Active.Types exposing (..)


type alias Model =
    { session : String
    }


type Msg
    = NewSession String
