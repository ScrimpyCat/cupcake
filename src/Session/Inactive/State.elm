module Session.Inactive.State exposing (..)

import Session.Inactive.Types exposing (..)
import Session.Inactive.Login.State as Login
import Session.Inactive.Register.State as Register
import Session.Inactive.Login.Types
import Session.Inactive.Register.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( loginModel, loginEffects ) =
            Login.init

        ( registerModel, registerEffects ) =
            Register.init

        effects =
            Cmd.batch
                [ Cmd.map Login loginEffects
                , Cmd.map Register registerEffects
                ]
    in
        ( { login = loginModel
          , register = registerModel
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

        Register registerMsg ->
            let
                ( registerModel, registerEffects ) =
                    Register.update registerMsg model.register
            in
                ( { model | register = registerModel }, (Cmd.map Register registerEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Login (Login.subscriptions model.login)
        , Sub.map Register (Register.subscriptions model.register)
        ]
