module State exposing (..)

import Types exposing (..)
import Search.State as Search


init : ( Model, Cmd Msg )
init =
    let
        ( searchModel, searchEffects ) =
            Search.init

        effects =
            Cmd.batch
                [ Cmd.map Search searchEffects
                ]
    in
        ( { search = searchModel
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Search (Search.subscriptions model.search)
        ]
