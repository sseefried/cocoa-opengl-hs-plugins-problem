{-# LANGUAGE TemplateHaskell, QuasiQuotes, CPP, OverloadedStrings #-}

-- HSApp: a simple Cocoa app in Haskell
--
-- Application delegate object, abused as a view controller

module AppDelegate (objc_initialise) where

  -- language-c-inline
import Language.C.Quote.ObjC
import Language.C.Inline.ObjC
import System.Plugins as Plugins
import Data.Text (Text)
import qualified Data.Text as T


replaceSuffix :: String -> String
replaceSuffix = T.unpack . go . T.pack
  where
    go = T.replace ".hs" ".o"


objc_import ["<Cocoa/Cocoa.h>", "MyOpenGLView.h", "HsFFI.h"]

objc_interface [cunit|

@interface AppDelegate : NSResponder <NSApplicationDelegate>

@property typename NSMutableArray *effects;

@end
|]

pwd = PWD

pluginFilePath :: String
pluginFilePath = pwd ++ "/plugins/Plugin.hs"

loadPlugin :: IO String
loadPlugin = do
  let obj = replaceSuffix pluginFilePath
  res <- Plugins.build pluginFilePath obj ["-c"]
  if null res
    then do
      mbStatus <- Plugins.load obj [] [] "pluginString"
      case mbStatus of
        LoadSuccess modul pluginString -> do
          Plugins.unloadAll modul
          return pluginString
        LoadFailure errors -> return . concat $ errors
    else return $ "Build failure: Could not build " ++ pluginFilePath

objc_implementation [Typed 'loadPlugin] [cunit|

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(typename NSNotification *)aNotification
{
  NSLog(@"Application did finish launching!");
  self.effects = [NSMutableArray array];
  [self.effects addObject:[self newWindowAtX:100 andY:100]];
  // Commenting out the following line will cause the two OpenGL windows to open

  NSLog(@"Plugin string: %@", loadPlugin());
  [self.effects addObject:[self newWindowAtX:300 andY:150]];
}

- (typename NSWindow *) newWindowAtX:(typename NSInteger) x andY:(typename NSInteger) y {
  typename NSRect frame = NSMakeRect(0,0,400,300);
  typename NSWindow *window  = [[NSWindow alloc] initWithContentRect:frame
                                                   styleMask:(NSTitledWindowMask |
                                                              NSClosableWindowMask |
                                                              NSResizableWindowMask)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
  [window makeKeyAndOrderFront:NSApp];
  typename NSRect bounds = [[NSScreen mainScreen] frame];
  [window setFrameTopLeftPoint:NSMakePoint(x,bounds.size.height - y)];
  typename MyOpenGLView *view = [[MyOpenGLView alloc] initWithFrame:frame];
  [[window contentView] addSubview:view];
  return window;
}

@end

|]

objc_emit
