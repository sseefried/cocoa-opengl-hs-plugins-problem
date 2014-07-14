//
//  MyOpenGLView.m
//  MultipleNSOpenGLView
//
//  Created by Sean Seefried on 11/07/2014.
//  Copyright (c) 2014 SeefriedSoftware. All rights reserved.
//

#import "MyOpenGLView.h"

@implementation MyOpenGLView

- (id)initWithFrame:(NSRect)frame
{
  NSLog(@"init MyOpenGLView: %@", self);
    NSOpenGLPixelFormatAttribute attrs[] =
    {
      NSOpenGLPFADoubleBuffer,
      NSOpenGLPFADepthSize, 8,
      0
    };
    NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    if (!pf)
    {
      NSLog(@"No OpenGL pixel format");
      return nil;
    }
    self = [super initWithFrame: frame pixelFormat:pf];
    if (self) {
      NSOpenGLContext* context = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
      [self setPixelFormat:pf];
      [self setOpenGLContext:context];
      [context makeCurrentContext];
      [self drawRect:self.frame];
    }

  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];
  [[self openGLContext] makeCurrentContext];
  glClearColor(0,0,0,1); // black
  glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
  [[self openGLContext] flushBuffer];

}

- (void)reshape
{
  NSRect superRect = [[self superview] bounds];
  self.frame = superRect;
  [[self openGLContext] update];

  [self drawRect:self.bounds];
}

- (void) dealloc {
  NSLog(@"dealloc MyOpenGLView: %@", self);
}

@end
