module Session.Active.Profile.Types exposing (..)

import Http


type Model
    = Empty
    | User String


type Msg
    = Edit
    | UserDetails (Result Http.Error String)
    | GetDetails
