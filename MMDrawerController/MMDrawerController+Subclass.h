//
//  MMDrawerController+Subclass.h
//  MMDrawerControllerKitchenSink
//
//  Created by Lars Anderson on 5/30/13.
//  Copyright (c) 2013 Mutual Mobile. All rights reserved.
//

#import "MMDrawerController.h"

/**
 This class extension is designed for use by subclasses of `MMDrawerController` to customize the functionality to support a specific use-case by a developer. When importing this file, there is no need to also call `#import MMDrawerController.h`.
 
 None of these methods are meant to be called by non-subclasses of `MMDrawerController`.
 */

@interface MMDrawerController ()

/** `MMDrawerController`'s single-tap gesture recognizer callback. This method is called every time the `UITapGestureRecognizer` is triggered.
 
 @param tapGesture The single-tap gesture recognizer instance that triggered the callback
 */
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture __attribute((objc_requires_super));

/** `MMDrawerController`'s pan gesture recognizer callback. This method is called every time the `UIPanGestureRecognizer` is updated.
 
 @warning This method do the minimal amount of work to keep the pan gesture responsive.
 
 @param panGesture The pan gesture recognizer instance that triggered the callback
 */
-(void)panGesture:(UIPanGestureRecognizer *)panGesture __attribute((objc_requires_super));

/**
 Sets the given drawer side's initial presentation conditions including transform, anchor point and alpha.
 */
-(void)resetDrawerVisualStateForDrawerSide:(MMDrawerSide)drawerSide __attribute((objc_requires_super));

/** Sets the initial conditions for `MMDrawerController` and its child view controllers to prepare the drawer for a transition. If a drawer is open and the opposite drawer is being presented, it prepares that drawer to be hidden and vice-versa for the closing drawer.
 
 @param drawer The drawer side that will be presented
 @param animated A boolean that indicates whether the presentation is being animated or not
 */
-(void)prepareToPresentDrawer:(MMDrawerSide)drawer animated:(BOOL)animated __attribute((objc_requires_super));

/** The animation duration for open/close animations with a given distance that a view has to travel.
 
 You can use override this method to provide a custom duration for the open/close animations based on the distance is needs to travel.
 
 @param distance The distance a view has to travel to arrive at its final destination
 */
-(NSTimeInterval)animationDurationForAnimationDistance:(CGFloat)distance;

/** A `UIGestureRecognizerDelegate` method that is queried by `MMDrawerController`'s gestures to determine if it should receive the touch.
 
 @param gestureRecognizer The gesture recognizer that is asking if it should recieve a touch
 @param touch The touch in question in gestureRecognizer.view's coordinate space
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch __attribute((objc_requires_super));

/** Relays willRotateToInterfaceOrientation:duration: to all child view controllers.
 
 @param toInterfaceOrientation The interface orientation that the interface is moving to
 @param duration The duration of the interface orientation animation
 */
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration __attribute((objc_requires_super));

/** Although calling super is marked as required for this method, it is not required if you want to override this method to customize the shadow animation.
 
 @param toInterfaceOrientation The interface orientation that the interface is moving to
 @param duration The duration of the interface orientation animation
 */
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration __attribute((objc_requires_super));

/**
 The panning rect that is set at the beginning of the pan gesture. Refence is supplied here in the instance that you completely override panGesture:.
 */
@property (nonatomic, assign) CGRect startingPanRect;

@end
