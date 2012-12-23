
module MyConfig (
    ExecType(..),
    ShortCutType(..),
    ColorType(..),
    fullCommand,
    mySpawn,
    mySpawnPipe,
    shortCutUnwrap,
    mkColor,
    mkFgColor,
    mapColor,
    fgColorWrap,
    bgColorWrap,
    fgColorWrapNoQuot,
    bgColorWrapNoQuot,
    startHeartBeatTimer,
    heartBeatEventHook
) where

import XMonad
import XMonad.Util.Timer(startTimer,handleTimer)
import XMonad.Util.Run(spawnPipe,safeSpawn)
import XMonad.Hooks.DynamicLog
import System.IO
import Data.Maybe
import Data.Unique
import Data.Monoid
import Data.Functor
import Control.Concurrent


-- handy stuff
data ExecType = ExecType {
          filePath :: FilePath
        , arguments :: [String]
        } deriving (Show, Eq)
fullCommand :: ExecType -> String
fullCommand  s =  path ++ " " ++ args
    where path = filePath s
          args = unwords . arguments $ s

mySpawn :: MonadIO m => ExecType -> m ()
mySpawn s = safeSpawn path args
    where path = filePath s
          args = arguments s

mySpawnPipe :: MonadIO m => ExecType -> m Handle
mySpawnPipe s = spawnPipe prg
    where prg = fullCommand s

data ShortCutType = ShortCutType {
          modifierKey :: KeyMask
        , keySym :: KeySym
        , executable :: ExecType
        } deriving (Show, Eq)


shortCutUnwrap :: ShortCutType -> ((KeyMask, KeySym), X ())
shortCutUnwrap s = ((mod, key), mySpawn cmd)
    where mod = modifierKey s
          key = keySym s
          cmd = executable s

data ColorType = ColorType {
          fgColor :: Maybe String
        , bgColor :: Maybe String
        } deriving (Show, Eq)

mkColor :: String -> String -> ColorType
mkColor fg bg = ColorType fgJ bgJ
    where fgJ = Just fg
          bgJ = Just bg

mkFgColor :: String -> ColorType
mkFgColor = flip ColorType Nothing . Just

mkBgColor :: String -> ColorType
mkBgColor = ColorType Nothing . Just

mapColor :: (String -> String -> a) -> ColorType -> a
mapColor f color = f fg bg
    where fg = fgColorWrapNoQuot color
          bg = bgColorWrapNoQuot color

colorWrapQuot :: ColorType -> (ColorType -> Maybe String) -> String -> ColorType -> String
colorWrapQuot defaultColor getter quot = maybeDefault . wrapQuot . getter
    where wrapQuot      = fmap $ wrap quot quot
          maybeDefault  = maybe color id
          color         = fromJust $ getter defaultColor

colorWrapWhiteOnBlack :: (ColorType -> Maybe String) -> String -> ColorType -> String
colorWrapWhiteOnBlack = colorWrapQuot $ mkColor "white" "black"

fgColorWrapWhiteOnBlack :: String -> ColorType -> String
fgColorWrapWhiteOnBlack = colorWrapWhiteOnBlack fgColor

bgColorWrapWhiteOnBlack :: String -> ColorType -> String
bgColorWrapWhiteOnBlack = colorWrapWhiteOnBlack bgColor

fgColorWrap :: ColorType -> String
fgColorWrap =  fgColorWrapWhiteOnBlack "\""

bgColorWrap :: ColorType -> String
bgColorWrap =  bgColorWrapWhiteOnBlack "\""

fgColorWrapNoQuot :: ColorType -> String
fgColorWrapNoQuot =  fgColorWrapWhiteOnBlack ""

bgColorWrapNoQuot :: ColorType -> String
bgColorWrapNoQuot =  bgColorWrapWhiteOnBlack ""


startHeartBeatTimer :: Rational -> X ()
startHeartBeatTimer delay = do
    _ <- startTimer delay
    return ()

heartBeatEventHook :: Rational -> Event -> X All
heartBeatEventHook delay (ClientMessageEvent {ev_message_type = mt, ev_data = dt}) =  do
  d <- asks display
  a <- io $ internAtom d "XMONAD_TIMER" False
  if mt == a && dt /= []
    then do 
        _ <- startTimer delay
        asks (logHook . config) >>= userCodeDef ()
        return $  All True
    else return $ All True
heartBeatEventHook _ _ = return $ All True

