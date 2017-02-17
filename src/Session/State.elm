module Session.State exposing (..)

import Session.Types exposing (..)
import Session.Active.State as Active
import Session.Inactive.State as Inactive
import Session.Active.Types
import Session.Inactive.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( activeModel, activeEffects ) =
            Active.init

        ( inactiveModel, inactiveEffects ) =
            Inactive.init

        effects =
            Cmd.batch
                [ Cmd.map Active activeEffects
                , Cmd.map Inactive inactiveEffects
                ]
    in
        ( { active = activeModel
          , inactive = inactiveModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Active activeMsg ->
            let
                ( activeModel, activeEffects ) =
                    Active.update activeMsg model.active
            in
                ( { model | active = activeModel }, (Cmd.map Active activeEffects) )

        Inactive inactiveMsg ->
            let
                ( inactiveModel, inactiveEffects ) =
                    Inactive.update inactiveMsg model.inactive
            in
                ( { model | inactive = inactiveModel }, Cmd.map Inactive inactiveEffects )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Active (Active.subscriptions model.active)
        , Sub.map Inactive (Inactive.subscriptions model.inactive)
        ]
