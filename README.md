# Plugins interacting poorly in a hybrid Objective-C/Haskell program

This repository was created to illustrate a problem I'm having with displaying multiple NSOpenGLView windows in a hybrid Objective-C/Haskell program.

I am using Manuel Chakravarty's new [language-inline-c](https://github.com/mchakravarty/language-c-inline) package.

## System requirements

* GHC 7.6.3
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

It only seems to fail when I'm using one screen on my
Macbook Pro Retina (Late 2013) model.

When I have a second screen plugged the two OpenGL
windows open fine!
