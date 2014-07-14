#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGES="cpphs-1.18.5 \
   exception-mtl-0.3.0.4 \
   exception-transformers-0.3.0.3 \
   ghc-paths-0.1.0.9 \
   haskell-src-1.0.1.6 \
   haskell-src-exts-1.15.0.1 \
   haskell-src-meta-0.6.0.7 \
   language-c-inline-0.6.0.0 \
   language-c-quote-0.8.0 \
   mainland-pretty-0.2.7 \
   mtl-2.1.3.1 \
   plugins-1.5.4.0 \
   polyparse-1.9 \
   random-1.0.1.1 \
   srcloc-0.4.0 \
   stm-2.4.3 \
   syb-0.4.2 \
   symbol-0.2.1 \
   text-1.1.1.3 \
   th-lift-0.6.1 \
   th-orphans-0.8.1 \
   transformers-0.3.0.0"

rm -rf $THIS_DIR/.cabal-sandbox $THIS_DIR/cabal.sandbox.config
cd $THIS_DIR
cabal sandbox init
cabal install $PACKAGES

