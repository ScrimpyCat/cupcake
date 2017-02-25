module Session.Active.Logout.Types exposing (..)

import Http


type Model
    = Empty


type Msg
    = Logout
    | RevokeSession (Result Http.Error String)
