module Main exposing (main)

import Browser
import Http
import Html exposing (Html, button, text)
import Html.Events exposing (onClick)

type alias Model = Maybe String

type Msg
    = ClickedAskToServer
    | GotServerResponde (Result Http.Error String)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ClickedAskToServer ->
            (Just "Asking to server...", askToServer)
        GotServerResponde response ->
            case response of
                Ok stringResponse ->
                    (Just stringResponse, Cmd.none)
                _ ->
                    (Just "Hubo un error", Cmd.none)

askToServer: Cmd Msg
askToServer =
    Http.get
        { url = "/saludo"
        , expect = Http.expectString GotServerResponde}

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init: () -> (Model, Cmd Msg)
init _ =
    (Nothing, Cmd.none)

view: Model -> Browser.Document Msg
view model =
    { title = "Obelisco Real State"
    , body =
        [ button [ onClick ClickedAskToServer] [ text "Ask to server"]
        , text (case model of
                Just string -> string
                Nothing -> "")
        ]
    }

main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }