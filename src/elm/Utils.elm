module Utils exposing (..)

import String exposing (split)
import Types exposing (..)

maddrtourl : Maddr -> String
maddrtourl maddr =
  "https://ipfs.io/ipfs/" ++ maddr

get_mediatype : String -> String
get_mediatype mime =
  case List.head (String.split "/" mime ) of
    Just val -> val
    Nothing -> "a"

filesymbol : Types.File -> String
filesymbol file =
  if file.mime == "Unknown filetype" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
  else if file.mime == "inode/directory" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/file/svg/production/ic_folder_open_48px.svg"
  else if (get_mediatype file.mime) == "image" then
    maddrtourl file.maddr
  else if (get_mediatype file.mime) == "audio" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/image/svg/production/ic_audiotrack_48px.svg"
  else if (get_mediatype file.mime) == "video" then
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/notification/svg/production/ic_ondemand_video_48px.svg"
  else
    maddrtourl "QmcGneXUwhLv49P23kZPQ5LCEi15nQis4PZDrd1jZf75cc/alert/svg/production/ic_error_48px.svg"
    --maddrtourl file.maddr

play : Types.File -> Types.Action
play file =
  if file.mime == "Unknown filetype" then
    Browsing [file]
  else if file.mime == "inode/directory" then
    Browsing [file]
  else if (get_mediatype file.mime) == "image" then
    Showing_img file.maddr
  else if (get_mediatype file.mime) == "audio" then
    Playing_audio file.maddr
  else if (get_mediatype file.mime) == "video" then
    Playing_video file.maddr
  else
    Browsing [file]
