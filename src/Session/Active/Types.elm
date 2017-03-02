module Session.Active.Types exposing (..)

import Session.Active.Logout.Types as Logout
import Session.Active.Profile.Types as Profile


type alias Model =
    { session : String
    , logout : Logout.Model
    , profile : Profile.Model
    }


type alias Session =
    String


type Msg
    = NewSession Session
    | Logout Logout.Msg
    | Profile Profile.Msg
