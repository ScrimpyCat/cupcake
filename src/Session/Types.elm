module Session.Types exposing (..)

import Session.Active.Types as Active
import Session.Inactive.Types as Inactive


type alias Model =
    { active : Active.Model
    , inactive : Inactive.Model
    }


type Msg
    = Active Active.Msg
    | Inactive Inactive.Msg
