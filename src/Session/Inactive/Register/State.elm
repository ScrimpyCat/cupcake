module Session.Inactive.Register.State exposing (init, update, subscriptions)

import Session.Inactive.Register.Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PromptDetails ->
            ( Account (Info "" "" "" ""), Cmd.none )

        DismissDetails ->
            ( Empty, Cmd.none )

        CreateAccount ->
            ( model, Cmd.none )

        Email email ->
            let
                details =
                    case model of
                        Empty ->
                            Account { email = email, password = "", name = "", mobile = "" }

                        Account info ->
                            (Account { info | email = email })
            in
                ( details, Cmd.none )

        Password password ->
            let
                details =
                    case model of
                        Empty ->
                            Account { password = password, email = "", name = "", mobile = "" }

                        Account info ->
                            (Account { info | password = password })
            in
                ( details, Cmd.none )

        Name name ->
            let
                details =
                    case model of
                        Empty ->
                            Account { name = name, email = "", password = "", mobile = "" }

                        Account info ->
                            (Account { info | name = name })
            in
                ( details, Cmd.none )

        Mobile mobile ->
            let
                details =
                    case model of
                        Empty ->
                            Account { mobile = mobile, email = "", password = "", name = "" }

                        Account info ->
                            (Account { info | mobile = mobile })
            in
                ( details, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
