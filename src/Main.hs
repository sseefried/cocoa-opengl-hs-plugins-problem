import qualified App         as App
import qualified AppDelegate as AppDelegate
import qualified NSLog       as NSLog

main :: IO ()
main = do
  App.objc_initialise
  AppDelegate.objc_initialise
  NSLog.objc_initialise
  App.main