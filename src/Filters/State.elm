module Filters.State exposing (init, update, subscriptions)

import Filters.Types exposing (..)
import Filter exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add filter ->
            case model of
                Empty ->
                    ( FilteringCriteria [ Criteria filter True ], Cmd.none )

                FilteringCriteria filters ->
                    ( FilteringCriteria ((Criteria filter True) :: filters), Cmd.none )

        Toggle filter ->
            case model of
                Empty ->
                    ( Empty, Cmd.none )

                FilteringCriteria filters ->
                    ( FilteringCriteria
                        (List.map
                            (\(Criteria currentFilter active) ->
                                if currentFilter == filter then
                                    (Criteria currentFilter (not active))
                                else
                                    (Criteria currentFilter active)
                            )
                            filters
                        )
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
