module State exposing (..)

import Types exposing (..)
import Search.State as Search
import Filters.State as Filters
import Search.Types
import Filters.Types


init : ( Model, Cmd Msg )
init =
    let
        ( searchModel, searchEffects ) =
            Search.init

        ( filtersModel, filtersEffects ) =
            Filters.init

        effects =
            Cmd.batch
                [ Cmd.map Search searchEffects
                , Cmd.map Filters filtersEffects
                ]
    in
        ( { search = searchModel
          , filters = filtersModel
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

                ( filtersModel, filtersEffects ) =
                    case searchMsg of
                        Search.Types.Select filter ->
                            Filters.update (Filters.Types.Add filter) model.filters

                        _ ->
                            ( model.filters, Cmd.none )

                effects =
                    Cmd.batch
                        [ Cmd.map Search searchEffects
                        , Cmd.map Filters filtersEffects
                        ]
            in
                ( { model | search = searchModel, filters = filtersModel }, effects )

        Filters filterMsg ->
            let
                ( filtersModel, filtersEffects ) =
                    Filters.update filterMsg model.filters
            in
                ( { model | filters = filtersModel }, (Cmd.map Filters filtersEffects) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Search (Search.subscriptions model.search)
        , Sub.map Filters (Filters.subscriptions model.filters)
        ]
