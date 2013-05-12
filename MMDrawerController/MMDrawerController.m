// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import <QuartzCore/QuartzCore.h>

CGFloat const MMDrawerDefaultWidth = 280.0f;
CGFloat const MMDrawerDefaultAnimationVelocity = 840.0f;

NSTimeInterval const MMDrawerDefaultFullAnimationDelay = 0.10f;

CGFloat const MMDrawerDefaultBounceDistance = 50.0f;

NSTimeInterval const MMDrawerDefaultBounceAnimationDuration = 0.2f;
CGFloat const MMDrawerDefaultSecondBounceDistancePercentage = .25f;

CGFloat const MMDrawerDefaultShadowRadius = 10.0f;
CGFloat const MMDrawerDefaultShadowOpacity = 0.8;

NSTimeInterval const MMDrawerMinimumAnimationDuration = 0.15f;

CGFloat const MMDrawerBezelRange = 20.0f;

CGFloat const MMDrawerPanVelocityXAnimationThreshold = 100.0f;

/** The amount of overshoot that is panned linearly. The remaining percentage nonlinearly asymptotes to the max percentage. */
CGFloat const MMDrawerOvershootLinearRangePercentage = 0.75f;

/** The percent of the possible overshoot width to use as the actual overshoot percentage. */
CGFloat const MMDrawerOvershootPercentage = 0.1f;

static CAKeyframeAnimation * bounceKeyFrameAnimationForDistanceOnView(CGFloat distance, UIView * view) {
	CGFloat factors[32] = {0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32,
		0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0};
    
	NSMutableArray *values = [NSMutableArray array];
    
	for (int i=0; i<32; i++)
	{
		CGFloat positionOffset = factors[i]/128.0f * distance + CGRectGetMidX(view.bounds);
		[values addObject:@(positionOffset)];
	}
    
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
	animation.repeatCount = 1;
	animation.duration = .8;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES;
	animation.autoreverses = NO;
    
	return animation;
}

@interface MMDrawerController () <UIGestureRecognizerDelegate>{
    CGFloat _maximumRightDrawerWidth;
    CGFloat _maximumLeftDrawerWidth;
}

@property (nonatomic, assign, readwrite) MMDrawerSide openSide;

@property (nonatomic, strong) UIView * centerContainerView;

@property (nonatomic, assign) CGRect startingPanRect;
@property (nonatomic, copy) MMDrawerControllerDrawerVisualStateBlock drawerVisualState;

@end

@implementation MMDrawerController

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController{
    NSParameterAssert(centerViewController);
    self = [self init];
    if(self){

        [self setCenterViewController:centerViewController];
        [self setLeftDrawerViewController:leftDrawerViewController];
        [self setRightDrawerViewController:rightDrawerViewController];
    
        [self setMaximumLeftDrawerWidth:MMDrawerDefaultWidth];
        [self setMaximumRightDrawerWidth:MMDrawerDefaultWidth];
        
        [self setAnimationVelocity:MMDrawerDefaultAnimationVelocity];
        
        [self setShowsShadow:YES];
        [self setShouldStretchDrawer:YES];
        
        [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [self setupGestureRecognizers];
    }
    return self;
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController{
    return [self initWithCenterViewController:centerViewController leftDrawerViewController:leftDrawerViewController rightDrawerViewController:nil];
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController{
    return [self initWithCenterViewController:centerViewController leftDrawerViewController:nil rightDrawerViewController:rightDrawerViewController];
}

#pragma mark - Open/Close methods
-(void)toggleDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL))completion{
    NSParameterAssert(drawerSide!=MMDrawerSideNone);
    if(self.openSide == MMDrawerSideNone){
        [self openDrawerSide:drawerSide animated:animated completion:completion];
    }
    else {
        if((drawerSide == MMDrawerSideLeft &&
           self.openSide == MMDrawerSideLeft) ||
           (drawerSide == MMDrawerSideRight &&
           self.openSide == MMDrawerSideRight)){
            [self closeDrawerAnimated:animated completion:completion];
        }
        else if(completion){
            completion(NO);
        }
    }
}

-(void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion{
    CGRect newFrame = self.view.bounds;
    
    CGFloat distance = ABS(CGRectGetMinX(self.centerContainerView.frame));
    NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
    
    BOOL leftDrawerVisible = CGRectGetMinX(self.centerContainerView.frame) > 0;
    BOOL rightDrawerVisible = CGRectGetMinX(self.centerContainerView.frame) < 0;
    
    MMDrawerSide visibleSide = MMDrawerSideNone;
    CGFloat percentVisble = 0.0;
    
    if(leftDrawerVisible){
        CGFloat visibleDrawerPoints = CGRectGetMinX(self.centerContainerView.frame);
        percentVisble = MAX(0.0,visibleDrawerPoints/self.maximumLeftDrawerWidth);
        visibleSide = MMDrawerSideLeft;
    }
    else if(rightDrawerVisible){
        CGFloat visibleDrawerPoints = CGRectGetWidth(self.centerContainerView.frame)-CGRectGetMaxX(self.centerContainerView.frame);
        percentVisble = MAX(0.0,visibleDrawerPoints/self.maximumRightDrawerWidth);
        visibleSide = MMDrawerSideRight;
    }
    
    [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisble];
    
    [UIView
     animateWithDuration:(animated?duration:0.0)
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         [self.centerContainerView setFrame:newFrame];
         [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:0.0];
     }
     completion:^(BOOL finished) {
         [self setOpenSide:MMDrawerSideNone];         
         [self resetDrawerVisualStateForDrawerSide:visibleSide];
         
         if(completion){
             completion(finished);
         }
     }];
}

-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL))completion{
    NSParameterAssert(drawerSide != MMDrawerSideNone);
    
    UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    CGRect visibleRect = CGRectIntersection(self.view.bounds,sideDrawerViewController.view.frame);
    BOOL drawerFullyCovered = (CGRectContainsRect(self.centerContainerView.frame, visibleRect) ||
                              CGRectIsNull(visibleRect));
    if(drawerFullyCovered){
        [self prepareToPresentDrawer:drawerSide];
    }
    
    if(sideDrawerViewController){
        CGRect newFrame;
        CGRect oldFrame = self.centerContainerView.frame;
        if(drawerSide == MMDrawerSideLeft){
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = self.maximumLeftDrawerWidth;
        }
        else {
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = 0-self.maximumRightDrawerWidth;
        }
        
        CGFloat distance = ABS(CGRectGetMinX(oldFrame)-newFrame.origin.x);
        NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
        
        [UIView
         animateWithDuration:(animated?duration:0.0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newFrame];
             [self updateDrawerVisualStateForDrawerSide:drawerSide percentVisible:1.0];
         }
         completion:^(BOOL finished) {
             if(drawerSide == MMDrawerSideLeft){
                 [self setOpenSide:MMDrawerSideLeft];
             }
             else if(drawerSide == MMDrawerSideRight){
                 [self setOpenSide:MMDrawerSideRight];
             }
             
             [self resetDrawerVisualStateForDrawerSide:drawerSide];
             
             if(completion)
                 completion(finished);
         }];
    }
}

#pragma mark - Updating the Center View Controller
-(void)setCenterViewController:(UIViewController *)newCenterViewController withCloseAnimation:(BOOL)animated completion:(void(^)(BOOL))completion{
    [self setCenterViewController:newCenterViewController];
    
    if(self.openSide != MMDrawerSideNone){
        [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:1.0];
        
        [self
         closeDrawerAnimated:animated
         completion:completion];
    }
    else if(completion) {
        completion(NO);
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)animated completion:(void(^)(BOOL))completion{
    if(self.openSide != MMDrawerSideNone){
        
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:self.openSide];
        
        CGFloat targetClosePoint = 0.0f;
        if(self.openSide == MMDrawerSideRight){
            targetClosePoint = -CGRectGetWidth(self.view.bounds);
        }
        else if(self.openSide == MMDrawerSideLeft) {
            targetClosePoint = CGRectGetWidth(self.view.bounds);
        }
        
        CGFloat distance = ABS(self.centerContainerView.frame.origin.x-targetClosePoint);
        NSTimeInterval firstDuration = [self animationDurationForAnimationDistance:distance];
        
        CGRect newCenterRect = self.centerContainerView.frame;
        newCenterRect.origin.x = targetClosePoint;
        [UIView
         animateWithDuration:firstDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [sideDrawerViewController.view setFrame:self.view.bounds];
         }
         completion:^(BOOL finished) {

             CGRect oldCenterRect = self.centerContainerView.frame;
             [self setCenterViewController:newCenterViewController];
             [self.centerContainerView setFrame:oldCenterRect];
             [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:1.0];
            [UIView
             animateWithDuration:[self animationDurationForAnimationDistance:CGRectGetWidth(self.view.bounds)]
             delay:MMDrawerDefaultFullAnimationDelay
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 [self.centerContainerView setFrame:self.view.bounds];
                 [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:0.0];
             }
             completion:^(BOOL finished) {
                 [self resetDrawerVisualStateForDrawerSide:self.openSide];

                 [sideDrawerViewController.view setFrame:sideDrawerViewController.mm_visibleDrawerFrame];
                 
                 [self setOpenSide:MMDrawerSideNone];
                 
                 if(completion){
                     completion(finished);
                 }
             }];
         }];
    }
    else {
        [self setCenterViewController:newCenterViewController];
    }
}

#pragma mark - Size Methods
-(void)setMaximumLeftDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    NSParameterAssert(width>0);
    
    CGFloat oldWidth = _maximumLeftDrawerWidth;
    _maximumLeftDrawerWidth = width;
    
    CGFloat distance = ABS(width-oldWidth);
    NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
    
    if(self.openSide == MMDrawerSideLeft){
        CGRect newCenterRect = self.centerContainerView.frame;
        newCenterRect.origin.x = self.maximumLeftDrawerWidth;
        [UIView
         animateWithDuration:(animated?duration:0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [self.leftDrawerViewController.view setFrame:self.leftDrawerViewController.mm_visibleDrawerFrame];
         }
         completion:^(BOOL finished) {
             if(completion){
                completion(finished);
             }
         }];
    }
    else{
        [self.leftDrawerViewController.view setFrame:self.leftDrawerViewController.mm_visibleDrawerFrame];
        if(completion){
            completion(YES);
        }
    }
}

-(void)setMaximumRightDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    NSParameterAssert(width>0);
    
    CGFloat oldWidth = _maximumRightDrawerWidth;
    _maximumRightDrawerWidth = width;
    
    CGFloat distance = ABS(width-oldWidth);
    NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
    
    if(self.openSide == MMDrawerSideRight){
        CGRect newCenterRect = self.centerContainerView.frame;
        newCenterRect.origin.x =  0-self.maximumRightDrawerWidth;
        [UIView
         animateWithDuration:(animated?duration:0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [self.rightDrawerViewController.view setFrame:self.rightDrawerViewController.mm_visibleDrawerFrame];
         }
         completion:^(BOOL finished) {
             if(completion)
                 completion(finished);
         }];
    }
    else{
        [self.rightDrawerViewController.view setFrame:self.rightDrawerViewController.mm_visibleDrawerFrame];
        if(completion){
            completion(YES);
        }
    }
}

#pragma mark - Bounce Methods
-(void)bouncePreviewForDrawerSide:(MMDrawerSide)drawerSide completion:(void(^)(BOOL finished))completion{
    NSParameterAssert(drawerSide!=MMDrawerSideNone);
    [self bouncePreviewForDrawerSide:drawerSide distance:MMDrawerDefaultBounceDistance completion:nil];
}

-(void)bouncePreviewForDrawerSide:(MMDrawerSide)drawerSide distance:(CGFloat)distance completion:(void(^)(BOOL finished))completion{
    NSParameterAssert(drawerSide!=MMDrawerSideNone);
    
    UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    
    if(sideDrawerViewController == nil){
        if(completion){
            completion(NO);
        }
        return;
    }
    else {
        [self prepareToPresentDrawer:drawerSide];
        
        [self updateDrawerVisualStateForDrawerSide:drawerSide percentVisible:1.0];
        
        [CATransaction begin];
        [CATransaction
         setCompletionBlock:^{
             if(completion){
                 completion(YES);
             }
         }];
        
        CGFloat modifier = ((drawerSide == MMDrawerSideLeft)?1.0:-1.0);
        CAKeyframeAnimation *animation = bounceKeyFrameAnimationForDistanceOnView(distance*modifier,self.centerContainerView);
        [self.centerContainerView.layer addAnimation:animation forKey:@"bouncing"];
        
        [CATransaction commit];
    }
}

#pragma mark - Setting Drawer Visual State
-(void)setDrawerVisualStateBlock:(void (^)(MMDrawerController *, MMDrawerSide, CGFloat))drawerVisualStateBlock{
    [self setDrawerVisualState:drawerVisualStateBlock];
}

#pragma mark - Subclass Methods
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateShadowForCenterView];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //If a rotation begins, we are going to cancel the current gesture and reset transform and anchor points so everything works correctly
    for(UIGestureRecognizer * gesture in self.view.gestureRecognizers){
        if(gesture.state == UIGestureRecognizerStateChanged){
            [gesture setEnabled:NO];
            [gesture setEnabled:YES];
            [self resetDrawerVisualStateForDrawerSide:self.openSide];
            break;
        }
    }
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //We need to support the shadow path rotation animation
    //Inspired from here: http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing
    if(self.showsShadow){
        CGPathRef oldShadowPath = self.centerContainerView.layer.shadowPath;
        if(oldShadowPath){
            CFRetain(oldShadowPath);
        }
        
        [self updateShadowForCenterView];
        
        if (oldShadowPath) {
            [self.centerContainerView.layer addAnimation:((^ {
                CABasicAnimation *transition = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
                transition.fromValue = (__bridge id)oldShadowPath;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.duration = duration;
                return transition;
            })()) forKey:@"transition"];
            CFRelease(oldShadowPath);
        }
    }
}

#pragma mark - Setters
-(void)setRightDrawerViewController:(UIViewController *)rightDrawerViewController{
    if(_rightDrawerViewController){
        [self.rightDrawerViewController.view removeFromSuperview];
        [self.rightDrawerViewController removeFromParentViewController];
        _rightDrawerViewController = nil;
    }
    
    if(rightDrawerViewController){
        _rightDrawerViewController = rightDrawerViewController;
        [self addChildViewController:self.rightDrawerViewController];
        if(self.openSide == MMDrawerSideRight &&
           [self.view.subviews containsObject:self.centerContainerView]){
            [self.view insertSubview:self.rightDrawerViewController.view belowSubview:self.centerContainerView];
        }
        else{
            [self.view addSubview:self.rightDrawerViewController.view];
            [self.view sendSubviewToBack:self.rightDrawerViewController.view];
            [self.rightDrawerViewController.view setHidden:YES];
        }
        [self.rightDrawerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin];
        [self.rightDrawerViewController.view setFrame:self.rightDrawerViewController.mm_visibleDrawerFrame];
    }
}

-(void)setLeftDrawerViewController:(UIViewController *)leftDrawerViewController{
    if(_leftDrawerViewController){
        [self.leftDrawerViewController.view removeFromSuperview];
        [self.leftDrawerViewController removeFromParentViewController];
        _leftDrawerViewController = nil;
    }
    
    if(leftDrawerViewController){
        _leftDrawerViewController = leftDrawerViewController;
        [self addChildViewController:self.leftDrawerViewController];
        if(self.openSide == MMDrawerSideLeft &&
           [self.view.subviews containsObject:self.centerContainerView]){
            [self.view insertSubview:self.leftDrawerViewController.view belowSubview:self.centerContainerView];
        }
        else{
            [self.view addSubview:self.leftDrawerViewController.view];
            [self.view sendSubviewToBack:self.leftDrawerViewController.view];
            [self.leftDrawerViewController.view setHidden:YES];
        }
        [self.leftDrawerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin];
        [self.leftDrawerViewController.view setFrame:self.leftDrawerViewController.mm_visibleDrawerFrame];
    }
}

-(void)setCenterViewController:(UIViewController *)centerViewController{
    if(_centerContainerView == nil){
        _centerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_centerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_centerContainerView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_centerContainerView];
    }
    
    if(_centerViewController){
        [_centerViewController removeFromParentViewController];
        [_centerViewController.view removeFromSuperview];
    }
    
    _centerViewController = centerViewController;
    
    [self addChildViewController:_centerViewController];
    [_centerViewController.view setFrame:self.view.bounds];
    [self.centerContainerView addSubview:_centerViewController.view];
    [self.view bringSubviewToFront:self.centerContainerView];
    [_centerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self updateShadowForCenterView];
}

-(void)setShowsShadow:(BOOL)showsShadow{
    _showsShadow = showsShadow;
    [self updateShadowForCenterView];
}

-(void)setOpenSide:(MMDrawerSide)openSide{
    if(_openSide != openSide){
        _openSide = openSide;
        [self updateCenterViewUserInteractionState];
        if(openSide == MMDrawerSideNone){
            [self.leftDrawerViewController.view setHidden:YES];
            [self.rightDrawerViewController.view setHidden:YES];
        }
    }
}

-(void)setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionMode)centerHiddenInteractionMode{
    if(_centerHiddenInteractionMode!=centerHiddenInteractionMode){
        _centerHiddenInteractionMode = centerHiddenInteractionMode;
        [self updateCenterViewUserInteractionState];
    }
}

-(void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth{
    [self setMaximumLeftDrawerWidth:maximumLeftDrawerWidth animated:NO completion:nil];
}

-(void)setMaximumRightDrawerWidth:(CGFloat)maximumRightDrawerWidth{
    [self setMaximumRightDrawerWidth:maximumRightDrawerWidth animated:NO completion:nil];
}

#pragma mark - Getters
-(CGFloat)maximumLeftDrawerWidth{
    if(self.leftDrawerViewController){
        return _maximumLeftDrawerWidth;
    }
    else{
        return 0;
    }
}

-(CGFloat)maximumRightDrawerWidth{
    if(self.rightDrawerViewController){
        return _maximumRightDrawerWidth;
    }
    else {
        return 0;
    }
}

-(CGFloat)visibleLeftDrawerWidth{
    return MAX(0.0,CGRectGetMinX(self.centerContainerView.frame));
}

-(CGFloat)visibleRightDrawerWidth{
    if(CGRectGetMinX(self.centerContainerView.frame)<0){
        return CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.centerContainerView.frame);
    }
    else {
        return 0.0f;
    }
}


#pragma mark - Gesture Handlers

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    if(self.openSide != MMDrawerSideNone){
        [self closeDrawerAnimated:YES completion:nil];
    }
}

-(void)panGesture:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.startingPanRect = self.centerContainerView.frame;
        case UIGestureRecognizerStateChanged:{
            CGRect newFrame = self.startingPanRect;
            CGPoint translatedPoint = [panGesture translationInView:self.centerContainerView];
            newFrame.origin.x = [self roundedOriginXForDrawerConstriants:CGRectGetMinX(self.startingPanRect)+translatedPoint.x];
            newFrame = CGRectIntegral(newFrame);
            CGFloat xOffset = newFrame.origin.x;
            
            MMDrawerSide visibleSide = MMDrawerSideNone;
            CGFloat percentVisible = 0.0;
            if(xOffset > 0){
                visibleSide = MMDrawerSideLeft;
                percentVisible = xOffset/self.maximumLeftDrawerWidth;
            }
            else if(xOffset < 0){
                visibleSide = MMDrawerSideRight;
                percentVisible = ABS(xOffset)/self.maximumRightDrawerWidth;
            }
            
            if(self.openSide != visibleSide){
                //Drawer is about to become visible
                [self prepareToPresentDrawer:visibleSide];
                [self setOpenSide:visibleSide];
            }
            else if(visibleSide == MMDrawerSideNone){
                [self setOpenSide:MMDrawerSideNone];
            }
            
            [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisible];
            
            [self.centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.startingPanRect = CGRectNull;
            CGPoint velocity = [panGesture velocityInView:self.view];
            [self finishAnimationForPanGestureWithXVelocity:velocity.x completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Animation helpers
-(void)finishAnimationForPanGestureWithXVelocity:(CGFloat)xVelocity completion:(void(^)(BOOL finished))completion{
    CGFloat currentOriginX = CGRectGetMinX(self.centerContainerView.frame);
    
    if(self.openSide == MMDrawerSideLeft) {
        CGFloat midPoint = self.maximumLeftDrawerWidth / 2.0;
        if(xVelocity > MMDrawerPanVelocityXAnimationThreshold){
            [self openDrawerSide:MMDrawerSideLeft animated:YES completion:completion];
        }
        else if(xVelocity < -MMDrawerPanVelocityXAnimationThreshold){
            [self closeDrawerAnimated:YES completion:completion];
        }
        else if(currentOriginX < midPoint){
            [self closeDrawerAnimated:YES completion:completion];
        }
        else {
            [self openDrawerSide:MMDrawerSideLeft animated:YES completion:completion];
        }
    }
    else if(self.openSide == MMDrawerSideRight){
        currentOriginX = CGRectGetMaxX(self.centerContainerView.frame);
        CGFloat midPoint = (CGRectGetWidth(self.view.bounds)-self.maximumRightDrawerWidth) + (self.maximumRightDrawerWidth / 2.0);
        if(xVelocity > MMDrawerPanVelocityXAnimationThreshold){
            [self closeDrawerAnimated:YES completion:completion];
        }
        else if (xVelocity < -MMDrawerPanVelocityXAnimationThreshold){
            [self openDrawerSide:MMDrawerSideRight animated:YES completion:completion];
        }
        else if(currentOriginX > midPoint){
            [self closeDrawerAnimated:YES completion:completion];
        }
        else {
            [self openDrawerSide:MMDrawerSideRight animated:YES completion:completion];
        }
    }
}

-(void)updateDrawerVisualStateForDrawerSide:(MMDrawerSide)drawerSide percentVisible:(CGFloat)percentVisible{
    if(self.drawerVisualState){
        self.drawerVisualState(self,drawerSide,percentVisible);
    }
    else if(self.shouldStretchDrawer){
        [self applyOvershootScaleTransformForDrawerSide:drawerSide percentVisible:percentVisible];
    }
}

- (void)applyOvershootScaleTransformForDrawerSide:(MMDrawerSide)drawerSide percentVisible:(CGFloat)percentVisible{
    
    if (percentVisible >= 1.f) {
        CATransform3D transform;
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
        if(drawerSide == MMDrawerSideLeft) {
            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            transform = CATransform3DTranslate(transform, self.maximumLeftDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
        }
        else if(drawerSide == MMDrawerSideRight){
            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            transform = CATransform3DTranslate(transform, -self.maximumRightDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
        }
        sideDrawerViewController.view.layer.transform = transform;
    }
}

-(void)resetDrawerVisualStateForDrawerSide:(MMDrawerSide)drawerSide{
    UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    
    [sideDrawerViewController.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [sideDrawerViewController.view.layer setTransform:CATransform3DIdentity];
    [sideDrawerViewController.view setAlpha:1.0];
}

-(CGFloat)roundedOriginXForDrawerConstriants:(CGFloat)originX{
    
    if (originX < -self.maximumRightDrawerWidth) {
        if (self.shouldStretchDrawer &&
            self.rightDrawerViewController) {
            CGFloat maxOvershoot = (CGRectGetWidth(self.centerContainerView.frame)-self.maximumRightDrawerWidth)*MMDrawerOvershootPercentage;
            return originXForDrawerOriginAndTargetOriginOffset(originX, -self.maximumRightDrawerWidth, maxOvershoot);
        }
        else{
            return -self.maximumRightDrawerWidth;
        }
    }
    else if(originX > self.maximumLeftDrawerWidth){
        if (self.shouldStretchDrawer &&
            self.leftDrawerViewController) {
            CGFloat maxOvershoot = (CGRectGetWidth(self.centerContainerView.frame)-self.maximumLeftDrawerWidth)*MMDrawerOvershootPercentage;
            return originXForDrawerOriginAndTargetOriginOffset(originX, self.maximumLeftDrawerWidth, maxOvershoot);
        }
        else{
            return self.maximumLeftDrawerWidth;
        }
    }
    
    return originX;
}

static inline CGFloat originXForDrawerOriginAndTargetOriginOffset(CGFloat originX, CGFloat targetOffset, CGFloat maxOvershoot){
    CGFloat delta = ABS(originX - targetOffset);
    CGFloat maxLinearPercentage = MMDrawerOvershootLinearRangePercentage;
    CGFloat nonLinearRange = maxOvershoot * maxLinearPercentage;
    CGFloat nonLinearScalingDelta = (delta - nonLinearRange);
    CGFloat overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange/sqrt(pow(nonLinearScalingDelta,2.f) + 15000);
    
    if (delta < nonLinearRange) {
        return originX;
    }
    else if (targetOffset < 0) {
        return targetOffset - round(overshoot);
    }
    else{
        return targetOffset + round(overshoot);
    }
}

#pragma mark - Helpers
-(void)setupGestureRecognizers{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

-(void)prepareToPresentDrawer:(MMDrawerSide)drawer{
    MMDrawerSide drawerToHide = MMDrawerSideNone;
    if(drawer == MMDrawerSideLeft){
        drawerToHide = MMDrawerSideRight;
    }
    else if(drawer == MMDrawerSideRight){
        drawerToHide = MMDrawerSideLeft;
    }
    
    UIViewController * sideDrawerViewControllerToPresent = [self sideDrawerViewControllerForSide:drawer];
    UIViewController * sideDrawerViewControllerToHide = [self sideDrawerViewControllerForSide:drawerToHide];

    [self.view sendSubviewToBack:sideDrawerViewControllerToHide.view];
    [sideDrawerViewControllerToHide.view setHidden:YES];
    [sideDrawerViewControllerToPresent.view setHidden:NO];
    [self resetDrawerVisualStateForDrawerSide:drawer];
    [sideDrawerViewControllerToPresent.view setFrame:sideDrawerViewControllerToPresent.mm_visibleDrawerFrame];
    [self updateDrawerVisualStateForDrawerSide:drawer percentVisible:0.0];
    [sideDrawerViewControllerToPresent mm_drawerWillAppear];
}

-(void)updateShadowForCenterView{
    UIView * centerView = self.centerContainerView;
    if(self.showsShadow){
        centerView.layer.masksToBounds = NO;
        centerView.layer.shadowRadius = MMDrawerDefaultShadowRadius;
        centerView.layer.shadowOpacity = MMDrawerDefaultShadowOpacity;
        centerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.centerContainerView.bounds] CGPath];
    }
    else {
        centerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectNull].CGPath;
    }
}

-(void)updateCenterViewUserInteractionState{
    UINavigationBar * navBar = nil;
    UIView * centerContentView = nil;
    if([self.centerViewController isKindOfClass:[UINavigationController class]]){
        navBar = [(UINavigationController*)self.centerViewController navigationBar];
        centerContentView = [[(UINavigationController*)self.centerViewController topViewController] view];
    }
    else {
        centerContentView = self.centerViewController.view;
    }
    
    if(self.openSide != MMDrawerSideNone){
        switch (self.centerHiddenInteractionMode) {
            case MMDrawerOpenCenterInteractionModeNone:
                [navBar setUserInteractionEnabled:NO];
                [centerContentView setUserInteractionEnabled:NO];
                break;
            case MMDrawerOpenCenterInteractionModeNavigationBarOnly:
                [navBar setUserInteractionEnabled:YES];
                [centerContentView setUserInteractionEnabled:NO];
                break;
                
            case MMDrawerOpenCenterInteractionModeFull:
                [navBar setUserInteractionEnabled:YES];
                [centerContentView setUserInteractionEnabled:YES];
            default:
                break;
        }
    }
    else {
        [navBar setUserInteractionEnabled:YES];
        [centerContentView setUserInteractionEnabled:YES];
    }
}

-(NSTimeInterval)animationDurationForAnimationDistance:(CGFloat)distance{
    NSTimeInterval duration = MAX(distance/self.animationVelocity,MMDrawerMinimumAnimationDuration);
    return duration;
}

-(UIViewController*)sideDrawerViewControllerForSide:(MMDrawerSide)drawerSide{
    UIViewController * sideDrawerViewController = nil;
    if(drawerSide == MMDrawerSideLeft){
        sideDrawerViewController = self.leftDrawerViewController;
    }
    else if(drawerSide == MMDrawerSideRight){
        sideDrawerViewController = self.rightDrawerViewController;
    }
    return sideDrawerViewController;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    
    if(self.openSide == MMDrawerSideNone){
        MMOpenDrawerGestureMode possibleOpenGestureModes = [self possibleOpenGestureModesForGestureRecognizer:gestureRecognizer
                                                                                               withTouchPoint:point];
        return ((self.openDrawerGestureModeMask & possibleOpenGestureModes)>0);
    }
    else{
        MMCloseDrawerGestureMode possibleCloseGestureModes = [self possibleCloseGestureModesForGestureRecognizer:gestureRecognizer
                                                                                                  withTouchPoint:point];
        return ((self.closeDrawerGestureModeMask & possibleCloseGestureModes)>0);
    }
}

#pragma mark Gesture Recogizner Delegate Helpers
-(MMCloseDrawerGestureMode)possibleCloseGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point{
    MMCloseDrawerGestureMode possibleCloseGestureModes = MMCloseDrawerGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeTapNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeTapCenterView;
        }
    }
    else if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleCloseGestureModes |= MMCloseDrawerGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleCloseGestureModes |= MMCloseDrawerGestureModePanningCenterView;
        }
        if([self isPointContainedWithinBezelRect:point]){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithinCenterViewContentRect:point] == NO &&
           [self isPointContainedWithinNavigationRect:point] == NO){
            possibleCloseGestureModes |= MMCloseDrawerGestureModePanningDrawerView;
        }
    }
    return possibleCloseGestureModes;
}

-(MMOpenDrawerGestureMode)possibleOpenGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point{
    MMOpenDrawerGestureMode possibleOpenGestureModes = MMOpenDrawerGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleOpenGestureModes |= MMOpenDrawerGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleOpenGestureModes |= MMOpenDrawerGestureModePanningCenterView;
        }
        if([self isPointContainedWithinBezelRect:point]){
            possibleOpenGestureModes |= MMOpenDrawerGestureModeBezelPanningCenterView;
        }
    }
    return possibleOpenGestureModes;
}


-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point{
    CGRect navigationBarRect = CGRectNull;
    if([self.centerViewController isKindOfClass:[UINavigationController class]]){
        UINavigationBar * navBar = [(UINavigationController*)self.centerViewController navigationBar];
        navigationBarRect = [navBar convertRect:navBar.frame toView:self.view];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.view.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinCenterViewContentRect:(CGPoint)point{
    CGRect centerViewContentRect = self.centerContainerView.frame;
    centerViewContentRect = CGRectIntersection(centerViewContentRect,self.view.bounds);
    return (CGRectContainsPoint(centerViewContentRect, point) &&
            [self isPointContainedWithinNavigationRect:point] == NO);
}

-(BOOL)isPointContainedWithinBezelRect:(CGPoint)point{
    CGRect leftBezelRect;
    CGRect tempRect;
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, MMDrawerBezelRange, CGRectMinXEdge);
    
    CGRect rightBezelRect;
    CGRectDivide(self.view.bounds, &rightBezelRect, &tempRect, MMDrawerBezelRange, CGRectMaxXEdge);
    
    return ((CGRectContainsPoint(leftBezelRect, point) ||
      CGRectContainsPoint(rightBezelRect, point)) &&
     [self isPointContainedWithinCenterViewContentRect:point]);
}

@end
