module State exposing (..)

import Types exposing (..)
import Search.State as Search
import Session.State as Session


init : ( Model, Cmd Msg )
init =
    let
        ( searchModel, searchEffects ) =
            Search.init

        ( sessionModel, sessionEffects ) =
            Session.init

        effects =
            Cmd.batch
                [ Cmd.map Search searchEffects
                , Cmd.map Session sessionEffects
                ]
    in
        ( { search = searchModel
          , session = sessionModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search searchMsg ->
            let
                ( searchModel, searchEffects ) =
                    Search.update searchMsg model.search
            in
                ( { model | search = searchModel }, (Cmd.map Search searchEffects) )

        Session sessionMsg ->
            let
                ( sessionModel, sessionEffects ) =
                    Session.update sessionMsg model.session
            in
                ( { model | session = sessionModel }, (Cmd.map Session sessionEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Search (Search.subscriptions model.search)
        , Sub.map Session (Session.subscriptions model.session)
        ]
