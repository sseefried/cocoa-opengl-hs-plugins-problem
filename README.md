# Plugins interacting poorly in a hybrid Objective-C/Haskell program

This repository was created to illustrate a problem I'm having with displaying multiple NSOpenGLView windows in a hybrid Objective-C/Haskell program.

I am using Manuel Chakravarty's new [language-inline-c](https://github.com/mchakravarty/language-c-inline) package.

## What it was tested on

* GHC 7.6.3 and GHC 7.8.2
* Mac OS X 10.9.3
* cabal-install version 1.20.0.1

## Installation

    $ ./setup.sh
    $ make
    $ open PluginsProblem.app

```setup.sh``` will install a very precise set of
packages using the new Cabal sandbox feature. I coulnd't
distribute this using a .cabal file because of the
fact that Objective-C sources files are generated
as a by-product of the compilation process. Cabal does not support compile dependencies in this context.

## Failure modes

The first window, which is allocated and displayed before the plugin is loaded,
displays just fine. The second one fails to initialise properly.

It only seems to fail when I'm using one screen on my
Macbook Pro Retina (Late 2013) model.

When I have a second screen plugged the two OpenGL
windows open fine!

Open the Console app and check the logs for the program.
You will see something like:

    14/07/2014 4:53:27.655 pm PluginProblem[93394]: Application did finish launching!
    14/07/2014 4:53:27.695 pm PluginProblem[93394]: init MyOpenGLView: <MyOpenGLView: 0x618000161140>
    14/07/2014 4:53:28.166 pm PluginProblem[93394]: Plugin string: This is the plugin string
    14/07/2014 4:53:28.517 pm PluginProblem[93394]: init MyOpenGLView: <MyOpenGLView: 0x6080001612c0>
    14/07/2014 4:53:28.517 pm PluginProblem[93394]: invalid display
    14/07/2014 4:53:28.518 pm PluginProblem[93394]: No OpenGL pixel format
    14/07/2014 4:53:28.518 pm PluginProblem[93394]: dealloc MyOpenGLView: <MyOpenGLView: 0x6080001612c0>

In particular the "invalid display" log message seems to be a byproduct of the
call ```NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];```
which appears in ```MyOpenGLView.m```.

If you comment out the line that loads the Haskell plugin then you do not get this problem.