module Main exposing (main,subscriptions,key)
import Browser
import Browser.Events exposing (onAnimationFrameDelta,onKeyDown,onKeyUp) 
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Json.Encode exposing (Value)
import Messages exposing (Msg(..))
-- import Task
import View exposing (view)
import Update
import Model exposing (Model, defaultMe)
-- import Html.Styled exposing (..)
-- import Html.Styled.Attributes exposing (..)

-- import Debug
-- import Model exposing (Model)
main : Program Value Model Msg
main =
    Browser.element
        { view =  View.view 
        , init = \_ -> (init, Cmd.none)
        , update = Update.update
        
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyUp (Decode.map (key False) keyCode)
        , onKeyDown (Decode.map (key True) keyCode)
        -- , onResize Resize
        ]


key : Bool -> Int -> Msg
key on keycode =
    case keycode of
        87 ->
            MoveUp on
        65 ->
            MoveLeft on
        68 ->
            MoveRight on       
        83 ->
            MoveDown on
        77 ->
            NextFloor
        _ ->
            Noop

init : Model
init = Model defaultMe [] [] mapInit roomInit mapInit