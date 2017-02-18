module Session.Inactive.Types exposing (..)

import Session.Inactive.Login.Types as Login


type alias Model =
    { login : Login.Model
    }


type Msg
    = Login Login.Msg
