module Session.State exposing (..)

import Session.Types exposing (..)
import Session.Active.State as Active
import Session.Inactive.State as Inactive
import Session.Active.Types
import Session.Inactive.Types
import Session.Inactive.Login.Types
import Session.Inactive.Register.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( inactiveModel, inactiveEffects ) =
            Inactive.init

        effects =
            Cmd.map Inactive inactiveEffects
    in
        ( (InactiveSession inactiveModel), effects )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Active activeMsg ->
            let
                ( activeModel, activeEffects ) =
                    case model of
                        ActiveSession activeModel ->
                            Active.update activeMsg activeModel

                        InactiveSession _ ->
                            let
                                ( activeModel, _ ) =
                                    Active.init
                            in
                                Active.update activeMsg activeModel
            in
                ( (ActiveSession activeModel), (Cmd.map Active activeEffects) )

        Inactive inactiveMsg ->
            let
                ( inactiveModel, inactiveEffects ) =
                    case model of
                        ActiveSession _ ->
                            let
                                ( inactiveModel, _ ) =
                                    Inactive.init
                            in
                                Inactive.update inactiveMsg inactiveModel

                        InactiveSession inactiveModel ->
                            Inactive.update inactiveMsg inactiveModel
            in
                ( (InactiveSession inactiveModel), (Cmd.map Inactive inactiveEffects) )
                    |> forward inactiveMsg
                        (\msg model ->
                            case msg of
                                Session.Inactive.Types.Login (Session.Inactive.Login.Types.NewSession (Ok token)) ->
                                    update (Active (Session.Active.Types.NewSession token)) model

                                Session.Inactive.Types.Register (Session.Inactive.Register.Types.NewSession (Ok token)) ->
                                    update (Active (Session.Active.Types.NewSession token)) model

                                _ ->
                                    ( model, Cmd.none )
                        )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        ActiveSession activeModel ->
            Sub.map Active (Active.subscriptions activeModel)

        InactiveSession inactiveModel ->
            Sub.map Inactive (Inactive.subscriptions inactiveModel)
