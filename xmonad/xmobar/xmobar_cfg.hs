module Main (main) where

import XMobarHs
import XMonad
import XMonad.Hooks.StatusBar.PP (xmobarColor, xmobarFont)

-- color definition
nordBlack0 = "#1c1f26"
nordBlack1 = "#2e3440"
nordBlack2 = "#3b4252"
nordBlack3 = "#434c5e"
nordBlack4 = "#4c566a"
nordWhite1 = "#eceff4"
nordWhite2 = "#e5e9f0"
nordWhite3 = "#d8dee9"
nordBlue1 = "#5e81ac"
nordBlue2 = "#81a1c1"
nordBlue3 = "#88c0d0"
nordBlue4 = "#8fbcbb"
nordRed = "#bf616a"
nordOrange = "#d08770"
nordYellow = "#ebcb8b"
nordGreen = "#a3be8c"
nordPurple = "#b48ead"

-- additionalFonts
myAdditionalFonts = [
          "xft:Font Awesome 6 Pro:style=Regular:pixelsize=15"
        , "xft:Font Awesome 6 Pro:style=Solid:pixelsize=15"
        ]


-- icon definitions
download        = xmobarFont 1 "\xf358"   -- 
upload          = xmobarFont 1 "\xf35b"   -- 
brightness      = xmobarFont 1 "\xe0c9"   -- 
wifi            = xmobarFont 2 "\xf1eb"   -- 
cpu             = xmobarFont 1 "\xf2db"   -- 
battery_charge  = xmobarFont 1 "\xf376"   -- 
battery         = xmobarFont 1 "\xf240"   -- 
volume_mute     = xmobarFont 2 "\xf6a9"   -- 
volume_low      = xmobarFont 2 "\xf027"   -- 
volume_med      = xmobarFont 2 "\xf6a8"   -- 
volume_high     = xmobarFont 2 "\xf028"   -- 
temp            = xmobarFont 1 "\xe299"   -- 

-- xmobar theme config
xmobar_theme = xmobar_def {
        font = "xft:JetBrains Mono:style=Regular:pixelsize=15:antialiasing=True:hinting=true"
        , additionalFonts = myAdditionalFonts
        , bgColor = nordBlack0
        , fgColor = nordWhite1
        , alpha = 255
        , lowerOnStart = True
        , pickBroadest = False
        , persistent = False
        , hideOnStart = False
        , iconRoot = "."
        , allDesktops = True
        , sepChar = "%"
        , alignSep = "}{"
}

-- Plugin options
network_cfg = Network "wlp3s0"
        [ "-S", "True"
        , "-t", "<rx> "++download++" <tx> "++upload
        ] 10
wlan_cfg = Wireless "" 
        [ "-t", wifi++" <ssid>" 
        ] 10
cpu_cfg = Cpu 
        [ "-L",         "3"
        , "-H",         "50"
        , "--normal",   "#a3be8c"
        , "--high",     "#bf616a"
        , "-S",         "True"
        , "-t",         cpu++" <total>"
        ] 10
mem_cfg = Memory 
        [ "-t","Mem: <usedratio>%"
        ] 10
bat_cfg = BatteryP ["BAT0"]
        [ "-t", "<acstatus>"
        , "-L", "20", "-l", nordRed
        , "-H", "80", "-h", nordGreen
        , "--"
        , "-p", nordGreen
        , "-P"
        , "-A", "5"
        , "-a", "notify-send -u critical \"Battery Low\" \"Plug in the power cable\""
        , "-O", battery_charge++" <left>"
        , "-i", battery_charge++" <left>"
        , "-o", battery++" <left>"
        ] 100
vol_cfg = Volume "default" "Master"
        [ "-t", "<status> <volume>"
        , "-S", "True"
        , "--"
        , "-L", "20"
        , "-H", "80"
        , "-C", nordWhite1
        , "-c", nordRed
        , "-O", ""
        , "-o", volume_mute
        , "-l", volume_low
        , "-m", volume_med
        , "-h", volume_high
        ] 2
bright_cfg = Brightness
        [ "-S", "True"
        , "-t", brightness++" <percent>"
        , "--"
        , "--device", "amdgpu_bl0"
        ] 20
therm_config = 
        [ "-L", "60"
        , "-H", "80"
        , "-l", nordGreen
        , "-h", nordRed
        , "-t", temp++" <temp>\x00b0\&C"
        ]
therm0 = ThermalZone 0 therm_config 30
therm1 = ThermalZone 1 therm_config 30
date_cfg = Date "%a %b %_d %Y %H:%M" "date" 50


-- Panel specific configs
xmobar_top = xmobar_theme {
          commands = [
                  Run $ bat_cfg
                , Run $ vol_cfg
                , Run $ bright_cfg
                , Run $ date_cfg
                , Run $ UnsafeStdinReader
                ]
        , template = " %UnsafeStdinReader% }\
                                \ %date% \
                                \{ %bright% | %default:Master% | %battery% "
        }

xmobar_bottom = xmobar_theme {
          position = Bottom
        , commands = [
                  Run $ wlan_cfg
                , Run $ network_cfg
                , Run $ cpu_cfg
                , Run $ therm0
                ]
        , template = " %wi% | %wlp3s0% }{ %cpu%  %thermal0% "
        }

main = do
        -- export "<filename>" $ xmobar_theme
        export "xmobar_top" $ xmobar_top
        export "xmobar_bottom" $ xmobar_bottom
