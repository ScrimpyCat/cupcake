module Session.Inactive.State exposing (..)

import Session.Inactive.Types exposing (..)
import Session.Inactive.Login.State as Login
import Session.Inactive.Login.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( loginModel, loginEffects ) =
            Login.init

        effects =
            Cmd.batch
                [ Cmd.map Login loginEffects
                ]
    in
        ( { login = loginModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login loginMsg ->
            let
                ( loginModel, loginEffects ) =
                    Login.update loginMsg model.login
            in
                ( { model | login = loginModel }, (Cmd.map Login loginEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Login (Login.subscriptions model.login)
        ]
