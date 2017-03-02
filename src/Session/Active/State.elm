module Session.Active.State exposing (..)

import Session.Active.Types exposing (..)
import Session.Active.Logout.State as Logout
import Session.Active.Logout.Types
import Session.Active.Profile.State as Profile
import Session.Active.Profile.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( logoutModel, logoutEffects ) =
            Logout.init

        ( profileModel, profileEffects ) =
            Profile.init

        effects =
            Cmd.batch
                [ Cmd.map Logout logoutEffects
                , Cmd.map Profile profileEffects
                ]
    in
        ( { session = ""
          , logout = logoutModel
          , profile = profileModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewSession session ->
            ( { model | session = session }, Cmd.none )
                |> forward (Profile Session.Active.Profile.Types.GetDetails) update

        Logout logoutMsg ->
            let
                ( logoutModel, logoutEffects ) =
                    Logout.update logoutMsg model.logout model.session
            in
                ( { model | logout = logoutModel }, (Cmd.map Logout logoutEffects) )
                    |> forward logoutMsg
                        (\msg model ->
                            case msg of
                                Session.Active.Logout.Types.RevokeSession (Ok _) ->
                                    ( { model | session = "" }, Cmd.none )

                                _ ->
                                    ( model, Cmd.none )
                        )

        Profile profileMsg ->
            let
                ( profileModel, profileEffects ) =
                    Profile.update (Debug.log ">" profileMsg) model.profile model.session
            in
                ( { model | profile = profileModel }, (Cmd.map Profile profileEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Logout (Logout.subscriptions model.logout)
        , Sub.map Profile (Profile.subscriptions model.profile)
        ]
