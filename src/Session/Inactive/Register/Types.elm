module Session.Inactive.Register.Types exposing (..)

import Http


type alias Info =
    { email : String
    , password : String
    , name : String
    , mobile : String
    }


type Model
    = Empty
    | Account Info


type Msg
    = PromptDetails
    | DismissDetails
    | CreateAccount
    | Email String
    | Password String
    | Name String
    | Mobile String
    | NewSession (Result Http.Error String)
