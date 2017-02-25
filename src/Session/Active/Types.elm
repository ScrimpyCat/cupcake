module Session.Active.Types exposing (..)

import Session.Active.Logout.Types as Logout


type alias Model =
    { session : String
    , logout : Logout.Model
    }


type alias Session =
    String


type Msg
    = NewSession Session
    | Logout Logout.Msg
