module XMobarHs
( Config   (..)
, Position (..)
, Align    (..)
, Border   (..)
, Command  (..)
, Run      (..)
, xmobar_def
, export
) where

import Data.List

data Config = Config { font             :: String
                     , additionalFonts  :: [String]
                     , bgColor          :: String
                     , fgColor          :: String
                     , alpha            :: Int
                     , position         :: Position
                     , lowerOnStart     :: Bool
                     , hideOnStart      :: Bool
                     , persistent       :: Bool
                     , iconRoot         :: String
                     , allDesktops      :: Bool
                     , border           :: Border
                     , borderColor      :: String
                     , pickBroadest     :: Bool
                     , commands         :: [Run Command]
                     , sepChar          :: String
                     , alignSep         :: String
                     , template         :: String
                     }

cfgPairs :: [(String, (Config -> String))]
cfgPairs = [ ("font"            , show.font             )
           , ("additionalFonts" , show.additionalFonts  )
           , ("bgColor"         , show.bgColor          )
           , ("fgColor"         , show.fgColor          )
           , ("alpha"           , show.alpha            )
           , ("position"        , show.position         )
           , ("lowerOnStart"    , show.lowerOnStart     )
           , ("hideOnStart"     , show.hideOnStart      )
           , ("persistent"      , show.persistent       )
           , ("iconRoot"        , show.iconRoot         )
           , ("allDesktops"     , show.allDesktops      )
           , ("border"          , show.border           )
           , ("borderColor"     , show.borderColor      )
           , ("pickBroadest"    , show.pickBroadest     )
           , ("commands"        , show.commands         )
           , ("sepChar"         , show.sepChar          )
           , ("alignSep"        , show.alignSep         )
           , ("template"        , show.template         )
           ]

xmobar_def :: Config
xmobar_def = Config { font                  = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
                , additionalFonts       = []
                , bgColor               = "#000000"
                , fgColor               = "#BFBFBF"
                , alpha                 = 255
                , position              = Top
                , lowerOnStart          = True
                , hideOnStart           = False
                , persistent            = False
                , iconRoot              = "."
                , allDesktops           = True
                , border                = NoBorder
                , borderColor           = "#BFBFBF"
                , pickBroadest          = False
                , commands              = [ Run $ Date "%a %b %_d %Y * %H:%M:%S" "theDate" 10, Run StdinReader]
                , sepChar               = "%"
                , alignSep              = "}{"
                , template              = "%StdinReader% }{ <fc=#00FF00>%uname%</fc> * <fc=#FF0000>%theDate%</fc>"
                }

-- Must be rewritten, to remove unnecessary defaults
instance Show Config where
  showsPrec _ n s = "Config {" ++ e n ++ "}" ++ s
    where e x = intercalate ", " [g (fst y) | y <- f x, uncurry (/=) y]
          f x = zip (h x) (h xmobar_def)
          g x = fst x ++ " = " ++ snd x
          h x = map (\y -> (fst y, snd y x)) cfgPairs

data Position = Top    | TopW    Align Int | TopSize    Align Int Int
              | Bottom | BottomW Align Int | BottomSize Align Int Int
              | TopH Int
              | Static { xpos  :: Int, ypos   :: Int
                       , width :: Int, height :: Int
                       } deriving Show

data Align = L | C | R deriving Show

data Border = TopB    | TopBM    Int
            | BottomB | BottomBM Int
            | FullB   | FullBM   Int
            | NoBorder deriving Show

data Command = Uptime                                [String] Int
             | Weather            String             [String] Int
             | Network            String             [String] Int
             | DynNetwork                            [String] Int
             | Wireless           String             [String] Int
             | Memory                                [String] Int
             | Swap                                  [String] Int
             | Cpu                                   [String] Int
             | MultiCpu                              [String] Int
             | Battery                               [String] Int
             | BatteryP           [String]           [String] Int
             | TopProc                               [String] Int
             | TopMem                                [String] Int
             | DiskU              [(String, String)] [String] Int
             | DiskIO             [(String, String)] [String] Int
             | ThermalZone        Int                [String] Int
             | Thermal            String             [String] Int
             | CpuFreq                               [String] Int
             | CoreTemp                              [String] Int
             | Volume             String String      [String] Int
             | MPD                                   [String] Int
             | Mpris1             String             [String] Int
             | Mpris2             String             [String] Int
             | Mail               [(String, String)] String
             | Mbox               [(String, String, String)] [String] String
             | XPropertyLog       String
             | NamedXPropertyLog  String String
             | Brightness         [String]                    Int
             | Kbd                [(String, String)]
             | Locks
             | Com                String [String] String      Int
             | StdinReader
             | UnsafeStdinReader
             | Date               String String               Int
             | DateZone           String String String String Int
             | CommandReader      String String
             | PipeReader         String String
             | BufferedPipeReader String [(Int, Bool, String)]
             | XMonadLog
             deriving Show

data Run a = Run a

-- Must be rewritten, as derived version inserts parens
instance Show a => Show (Run a) where
  showsPrec _ (Run x) s = "Run " ++ show x ++ s

-- Example of use:
-- main = export $ xmobar_def { ... }
-- remember to put a "$" after every "Run"
-- otherwise, configure it the same as you would a normal .xmobarrc
export :: String -> Config -> IO ()
export fname = writeFile fname . show
