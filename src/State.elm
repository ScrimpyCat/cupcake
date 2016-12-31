module State exposing (..)

import Types exposing (..)
import Search.State as Search
import Filters.State as Filters


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
            in
                ( { model | search = searchModel }, (Cmd.map Search searchEffects) )

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
