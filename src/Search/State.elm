module Search.State exposing (..)

import Search.Types exposing (..)
import Search.Finder.State as Finder
import Search.Criteria.State as Criteria
import Search.Finder.Types
import Search.Criteria.Types


init : ( Model, Cmd Msg )
init =
    let
        ( finderModel, finderEffects ) =
            Finder.init

        ( criteriaModel, criteriaEffects ) =
            Criteria.init

        effects =
            Cmd.batch
                [ Cmd.map Finder finderEffects
                , Cmd.map Criteria criteriaEffects
                ]
    in
        ( { finder = finderModel
          , criteria = criteriaModel
          }
        , effects
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Finder finderMsg ->
            let
                ( finderModel, finderEffects ) =
                    Finder.update finderMsg model.finder

                ( criteriaModel, criteriaEffects ) =
                    case finderMsg of
                        Search.Finder.Types.Select filter ->
                            Criteria.update (Search.Criteria.Types.Add filter) model.criteria

                        _ ->
                            ( model.criteria, Cmd.none )

                effects =
                    Cmd.batch
                        [ Cmd.map Finder finderEffects
                        , Cmd.map Criteria criteriaEffects
                        ]
            in
                ( { model | finder = finderModel, criteria = criteriaModel }, effects )

        Criteria filterMsg ->
            let
                ( criteriaModel, criteriaEffects ) =
                    Criteria.update filterMsg model.criteria
            in
                ( { model | criteria = criteriaModel }, (Cmd.map Criteria criteriaEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Finder (Finder.subscriptions model.finder)
        , Sub.map Criteria (Criteria.subscriptions model.criteria)
        ]
