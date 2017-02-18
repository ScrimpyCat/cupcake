module Session.Types exposing (..)

import Session.Active.Types as Active
import Session.Inactive.Types as Inactive


type Model
    = InactiveSession Inactive.Model
    | ActiveSession Active.Model


type Msg
    = Active Active.Msg
    | Inactive Inactive.Msg
