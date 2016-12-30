module Main exposing (main)

import Html
import Types exposing (..)
import State
import View


main : Program Never Model Msg
main =
    Html.program
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.render
        }
