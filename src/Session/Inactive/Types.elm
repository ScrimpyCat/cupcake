module Session.Inactive.Types exposing (..)

import Session.Inactive.Login.Types as Login
import Session.Inactive.Register.Types as Register


type alias Model =
    { login : Login.Model
    , register : Register.Model
    }


type Msg
    = Login Login.Msg
    | Register Register.Msg
