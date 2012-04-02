/*
 *  CukunityServer.mm
 *  CukunityServer
 *
 *  Created by Mario Freitas (imkira@gmail.com) on 2012/03/02.
 *  Copyright 2012 Mario Freitas (imkira@gmail.com). All rights reserved.
 *
 *  Touch synthesization code adapted from:
 *  http://cocoawithlove.com/2008/10/synthesizing-touch-event-on-iphone.html
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//
//  TouchSynthesis.m
//  SelfTesting
//
//  Created by Matt Gallagher on 23/11/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

//
// UITouch (Synthesize)
//
// Category to allow creation and modification of UITouch objects.
//
@interface UITouch (Synthesize)

- (id)initInView:(UIView *)view;
- (void)setPhase:(UITouchPhase)phase;
- (void)setLocationInWindow:(CGPoint)location;

@end

//
// UIEvent (Synthesize)
//
// A category to allow creation of a touch event.
//
@interface UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch;

@end

@implementation UITouch (Synthesize)


//
// initInView:phase:
//
// Creats a UITouch, centered on the specified view, in the view's window.
// Sets the phase as specified.
//
- (id)initInView:(UIView *)view at:(CGPoint)point tapCount:(NSUInteger)tapCount
{
    self = [super init];
    if (self != nil)
    {
        _tapCount = tapCount;
        _locationInWindow =	[view.window convertPoint:point fromView:view];
        _previousLocationInWindow = _locationInWindow;
        
        UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
        _window = [view.window retain];
        _view = [target retain];
        _phase = UITouchPhaseBegan;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _timestamp = [NSDate timeIntervalSinceReferenceDate];
        _gestureView = [view retain];
    }
	  return self;
}

- (id)initInView:(UIView *)view
{
    CGRect frameInWindow;
    if ([view isKindOfClass:[UIWindow class]])
    {
        frameInWindow = view.frame;
    }
    else
    {
        frameInWindow =
        [view.window convertRect:view.frame fromView:view.superview];
    }
    CGPoint point = CGPointMake(frameInWindow.origin.x + 0.5 * frameInWindow.size.width,
                                frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
    return [self initInView:view at:point tapCount:1];
}

//
// setPhase:
//
// Setter to allow access to the _phase member.
//
- (void)setPhase:(UITouchPhase)phase
{
	_phase = phase;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

//
// setPhase:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
	_previousLocationInWindow = _locationInWindow;
	_locationInWindow = location;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end

//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface GSEventProxy : NSObject
{
@public
	unsigned int flags;
	unsigned int type;
	unsigned int ignored1;
	float x1;
	float y1;
	float x2;
	float y2;
	unsigned int ignored2[10];
	unsigned int ignored3[7];
	float sizeX;
	float sizeY;
	float x3;
	float y3;
	unsigned int ignored4[3];
}
@end
@implementation GSEventProxy
@end

//
// PublicEvent
//
// A dummy class used to gain access to UIEvent's private member variables.
// If UIEvent changes at all, this will break.
//
@interface PublicEvent : NSObject
{
@public
    GSEventProxy           *_event;
    NSTimeInterval          _timestamp;
    NSMutableSet           *_touches;
    CFMutableDictionaryRef  _keyedTouches;
}
@end

@implementation PublicEvent
@end

@interface UIEvent (Creation)

- (id)_initWithEvent:(GSEventProxy *)fp8 touches:(id)fp12;

@end

//
// UIEvent (Synthesize)
//
// A category to allow creation of a touch event.
//
@implementation UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch
{
	CGPoint location = [touch locationInView:touch.window];
	GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
	gsEventProxy->x1 = location.x;
	gsEventProxy->y1 = location.y;
	gsEventProxy->x2 = location.x;
	gsEventProxy->y2 = location.y;
	gsEventProxy->x3 = location.x;
	gsEventProxy->y3 = location.y;
	gsEventProxy->sizeX = 1.0;
	gsEventProxy->sizeY = 1.0;
	gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
	gsEventProxy->type = 3001;	
	
	//
	// On SDK versions 3.0 and greater, we need to reallocate as a
	// UITouchesEvent.
	//
	Class touchesEventClass = NSClassFromString(@"UITouchesEvent");
	if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
	{
		[self release];
		self = [touchesEventClass alloc];
	}
	
	self = [self _initWithEvent:gsEventProxy touches:[NSSet setWithObject:touch]];
	if (self != nil)
	{
	}
	return self;
}

@end

extern UIViewController *UnityGetGLViewController();

extern "C"
{
  extern UIViewController *sGLViewController;

  void CukunityScreenInstantTap(int x, int y, int tapCount)
  {
    UIView *view = UnityGetGLViewController().view;
    UITouch *touch = [[UITouch alloc] initInView:view at:CGPointMake(x, y) tapCount:tapCount];
    UIEvent *eventDown = [[UIEvent alloc] initWithTouch:touch];
     
    [touch.view touchesBegan:[eventDown allTouches] withEvent:eventDown];
     
    [touch setPhase:UITouchPhaseEnded];
    UIEvent *eventUp = [[UIEvent alloc] initWithTouch:touch];
     
    [touch.view touchesEnded:[eventUp allTouches] withEvent:eventUp];
     
    [eventDown release];
    [eventUp release];
    [touch release];
  }
}
