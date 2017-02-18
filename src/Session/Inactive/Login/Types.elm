module Session.Inactive.Login.Types exposing (..)

import Http


type Model
    = Empty
    | Credentials String String


type Msg
    = PromptCredentials
    | DismissCredentials
    | AuthenticateCredentials
    | Email String
    | Password String
    | NewSession (Result Http.Error String)
