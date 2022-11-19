------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------

import XMonad
import Data.Monoid
import Data.Maybe (fromJust)

import System.Exit
import System.IO (hPutStrLn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- User imports
import XMonad.Util.SpawnOnce (spawnOnce)        -- For spawning processes
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig                     -- for easy keybind setup

import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (docks, avoidStruts)
import XMonad.Hooks.UrgencyHook

import XMonad.Layout (Tall, Mirror, Full)
import XMonad.Layout.Renamed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing (spacingWithEdge)  -- for margins around windows
import XMonad.Layout.NoBorders
import XMonad.Layout.Hidden
import XMonad.Layout.ResizableTile

import XMonad.Actions.WithAll (killAll)         -- for killing all windows in ws
import XMonad.Actions.CycleWS


------------------------------------------------------------------------
-- Environment variables
------------------------------------------------------------------------

myTerminal :: String
myTerminal      = "alacritty"

myBrowser :: String
myBrowser       = "firefox"

myMargins :: Int
myMargins       = 2

myBorderWidth :: Dimension
myBorderWidth   = 4

myWorkspaces :: [String]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]


------------------------------------------------------------------------
-- Colors
------------------------------------------------------------------------

myNormalBorderColor :: String
myNormalBorderColor  = nordBlack4

myFocusedBorderColor :: String
myFocusedBorderColor = nordRed

nordBlack1 :: String
nordBlack1 = "#2e3440"

nordBlack2 :: String
nordBlack2 = "#3b4252"

nordBlack3 :: String
nordBlack3 = "#434c5e"

nordBlack4 :: String
nordBlack4 = "#4c566a"

nordWhite1 :: String
nordWhite1 = "#eceff4"

nordWhite2 :: String
nordWhite2 = "#e5e9f0"

nordWhite3 :: String
nordWhite3 = "#d8dee9"

nordBlue1 :: String
nordBlue1 = "#5e81ac"

nordBlue2 :: String
nordBlue2 = "#81a1c1"

nordBlue3 :: String
nordBlue3 = "#88c0d0"

nordBlue4 :: String
nordBlue4 = "#8fbcbb"

nordRed :: String
nordRed = "#bf616a"

nordOrange :: String
nordOrange = "#d08770"

nordYellow :: String
nordYellow = "#ebcb8b"

nordGreen :: String
nordGreen = "#a3be8c"

nordPurple :: String
nordPurple = "#b48ead"

------------------------------------------------------------------------
-- Clickable workspaces
------------------------------------------------------------------------
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)
clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
        where i = fromJust $ M.lookup ws myWorkspaceIndices


------------------------------------------------------------------------
-- Key bindings
------------------------------------------------------------------------

myModMask       = mod4Mask

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Keybinds
myKeysAdd :: [(String, X())]
myKeysAdd = 
        [ 
        -- xmonad base control
          ("M-S-r", spawn "xmonad --recompile; xmonad --restart") -- Reload xmonad
        , ("M-S-q", io exitSuccess)                     -- exit xmonad (logout)
        , ("M-c", kill)                                 -- close focused window
        , ("M-S-c", killAll)                            -- close all in workspace
        , ("M-t", withFocused $ windows . W.sink)       -- push window back into tiling
        , ("M-S-l", spawn "betterlockscreen -l dimblur")-- lock screen
        , ("M-\\", withFocused hideWindow)              -- hide window
        , ("M-S-\\", popOldestHiddenWindow)             -- unhide window

        -- xmonad workspace switching
        -- most of these would probably be launched by gestures via libinput-gestures
        , ("M-M1-<Right>", nextWS)
        , ("M-M1-<Left>", prevWS)

        -- xmonad layout control
        , ("M-S-<Space>", sendMessage NextLayout)       -- cycle xmonad layout
        , ("M-S-<Return>", windows W.swapMaster)        -- swap focused window with master
        , ("M-S-j", windows W.swapDown)                 -- swap down
        , ("M-S-k", windows W.swapUp)                   -- swap up
        , ("M-h", sendMessage Shrink)                   -- shrink master area
        , ("M-l", sendMessage Expand)                   -- expand master area
        , ("M-n", sendMessage MirrorShrink)
        , ("M-u", sendMessage MirrorExpand)
        , ("M-,", sendMessage (IncMasterN 1))           -- +1 window in master
        , ("M-.", sendMessage (IncMasterN (-1)))        -- -1 window in master
        , ("M-f", sendMessage $ Toggle "full")          -- Switch to fullscreen

        -- xmonad focus switching
        , ("M-<Tab>", windows W.focusDown)              -- cycle window focus
        , ("M-j", windows W.focusDown)                  -- cycle window focus down
        , ("M-k", windows W.focusUp)                    -- cycle window focus up

        -- rofi menus
        , ("M-<Space>",    spawn "rofi -show drun")        -- Launch rofi
        , ("M1-<Space> e", spawn "rofi -show filebrowser") -- Launch rofi filebrowser
        , ("M1-<Space> c", spawn "rofi -show calc")        -- Launch rofi-calc
        , ("M1-<Space> p", spawn "passmenu")               -- Launch passmenu (copy to clipboard mode)
        , ("M1-<Space> S-p", spawn "passmenu --type")      -- Launch passmenu (type in mode)

        -- Launch apps
        , ("M-<Return>", spawn (myTerminal))            -- Launch terminal
        , ("M-b", spawn(myBrowser))                     -- Launch browser
        , ("M-e", spawn (myTerminal ++ " -e clifm"))    -- Launch file browser

        -- Multimedia control
        , ("<XF86KbdBrightnessUp>", spawn "brightnessctl -d asus::kbd_backlight s +1")      -- increase kbd brightness
        , ("<XF86KbdBrightnessDown>", spawn "brightnessctl -d asus::kbd_backlight s 1-")    -- decrease kbd brightness
        , ("<XF86MonBrightnessUp>", spawn "brightnessctl -d amdgpu_bl0 s +10%")             -- increase screen brightness
        , ("<XF86MonBrightnessDown>", spawn "brightnessctl -d amdgpu_bl0 s 10%-")           -- decrease screen brightness
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 10%-")                        -- decrease volume
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 10%+")                        -- increase volume
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")                              -- mute/unmute
        ]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

        -- Resize viewed windows to the correct size
        [ ((modm,               xK_n     ), refresh)

        -- Toggle the status bar gap
        -- Use this binding with avoidStruts from Hooks.ManageDocks.
        -- See also the statusBar function from Hooks.DynamicLog.
        --
        -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
        
        -- Run xmessage with a summary of the default keybindings (useful for beginners)
        -- , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
        ]
        ++

        --
        -- mod-[1..9], Switch to workspace N
        -- mod-shift-[1..9], Move client to workspace N
                --
        [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        ++

        --
        -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
        --
        [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

        -- mod-button1, Set the window to floating mode and move by dragging
        [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                >> windows W.shiftMaster))

        -- mod-button2, Raise the window to the top of the stack
        , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

        -- mod-button3, Set the window to floating mode and resize by dragging
        , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                >> windows W.shiftMaster))

        -- you may also bind events to the mouse scroll wheel (button4 and button5)
        ]

------------------------------------------------------------------------
-- Layouts:

--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

tiled = renamed [Replace "tiled"]
        $ avoidStruts
        $ spacingWithEdge myMargins
        $ ResizableTall 1 (3/100) (1/2) []

horizontal = renamed [Replace "horizontal"]
        $ avoidStruts
        $ spacingWithEdge myMargins
        $ Mirror 
        $ Tall 1 (3/100) (1/2)

full = renamed [Replace "full"]
        $ noBorders
        $ spacingWithEdge 0
        $ Full

myLayoutChooser = toggleLayouts full (tiled ||| horizontal ||| full)
myLayoutHook = hiddenWindows myLayoutChooser

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen                  --> doFullFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- Reload last wallpaper
myStartupHook = do
        spawnOnce "nitrogen --restore"
        spawnOnce "dunst"
        spawnOnce "$HOME/.local/bin/lockscreenhook"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmproctop <- spawnPipe ("xmobar $HOME/.config/xmobar/xmobar_top")
        xmprocbottom <- spawnPipe ("xmobar $HOME/.config/xmobar/xmobar_bottom")
        xmonad $ docks $ defaults {
                  logHook = dynamicLogWithPP $ xmobarPP {
                          ppOutput = \x -> hPutStrLn xmproctop x
--                        , ppCurrent = wrap "[" "]"  -- can't see this
                        , ppCurrent = xmobarColor nordBlue1 "" . wrap "[" "]"  -- can see this
                        , ppVisible = xmobarColor nordBlue1 "" . clickable
                        , ppHidden = xmobarColor nordWhite3 "" . clickable
                        , ppUrgent = xmobarColor nordRed "" . clickable
                        , ppHiddenNoWindows = xmobarColor nordBlack2 "" . clickable
                        , ppOrder = \(ws:_:_) -> [ws]
                        }
                }


-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
        -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        -- hooks, layouts
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook
} `additionalKeysP` myKeysAdd
