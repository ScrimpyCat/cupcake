module Session.Active.State exposing (..)

import Session.Active.Types exposing (..)
import Session.Active.Logout.State as Logout
import Session.Active.Logout.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( logoutModel, logoutEffects ) =
            Logout.init

        effects =
            Cmd.batch
                [ Cmd.map Logout logoutEffects
                ]
    in
        ( { session = ""
          , logout = logoutModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewSession session ->
            ( { model | session = session }, Cmd.none )

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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Logout (Logout.subscriptions model.logout)
        ]
