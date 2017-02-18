module Session.Inactive.Register.State exposing (init, update, subscriptions)

import Session.Inactive.Register.Types exposing (..)
import Http
import Json.Decode


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
            case model of
                Empty ->
                    ( model, Cmd.none )

                Account info ->
                    ( model, createAccount info )

        NewSession session ->
            case session of
                Ok token ->
                    ( Empty, Cmd.none )

                Err _ ->
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


formatMobile : String -> String
formatMobile mobile =
    {- TODO: Determine if mobile is local number of international.
       If it is international, replace the '+' symbol with %2b, otherwise
       if it is local, work out the country prefix to add.
    -}
    "%2b" ++ mobile


createAccount : Info -> Cmd Msg
createAccount { email, password, name, mobile } =
    -- TODO: Convert to using elm-graphql once the library support 0.18
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ (Http.header "Accept" "application/json")
                    ]
                , url = "http://localhost:4000?variables={\"email\":\"" ++ email ++ "\",\"password\":\"" ++ password ++ "\",\"name\":\"" ++ name ++ "\",\"mobile\":\"" ++ (formatMobile mobile) ++ "\"}"
                , body =
                    Http.stringBody "application/graphql"
                        """
                        mutation register($email: String!, $password: String!, $name: String!, $mobile: String!) {
                            registerUser(email: $email, password: $password, name: $name, mobile: $mobile) { token }
                        }
                        """
                , expect = Http.expectJson decodeSession
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send NewSession request


decodeSession : Json.Decode.Decoder String
decodeSession =
    Json.Decode.at [ "data", "registerUser", "token" ] Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
