module Search.State exposing (init, update, subscriptions)

import Search.Types exposing (..)
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
        Query query ->
            case model of
                Empty ->
                    ( Autocomplete query Nothing, Cmd.none )

                Autocomplete _ suggestions ->
                    {- Possibly pass the old suggestions state to the request
                       to the server query. So it can either apply temporary
                       filtering to the previous results while waiting for
                       new results to come in. Or possibly just remove it
                       entirely, in which case this case statement could be
                       replaced with the same result.
                    -}
                    ( Autocomplete query Nothing, Cmd.none )

        Select filter ->
            ( Empty, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
