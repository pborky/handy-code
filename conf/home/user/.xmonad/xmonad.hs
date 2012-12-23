import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName -- java gray window issues
import XMonad.Hooks.ICCCMFocus -- java swing issues
import XMonad.Layout.Fullscreen
import XMonad.Util.Run(spawnPipe,safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Loggers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import System.IO
import Data.Maybe
import Data.Monoid
import MyConfig

-- style
defaultColor    = mkColor "white" "#222222"
statusColor     = mkColor "#6699bb" "#222222"
menuNormColor   = mkColor "#aaaaaa" "#222222"
menuSelColor    = mkColor "#ffffff" "#285577"
normalWindowBorderColor = mkFgColor "#888888"
focusedWindowBorderColor = mkFgColor "#900000"
urgentColor     = mkColor "#bbbbbb" "#900000"
visibleColor    = mkColor "white" "#444444"
currentColor    = mkColor "white" "#285577"
hiddenColor     = mkColor "#bbbbbb" "#222222"
hiddenNoWindowsColor = mkColor "#555555" "#222222"
sepColor        = mkColor "#999999" "#222222"
layoutColor     = mkColor "#5588aa" "#222222"
titleColor      = mkColor "#6699bb" "#222222"
dateColor       = mkColor "#cc0044" "#222222"
timeColor       = mkColor "#ff3355" "#222222"

fontName = "-*-Fixed-Medium-R-Normal-*-11-*-*-*-*-*-*-*"

statusWsSep = ""
statusSep   = "|"

-- external commands
xmobarCmd       = ExecType "/usr/bin/xmobar"    --[ "/home/peterb/.xmonad/xmobarrc"
                                                [ "-F", fgColorWrap statusColor
                                                , "-B", bgColorWrap statusColor
                                                , "-f", fontName
                                                , "-t", "%StdinReader%}{"
                                                , "-o" 
                                                ]
dzenCmd         = ExecType "/usr/bin/dzen2"     [ "-fn", fontName
                                                , "-sa", "r"
                                                , "-ta", "l"
                                                , "-w", "900"
                                                , "-bg", bgColorWrap statusColor
                                                , "-fg", fgColorWrap statusColor
                                                --, "-x", "0"
                                                ]
trayerCmd       = ExecType "/home/peterb/bin/trayer" [] -- my trayer 
trayerCmd2      = ExecType "/usr/bin/trayer"    [ "--edge", "top"
                                                , "--align", "right"
                                                , "--SetDockType", "true"
                                                , "--SetPartialStrut", "false"
                                                , "--expand", "true"
                                                , "--width", "10" 
                                                , "--widthtype", "request"
                                                , "--transparent", "true"
                                                , "--alpha", "200"
                                                , "--tint", "0xffffff"--bgColorWrap statusColor
                                                , "--height", "13"
                                                , "--heighttype", "pixel"
                                                , "--monitor", "primary"
                                                ]
terminalCmd      = ExecType "/usr/bin/urxvt" []
terminalFloatCmd = ExecType "/usr/bin/urxvt" [ "-name", "float" ] 
lockerCmd        = ExecType "/home/peterb/bin/lock" [ ]
suspenderCmd     = ExecType "/home/peterb/bin/pm-suspend" [ ]
scrotWndCmd      = ExecType "/home/peterb/bin/scrot" [ "wnd" ]
scrotFullCmd     = ExecType "/home/peterb/bin/scrot" [ "root" ]
--scrotWndCmd      = ExecType "/usr/bin/import" [ "-window", "root", "/home/peterb/tmp/scrot_`date +'%Y-%m-%d_%H-%M-%S'`.png" ]
--scrotFullCmd     = ExecType "/usr/bin/import" [ "/home/peterb/tmp/scrot_`date +'%Y-%m-%d_%H-%M-%S'`.png" ]
dockCmd          = ExecType "/home/peterb/bin/dock" []
undockCmd        = ExecType "/home/peterb/bin/undock" []
dmenuCmd         = ExecType "/home/peterb/bin/dmenu_run" 
                                                [ "-nb", bgColorWrapNoQuot menuNormColor
                                                , "-nf", fgColorWrapNoQuot menuNormColor
                                                , "-sb", bgColorWrapNoQuot menuSelColor
                                                , "-sf", fgColorWrapNoQuot menuSelColor
                                                , "-i"
                                                , "-fn", fontName
                                                ]

-- autostart trayer applets definitions 
trayAppsCmds =  [ trayerCmd 
    , ExecType "gnome-settings-daemon" []
    , ExecType "bluetooth-applet" []
    , ExecType "system-config-printer-applet" []
    , ExecType "nm-applet" []
    , ExecType "volumeicon" []
    ]

-- floater hooks definietions
floaterHooks = flip map floaterClasses $ \ xs -> className =? xs --> doFloat
    where floaterClasses =  [ "Xfce4-notifyd"
                            , "Gnome-control-center"
                            , "Bluetooth-wizard"
                            , "Nautilus"
                            , "Xfce4-settings-manager"
                            , "Ristretto"
                            , "Display.im6"
                            , "Gitk"
                            , "Git-gui"
                            , "Tk"
                            , "Xephyr"
                            , "float"
                            ]

-- shortcut definietions
controlAltMask = controlMask .|. mod1Mask
altMask = mod1Mask
winMask = mod4Mask
winShiftMask = winMask .|. shiftMask

shortCutKeys =  [ ShortCutType controlAltMask xK_l lockerCmd 
                , ShortCutType controlAltMask xK_s suspenderCmd
                , ShortCutType controlMask xK_Print scrotWndCmd
                , ShortCutType winMask xK_d dmenuCmd
                , ShortCutType 0 xK_Print scrotFullCmd
                , ShortCutType winShiftMask xK_s dockCmd
                , ShortCutType winMask xK_s undockCmd
                ]

layout = smartBorders .fullscreenFull $ tiled ||| Mirror tiled ||| Full
--layout = tiled ||| Mirror tiled ||| Full
    where tiled   = Tall nmaster delta ratio 
          nmaster = 1 
          ratio   = 60/100
          delta   = 3/100

xConfig = addUrgencyHook $ addShortCuts $ defaultConfig
        { terminal    = filePath terminalCmd
        , modMask     = winMask
        , borderWidth = 1
        , normalBorderColor   = fgColorWrap normalWindowBorderColor
        , focusedBorderColor  = fgColorWrap focusedWindowBorderColor
        , manageHook = manageDocks <+> fullscreenManageHook <+> -- heartBeatEventHook 10.0 <+>
                       composeAll floaterHooks <+> manageHook defaultConfig
        , handleEventHook   = docksEventHook <+> fullscreenEventHook 
        , layoutHook        = layout 
        , logHook           = dynamicLog <+> takeTopFocus
        , startupHook       = setWMName "LG3D" <+>  startHeartBeatTimer 10.0
        }
    where addUrgencyHook  = withUrgencyHook NoUrgencyHook
          addShortCuts    = flip additionalKeys $ map shortCutUnwrap  shortCutKeys

prettyPrint defaults color colorL strip = defaults
        { ppUrgent          = (mapC urgentColor) . strip
        , ppVisible         = (mapC visibleColor) . strip
        , ppCurrent         = (mapC currentColor) . strip
        , ppHidden          = (mapC hiddenColor) . strip
        , ppHiddenNoWindows = (mapC hiddenNoWindowsColor) . strip
        , ppWsSep           = (mapC sepColor) statusWsSep
        , ppSep             = (mapC sepColor) statusSep
        , ppLayout          = (mapC layoutColor) . strip
        , ppTitle           = (mapC titleColor) . shorten 150
        , ppExtras          = [ (mapCL dateColor) $ date "%a %Y/%m/%d"
                              , (mapCL timeColor) $ date "%H:%M"
                              ]
        , ppOrder = \(wSpace:_:title:extras) -> wSpace:extras ++ [title]
        --, ppSort  = getSortByXineramaRule
        }
    where mapC  = mapColor color
          mapCL = mapColor colorL

-- entry point
main = tray >> (xmonad =<< status pp xConfig)
    where exec          = xmobarCmd    
          cmd           = fullCommand exec
          status        = flip ( statusBar cmd ) $ \_->(winMask,xK_y)
          pp            = prettyPrint xmobarPP xmobarColor xmobarColorL xmobarStrip
          tray          = mapM mySpawn trayAppsCmds
              

