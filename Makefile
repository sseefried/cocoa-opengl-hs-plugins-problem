HC      = ghc
VER     = 7.6.3
SRC     = src
CC      = /usr/bin/cc
CFLAGS  = -fobjc-arc -I$(shell $(HC) --print-libdir)/include -I$(SRC)
HCFLAGS = -package-db ./.cabal-sandbox/x86_64-osx-ghc-$(VER)-packages.conf.d \
          -no-user-package-db \
          -i$(SRC)

LDFLAGS = -package-db ./.cabal-sandbox/x86_64-osx-ghc-$(VER)-packages.conf.d \
          -no-user-package-db \
          -package text \
          -package plugins \
          -framework Cocoa -framework OpenGL -optl-ObjC -threaded

OBJS = $(SRC)/Main.o $(SRC)/App.o $(SRC)/AppDelegate.o $(SRC)/MyOpenGLView.o $(SRC)/NSLog.o \
       $(SRC)/AppDelegate_objc.o $(SRC)/NSLog_objc.o $(SRC)/App_objc.o


HI_FILES=$(patsubst %.o,%.hi,$(OBJS))

default: PluginProblem.app/Contents/MacOS/PluginProblem

%.o: %.hs
	$(HC) -c $< $(HCFLAGS) -cpp -DPWD="\"`pwd`\""

$(SRC)/AppDelegate.o: $(SRC)/MyOpenGLView.o

$(SRC)/Main.o:

$(SRC)/App.o:         $(SRC)/NSLog.o
$(SRC)/Main.o:        $(SRC)/App.o $(SRC)/AppDelegate.o

$(SRC)/NSLog_objc.m:       $(SRC)/NSLog.o
$(SRC)/App_objc.m:         $(SRC)/App.o
$(SRC)/AppDelegate_objc.m: $(SRC)/AppDelegate.o

PluginProblem: $(OBJS)
	$(HC) -o $@ $^ $(LDFLAGS)

PluginProblem.app/Contents/MacOS/PluginProblem: PluginProblem
	cp $< $@

.PHONY: clean

clean:
	rm -f $(OBJS) $(HI_FILES) $(SRC)/App_objc.[hm]\
        $(SRC)/AppDelegate_objc.[hm] $(SRC)/*_stub.h $(SRC)/NSLog_objc.[hm] \
        PluginProblem \
	      PluginProblem.app/Contents/MacOS/PluginProblem \
	      plugins/*.hi plugins/*.o
