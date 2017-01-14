module Search.State exposing (..)

import Search.Types exposing (..)
import Search.Finder.State as Finder
import Search.Criteria.State as Criteria
import Search.Results.State as Results
import Search.Finder.Types
import Search.Criteria.Types
import Search.Results.Types
import Util exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        ( finderModel, finderEffects ) =
            Finder.init

        ( criteriaModel, criteriaEffects ) =
            Criteria.init

        ( resultsModel, resultsEffects ) =
            Results.init

        effects =
            Cmd.batch
                [ Cmd.map Finder finderEffects
                , Cmd.map Criteria criteriaEffects
                , Cmd.map Results resultsEffects
                ]
    in
        ( { finder = finderModel
          , criteria = criteriaModel
          , results = resultsModel
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
            in
                ( { model | finder = finderModel }, (Cmd.map Finder finderEffects) )
                    |> forward finderMsg
                        (\msg model ->
                            case msg of
                                Search.Finder.Types.Select filter ->
                                    update (Criteria (Search.Criteria.Types.Add filter)) model

                                _ ->
                                    ( model, Cmd.none )
                        )

        Criteria criteriaMsg ->
            let
                ( criteriaModel, criteriaEffects ) =
                    Criteria.update criteriaMsg model.criteria
            in
                ( { model | criteria = criteriaModel }, Cmd.map Criteria criteriaEffects )
                    |> forward (Results (Search.Results.Types.Find criteriaModel)) update

        Results resultsMsg ->
            let
                ( resultsModel, resultsEffects ) =
                    Results.update resultsMsg model.results
            in
                ( { model | results = resultsModel }, (Cmd.map Results resultsEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Finder (Finder.subscriptions model.finder)
        , Sub.map Criteria (Criteria.subscriptions model.criteria)
        , Sub.map Results (Results.subscriptions model.results)
        ]
