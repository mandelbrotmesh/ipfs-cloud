port module Ipfs-elm exposing (..)

port start : Cmd msg
port stop : Cmd msg

port request : String -> Cmd msg

port response : Html msg -> Sub msg

port getprogress : Int -> Sub msg

port error : String -> Sub msg

get : String -> Sub msg
get query =
  response ( request query )

pin
