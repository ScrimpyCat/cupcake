module Session.Inactive.Login.Types exposing (..)


type Model
    = Empty
    | Credentials String String


type Msg
    = PromptCredentials
    | DismissCredentials
    | AuthenticateCredentials
    | Email String
    | Password String
