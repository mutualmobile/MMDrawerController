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

CGFloat const MMDrawerPanVelocityXAnimationThreshold = 200.0f;

/** The amount of overshoot that is panned linearly. The remaining percentage nonlinearly asymptotes to the max percentage. */
CGFloat const MMDrawerOvershootLinearRangePercentage = 0.75f;

/** The percent of the possible overshoot width to use as the actual overshoot percentage. */
CGFloat const MMDrawerOvershootPercentage = 0.1f;

typedef BOOL (^MMDrawerGestureShouldRecognizeTouchBlock)(MMDrawerController * drawerController, UIGestureRecognizer * gesture, UITouch * touch);
typedef void (^MMDrawerGestureCompletionBlock)(MMDrawerController * drawerController, UIGestureRecognizer * gesture);

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

static NSString *MMDrawerLeftDrawerKey = @"MMDrawerLeftDrawer";
static NSString *MMDrawerRightDrawerKey = @"MMDrawerRightDrawer";
static NSString *MMDrawerCenterKey = @"MMDrawerCenter";
static NSString *MMDrawerOpenSideKey = @"MMDrawerOpenSide";

@interface MMDrawerCenterContainerView : UIView
@property (nonatomic,assign) MMDrawerOpenCenterInteractionMode centerInteractionMode;
@property (nonatomic,assign) MMDrawerSide openSide;
@end

@implementation MMDrawerCenterContainerView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView &&
       self.openSide != MMDrawerSideNone){
        UINavigationBar * navBar = [self navigationBarContainedWithinSubviewsOfView:self];
        CGRect navBarFrame = [navBar convertRect:navBar.frame toView:self];
        if((self.centerInteractionMode == MMDrawerOpenCenterInteractionModeNavigationBarOnly &&
           CGRectContainsPoint(navBarFrame, point) == NO) ||
           self.centerInteractionMode == MMDrawerOpenCenterInteractionModeNone){
            hitView = nil;
        }
    }
    return hitView;
}

-(UINavigationBar*)navigationBarContainedWithinSubviewsOfView:(UIView*)view{
    UINavigationBar * navBar = nil;
    for(UIView * subview in [view subviews]){
        if([view isKindOfClass:[UINavigationBar class]]){
            navBar = (UINavigationBar*)view;
            break;
        }
        else {
            navBar = [self navigationBarContainedWithinSubviewsOfView:subview];
            if (navBar != nil) {
                break;
            }
        }
    }
    return navBar;
}
@end

@interface MMDrawerController () <UIGestureRecognizerDelegate>{
    CGFloat _maximumRightDrawerWidth;
    CGFloat _maximumLeftDrawerWidth;
    UIColor * _statusBarViewBackgroundColor;
}

@property (nonatomic, assign, readwrite) MMDrawerSide openSide;

@property (nonatomic, strong) UIView * childControllerContainerView;
@property (nonatomic, strong) MMDrawerCenterContainerView * centerContainerView;
@property (nonatomic, strong) UIView * dummyStatusBarView;

@property (nonatomic, assign) CGRect startingPanRect;
@property (nonatomic, copy) MMDrawerControllerDrawerVisualStateBlock drawerVisualState;
@property (nonatomic, copy) MMDrawerGestureShouldRecognizeTouchBlock gestureShouldRecognizeTouch;
@property (nonatomic, copy) MMDrawerGestureCompletionBlock gestureCompletion;
@property (nonatomic, assign, getter = isAnimatingDrawer) BOOL animatingDrawer;

@end

@implementation MMDrawerController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        [self commonSetup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self) {
        [self commonSetup];
	}
	return self;
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController{
    NSParameterAssert(centerViewController);
    self = [super init];
    if(self){
        [self setCenterViewController:centerViewController];
        [self setLeftDrawerViewController:leftDrawerViewController];
        [self setRightDrawerViewController:rightDrawerViewController];
    }
    return self;
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController{
    return [self initWithCenterViewController:centerViewController leftDrawerViewController:leftDrawerViewController rightDrawerViewController:nil];
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController{
    return [self initWithCenterViewController:centerViewController leftDrawerViewController:nil rightDrawerViewController:rightDrawerViewController];
}

-(void)commonSetup{
    [self setMaximumLeftDrawerWidth:MMDrawerDefaultWidth];
    [self setMaximumRightDrawerWidth:MMDrawerDefaultWidth];
    
    [self setAnimationVelocity:MMDrawerDefaultAnimationVelocity];
    
    [self setShowsShadow:YES];
    [self setShouldStretchDrawer:YES];
    
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
}

#pragma mark - State Restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
    if (self.leftDrawerViewController){
        [coder encodeObject:self.leftDrawerViewController forKey:MMDrawerLeftDrawerKey];
    }

    if (self.rightDrawerViewController){
        [coder encodeObject:self.rightDrawerViewController forKey:MMDrawerRightDrawerKey];
    }

    if (self.centerViewController){
        [coder encodeObject:self.centerViewController forKey:MMDrawerCenterKey];
    }

    [coder encodeInteger:self.openSide forKey:MMDrawerOpenSideKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    UIViewController *controller;
    MMDrawerSide openside;

    [super decodeRestorableStateWithCoder:coder];
    
    if ((controller = [coder decodeObjectForKey:MMDrawerLeftDrawerKey])){
        self.leftDrawerViewController = [coder decodeObjectForKey:MMDrawerLeftDrawerKey];
    }

    if ((controller = [coder decodeObjectForKey:MMDrawerRightDrawerKey])){
        self.rightDrawerViewController = controller;
    }

    if ((controller = [coder decodeObjectForKey:MMDrawerCenterKey])){
        self.centerViewController = controller;
    }

    if ((openside = [coder decodeIntegerForKey:MMDrawerOpenSideKey])){
        [self openDrawerSide:openside animated:false completion:nil];
    }
}
#pragma mark - Open/Close methods
-(void)toggleDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
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

-(void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    [self closeDrawerAnimated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

-(void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion{
    if(self.isAnimatingDrawer){
        if(completion){
            completion(NO);
        }
    }
    else {
        [self setAnimatingDrawer:animated];
        CGRect newFrame = self.childControllerContainerView.bounds;
        
        CGFloat distance = ABS(CGRectGetMinX(self.centerContainerView.frame));
        NSTimeInterval duration = MAX(distance/ABS(velocity),MMDrawerMinimumAnimationDuration);
        
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
        
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:visibleSide];
        
        [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisble];
        
        [sideDrawerViewController beginAppearanceTransition:NO animated:animated];
        
        [UIView
         animateWithDuration:(animated?duration:0.0)
         delay:0.0
         options:options
         animations:^{
             [self setNeedsStatusBarAppearanceUpdateIfSupported];
             [self.centerContainerView setFrame:newFrame];
             [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:0.0];
         }
         completion:^(BOOL finished) {
             [sideDrawerViewController endAppearanceTransition];
             [self setOpenSide:MMDrawerSideNone];
             [self resetDrawerVisualStateForDrawerSide:visibleSide];
             [self setAnimatingDrawer:NO];
             if(completion){
                 completion(finished);
             }
         }];
    }
}

-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    NSParameterAssert(drawerSide != MMDrawerSideNone);
    
    [self openDrawerSide:drawerSide animated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion{
    NSParameterAssert(drawerSide != MMDrawerSideNone);
    if (self.isAnimatingDrawer) {
        if(completion){
            completion(NO);
        }
    }
    else {
        [self setAnimatingDrawer:animated];
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
        CGRect visibleRect = CGRectIntersection(self.childControllerContainerView.bounds,sideDrawerViewController.view.frame);
        BOOL drawerFullyCovered = (CGRectContainsRect(self.centerContainerView.frame, visibleRect) ||
                                   CGRectIsNull(visibleRect));
        if(drawerFullyCovered){
            [self prepareToPresentDrawer:drawerSide animated:animated];
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
            NSTimeInterval duration = MAX(distance/ABS(velocity),MMDrawerMinimumAnimationDuration);
            
            [UIView
             animateWithDuration:(animated?duration:0.0)
             delay:0.0
             options:options
             animations:^{
                 [self setNeedsStatusBarAppearanceUpdateIfSupported];
                 [self.centerContainerView setFrame:newFrame];
                 [self updateDrawerVisualStateForDrawerSide:drawerSide percentVisible:1.0];
             }
             completion:^(BOOL finished) {
                 //End the appearance transition if it already wasn't open.
                 if(drawerSide != self.openSide){
                     [sideDrawerViewController endAppearanceTransition];
                 }
                 [self setOpenSide:drawerSide];
                 
                 [self resetDrawerVisualStateForDrawerSide:drawerSide];
                 [self setAnimatingDrawer:NO];
                 if(completion){
                     completion(finished);
                 }
             }];
        }
    }
}

#pragma mark - Updating the Center View Controller
-(void)setCenterViewController:(UIViewController *)centerViewController animated:(BOOL)animated{
    if(_centerContainerView == nil){
        _centerContainerView = [[MMDrawerCenterContainerView alloc] initWithFrame:self.childControllerContainerView.bounds];
        [self.centerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.centerContainerView setBackgroundColor:[UIColor clearColor]];
        [self.centerContainerView setOpenSide:self.openSide];
        [self.centerContainerView setCenterInteractionMode:self.centerHiddenInteractionMode];
        [self.childControllerContainerView addSubview:self.centerContainerView];
    }
    
    UIViewController * oldCenterViewController = self.centerViewController;
    if(oldCenterViewController){
        if(animated == NO){
            [oldCenterViewController beginAppearanceTransition:NO animated:NO];
        }
        [oldCenterViewController removeFromParentViewController];
        [oldCenterViewController.view removeFromSuperview];
        if(animated == NO){
            [oldCenterViewController endAppearanceTransition];
        }
    }
    
    _centerViewController = centerViewController;
    
    [self addChildViewController:self.centerViewController];
    [self.centerViewController.view setFrame:self.childControllerContainerView.bounds];
    [self.centerContainerView addSubview:self.centerViewController.view];
    [self.childControllerContainerView bringSubviewToFront:self.centerContainerView];
    [self.centerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self updateShadowForCenterView];
    
    if(animated == NO){
        [self.centerViewController beginAppearanceTransition:YES animated:NO];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController didMoveToParentViewController:self];
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withCloseAnimation:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    [self setCenterViewController:newCenterViewController animated:animated];
    
    if(self.openSide != MMDrawerSideNone){
        [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:1.0];
        [self.centerViewController beginAppearanceTransition:YES animated:animated];
        [self
         closeDrawerAnimated:animated
         completion:^(BOOL finished) {
             [self.centerViewController endAppearanceTransition];
             [self.centerViewController didMoveToParentViewController:self];
             if(completion){
                 completion(finished);
             }
         }];
    }
    else {
        [self.centerViewController beginAppearanceTransition:YES animated:NO];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController didMoveToParentViewController:self];
        if(completion) {
            completion(NO);
        }
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    if(self.openSide != MMDrawerSideNone &&
       animated){
        
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:self.openSide];
        
        CGFloat targetClosePoint = 0.0f;
        if(self.openSide == MMDrawerSideRight){
            targetClosePoint = -CGRectGetWidth(self.childControllerContainerView.bounds);
        }
        else if(self.openSide == MMDrawerSideLeft) {
            targetClosePoint = CGRectGetWidth(self.childControllerContainerView.bounds);
        }
        
        CGFloat distance = ABS(self.centerContainerView.frame.origin.x-targetClosePoint);
        NSTimeInterval firstDuration = [self animationDurationForAnimationDistance:distance];
        
        CGRect newCenterRect = self.centerContainerView.frame;
        
        UIViewController * oldCenterViewController = self.centerViewController;
        [oldCenterViewController beginAppearanceTransition:NO animated:animated];
        newCenterRect.origin.x = targetClosePoint;
        [UIView
         animateWithDuration:firstDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [sideDrawerViewController.view setFrame:self.childControllerContainerView.bounds];
         }
         completion:^(BOOL finished) {

             CGRect oldCenterRect = self.centerContainerView.frame;
             [self setCenterViewController:newCenterViewController animated:animated];
             [oldCenterViewController endAppearanceTransition];
             [self.centerContainerView setFrame:oldCenterRect];
             [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:1.0];
             [self.centerViewController beginAppearanceTransition:YES animated:animated];
             [sideDrawerViewController beginAppearanceTransition:NO animated:animated];
            [UIView
             animateWithDuration:[self animationDurationForAnimationDistance:CGRectGetWidth(self.childControllerContainerView.bounds)]
             delay:MMDrawerDefaultFullAnimationDelay
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 [self.centerContainerView setFrame:self.childControllerContainerView.bounds];
                 [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:0.0];
             }
             completion:^(BOOL finished) {
                 [self.centerViewController endAppearanceTransition];
                 [self.centerViewController didMoveToParentViewController:self];
                 [sideDrawerViewController endAppearanceTransition];
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
        [self setCenterViewController:newCenterViewController animated:animated];
        if(self.openSide != MMDrawerSideNone){
            [self closeDrawerAnimated:animated completion:completion];
        }
    }
}

#pragma mark - Size Methods
-(void)setMaximumLeftDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    [self setMaximumDrawerWidth:width forSide:MMDrawerSideLeft animated:animated completion:completion];
}

-(void)setMaximumRightDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    [self setMaximumDrawerWidth:width forSide:MMDrawerSideRight animated:animated completion:completion];
}

- (void)setMaximumDrawerWidth:(CGFloat)width forSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    NSParameterAssert(width > 0);
    NSParameterAssert(drawerSide != MMDrawerSideNone);
    
    UIViewController *sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    CGFloat oldWidth = 0.f;
    NSInteger drawerSideOriginCorrection = 1;
    if (drawerSide == MMDrawerSideLeft) {
        oldWidth = _maximumLeftDrawerWidth;
        _maximumLeftDrawerWidth = width;
    }
    else if(drawerSide == MMDrawerSideRight){
        oldWidth = _maximumRightDrawerWidth;
        _maximumRightDrawerWidth = width;
        drawerSideOriginCorrection = -1;
    }
    
    CGFloat distance = ABS(width-oldWidth);
    NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
    
    if(self.openSide == drawerSide){
        CGRect newCenterRect = self.centerContainerView.frame;
        newCenterRect.origin.x =  drawerSideOriginCorrection*width;
        [UIView
         animateWithDuration:(animated?duration:0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [sideDrawerViewController.view setFrame:sideDrawerViewController.mm_visibleDrawerFrame];
         }
         completion:^(BOOL finished) {
             if(completion != nil){
                 completion(finished);
             }
         }];
    }
    else{
        [sideDrawerViewController.view setFrame:sideDrawerViewController.mm_visibleDrawerFrame];
        if(completion != nil){
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
    
    if(sideDrawerViewController == nil ||
       self.openSide != MMDrawerSideNone){
        if(completion){
            completion(NO);
        }
        return;
    }
    else {
        [self prepareToPresentDrawer:drawerSide animated:YES];
        
        [self updateDrawerVisualStateForDrawerSide:drawerSide percentVisible:1.0];
        
        [CATransaction begin];
        [CATransaction
         setCompletionBlock:^{
             [sideDrawerViewController endAppearanceTransition];
             [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
             [sideDrawerViewController endAppearanceTransition];
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

#pragma mark - Setting Custom Gesture Handler Block
-(void)setGestureShouldRecognizeTouchBlock:(BOOL (^)(MMDrawerController *, UIGestureRecognizer *, UITouch *))gestureShouldRecognizeTouchBlock{
    [self setGestureShouldRecognizeTouch:gestureShouldRecognizeTouchBlock];
}

#pragma mark - Setting the Gesture Completion Block
-(void)setGestureCompletionBlock:(void (^)(MMDrawerController *, UIGestureRecognizer *))gestureCompletionBlock{
    [self setGestureCompletion:gestureCompletionBlock];
}

#pragma mark - Subclass Methods
-(BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

-(BOOL)shouldAutomaticallyForwardRotationMethods{
    return NO;
}

-(BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return NO;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.childControllerContainerView setBackgroundColor:[UIColor blackColor]];

	[self setupGestureRecognizers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.centerViewController beginAppearanceTransition:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateShadowForCenterView];
    [self.centerViewController endAppearanceTransition];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.centerViewController beginAppearanceTransition:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.centerViewController endAppearanceTransition];
}

#pragma mark Rotation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //If a rotation begins, we are going to cancel the current gesture and reset transform and anchor points so everything works correctly
    for(UIGestureRecognizer * gesture in self.childControllerContainerView.gestureRecognizers){
        if(gesture.state == UIGestureRecognizerStateChanged){
            [gesture setEnabled:NO];
            [gesture setEnabled:YES];
            [self resetDrawerVisualStateForDrawerSide:self.openSide];
            break;
        }
    }
    for(UIViewController * childViewController in self.childViewControllers){
        [childViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
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
    for(UIViewController * childViewController in self.childViewControllers){
        [childViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    for(UIViewController * childViewController in self.childViewControllers){
        [childViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

#pragma mark - Setters
-(void)setRightDrawerViewController:(UIViewController *)rightDrawerViewController{
    [self setDrawerViewController:rightDrawerViewController forSide:MMDrawerSideRight];
}

-(void)setLeftDrawerViewController:(UIViewController *)leftDrawerViewController{
    [self setDrawerViewController:leftDrawerViewController forSide:MMDrawerSideLeft];
}

- (void)setDrawerViewController:(UIViewController *)viewController forSide:(MMDrawerSide)drawerSide{
    NSParameterAssert(drawerSide != MMDrawerSideNone);
    
    UIViewController *currentSideViewController = [self sideDrawerViewControllerForSide:drawerSide];
    if (currentSideViewController != nil) {
        [currentSideViewController beginAppearanceTransition:NO animated:NO];
        [currentSideViewController.view removeFromSuperview];
        [currentSideViewController endAppearanceTransition];
        [currentSideViewController removeFromParentViewController];
    }
    
    UIViewAutoresizing autoResizingMask = 0;
    if (drawerSide == MMDrawerSideLeft) {
        _leftDrawerViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        
    }
    else if(drawerSide == MMDrawerSideRight){
        _rightDrawerViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    }
    
    if(viewController){
        [self addChildViewController:viewController];
        
        if((self.openSide == drawerSide) &&
           [self.childControllerContainerView.subviews containsObject:self.centerContainerView]){
            [self.childControllerContainerView insertSubview:viewController.view belowSubview:self.centerContainerView];
            [viewController beginAppearanceTransition:YES animated:NO];
            [viewController endAppearanceTransition];
        }
        else{
            [self.childControllerContainerView addSubview:viewController.view];
            [self.childControllerContainerView sendSubviewToBack:viewController.view];
            [viewController.view setHidden:YES];
        }
        [viewController didMoveToParentViewController:self];
        [viewController.view setAutoresizingMask:autoResizingMask];
        [viewController.view setFrame:viewController.mm_visibleDrawerFrame];
    }
}

-(void)setCenterViewController:(UIViewController *)centerViewController{
    [self setCenterViewController:centerViewController animated:NO];
}

-(void)setShowsShadow:(BOOL)showsShadow{
    _showsShadow = showsShadow;
    [self updateShadowForCenterView];
}

-(void)setOpenSide:(MMDrawerSide)openSide{
    if(_openSide != openSide){
        _openSide = openSide;
        [self.centerContainerView setOpenSide:openSide];
        if(openSide == MMDrawerSideNone){
            [self.leftDrawerViewController.view setHidden:YES];
            [self.rightDrawerViewController.view setHidden:YES];
        }
        [self setNeedsStatusBarAppearanceUpdateIfSupported];
    }
}

-(void)setCenterHiddenInteractionMode:(MMDrawerOpenCenterInteractionMode)centerHiddenInteractionMode{
    if(_centerHiddenInteractionMode!=centerHiddenInteractionMode){
        _centerHiddenInteractionMode = centerHiddenInteractionMode;
        [self.centerContainerView setCenterInteractionMode:centerHiddenInteractionMode];
    }
}

-(void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth{
    [self setMaximumLeftDrawerWidth:maximumLeftDrawerWidth animated:NO completion:nil];
}

-(void)setMaximumRightDrawerWidth:(CGFloat)maximumRightDrawerWidth{
    [self setMaximumRightDrawerWidth:maximumRightDrawerWidth animated:NO completion:nil];
}

-(void)setShowsStatusBarBackgroundView:(BOOL)showsDummyStatusBar{
    NSArray *sysVersion = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    float majorVersion = [[sysVersion objectAtIndex:0] floatValue];
    if (majorVersion >= 7){
        if(showsDummyStatusBar!=_showsStatusBarBackgroundView){
            _showsStatusBarBackgroundView = showsDummyStatusBar;
            CGRect frame = self.childControllerContainerView.frame;
            if(_showsStatusBarBackgroundView){
                frame.origin.y = 20;
                frame.size.height = CGRectGetHeight(self.view.bounds)-20;
            }
            else {
                frame.origin.y = 0;
                frame.size.height = CGRectGetHeight(self.view.bounds);
            }
            [self.childControllerContainerView setFrame:frame];
            [self.dummyStatusBarView setHidden:!showsDummyStatusBar];
        }
    }
    else {
        _showsStatusBarBackgroundView = NO;
    }
}

-(void)setStatusBarViewBackgroundColor:(UIColor *)dummyStatusBarColor{
    _statusBarViewBackgroundColor = dummyStatusBarColor;
    [self.dummyStatusBarView setBackgroundColor:_statusBarViewBackgroundColor];
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
        return CGRectGetWidth(self.childControllerContainerView.bounds)-CGRectGetMaxX(self.centerContainerView.frame);
    }
    else {
        return 0.0f;
    }
}

-(UIView*)childControllerContainerView{
    if(_childControllerContainerView == nil){
        _childControllerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_childControllerContainerView setBackgroundColor:[UIColor clearColor]];
        [_childControllerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:_childControllerContainerView];
    }
    return _childControllerContainerView;
}

-(UIView*)dummyStatusBarView{
    if(_dummyStatusBarView==nil){
        _dummyStatusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20)];
        [_dummyStatusBarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_dummyStatusBarView setBackgroundColor:self.statusBarViewBackgroundColor];
        [_dummyStatusBarView setHidden:!_showsStatusBarBackgroundView];
        [self.view addSubview:_dummyStatusBarView];
    }
    return _dummyStatusBarView;
}

-(UIColor*)statusBarViewBackgroundColor{
    if(_statusBarViewBackgroundColor == nil){
        _statusBarViewBackgroundColor = [UIColor blackColor];
    }
    return _statusBarViewBackgroundColor;
}

#pragma mark - Gesture Handlers

-(void)tapGestureCallback:(UITapGestureRecognizer *)tapGesture{
    if(self.openSide != MMDrawerSideNone){
        [self closeDrawerAnimated:YES completion:^(BOOL finished) {
            if(self.gestureCompletion){
                self.gestureCompletion(self, tapGesture);
            }
        }];
    }
}

-(void)panGestureCallback:(UIPanGestureRecognizer *)panGesture{
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
            UIViewController * visibleSideDrawerViewController = [self sideDrawerViewControllerForSide:visibleSide];
            
            if(self.openSide != visibleSide){
                //Handle disappearing the visible drawer
                UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:self.openSide];
                [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
                [sideDrawerViewController endAppearanceTransition];

                //Drawer is about to become visible
                [self prepareToPresentDrawer:visibleSide animated:NO];
                [visibleSideDrawerViewController endAppearanceTransition];
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
            CGPoint velocity = [panGesture velocityInView:self.childControllerContainerView];
            [self finishAnimationForPanGestureWithXVelocity:velocity.x completion:^(BOOL finished) {
                if(self.gestureCompletion){
                    self.gestureCompletion(self, panGesture);
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - iOS 7 Status Bar Helpers
-(UIViewController*)childViewControllerForStatusBarStyle{
    return [self childViewControllerForSide:self.openSide];
}

-(UIViewController*)childViewControllerForStatusBarHidden{
    return [self childViewControllerForSide:self.openSide];
}

-(void)setNeedsStatusBarAppearanceUpdateIfSupported{
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

#pragma mark - Animation helpers
-(void)finishAnimationForPanGestureWithXVelocity:(CGFloat)xVelocity completion:(void(^)(BOOL finished))completion{
    CGFloat currentOriginX = CGRectGetMinX(self.centerContainerView.frame);
    
    CGFloat animationVelocity = MAX(ABS(xVelocity),MMDrawerPanVelocityXAnimationThreshold*2);
    
    if(self.openSide == MMDrawerSideLeft) {
        CGFloat midPoint = self.maximumLeftDrawerWidth / 2.0;
        if(xVelocity > MMDrawerPanVelocityXAnimationThreshold){
            [self openDrawerSide:MMDrawerSideLeft animated:YES velocity:animationVelocity animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(xVelocity < -MMDrawerPanVelocityXAnimationThreshold){
            [self closeDrawerAnimated:YES velocity:animationVelocity animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
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
        CGFloat midPoint = (CGRectGetWidth(self.childControllerContainerView.bounds)-self.maximumRightDrawerWidth) + (self.maximumRightDrawerWidth / 2.0);
        if(xVelocity > MMDrawerPanVelocityXAnimationThreshold){
            [self closeDrawerAnimated:YES velocity:animationVelocity animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if (xVelocity < -MMDrawerPanVelocityXAnimationThreshold){
            [self openDrawerSide:MMDrawerSideRight animated:YES velocity:animationVelocity animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(currentOriginX > midPoint){
            [self closeDrawerAnimated:YES completion:completion];
        }
        else {
            [self openDrawerSide:MMDrawerSideRight animated:YES completion:completion];
        }
    }
    else {
        if(completion){
            completion(NO);
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
        CATransform3D transform = CATransform3DIdentity;
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
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

-(void)prepareToPresentDrawer:(MMDrawerSide)drawer animated:(BOOL)animated{
    MMDrawerSide drawerToHide = MMDrawerSideNone;
    if(drawer == MMDrawerSideLeft){
        drawerToHide = MMDrawerSideRight;
    }
    else if(drawer == MMDrawerSideRight){
        drawerToHide = MMDrawerSideLeft;
    }
    
    UIViewController * sideDrawerViewControllerToPresent = [self sideDrawerViewControllerForSide:drawer];
    UIViewController * sideDrawerViewControllerToHide = [self sideDrawerViewControllerForSide:drawerToHide];

    [self.childControllerContainerView sendSubviewToBack:sideDrawerViewControllerToHide.view];
    [sideDrawerViewControllerToHide.view setHidden:YES];
    [sideDrawerViewControllerToPresent.view setHidden:NO];
    [self resetDrawerVisualStateForDrawerSide:drawer];
    [sideDrawerViewControllerToPresent.view setFrame:sideDrawerViewControllerToPresent.mm_visibleDrawerFrame];
    [self updateDrawerVisualStateForDrawerSide:drawer percentVisible:0.0];
    [sideDrawerViewControllerToPresent beginAppearanceTransition:YES animated:animated];
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
        centerView.layer.masksToBounds = YES;
    }
}

-(NSTimeInterval)animationDurationForAnimationDistance:(CGFloat)distance{
    NSTimeInterval duration = MAX(distance/self.animationVelocity,MMDrawerMinimumAnimationDuration);
    return duration;
}

-(UIViewController*)sideDrawerViewControllerForSide:(MMDrawerSide)drawerSide{
    UIViewController * sideDrawerViewController = nil;
    if(drawerSide != MMDrawerSideNone){
        sideDrawerViewController = [self childViewControllerForSide:drawerSide];
    }
    return sideDrawerViewController;
}

-(UIViewController*)childViewControllerForSide:(MMDrawerSide)drawerSide{
    UIViewController * childViewController = nil;
    switch (drawerSide) {
        case MMDrawerSideLeft:
            childViewController = self.leftDrawerViewController;
            break;
        case MMDrawerSideRight:
            childViewController = self.rightDrawerViewController;
            break;
        case MMDrawerSideNone:
            childViewController = self.centerViewController;
            break;
    }
    return childViewController;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    BOOL shouldReceiveTouch = NO;
    if(self.openSide == MMDrawerSideNone){
        MMOpenDrawerGestureMode possibleOpenGestureModes = [self possibleOpenGestureModesForGestureRecognizer:gestureRecognizer
                                                                                                    withTouch:touch];
        return ((self.openDrawerGestureModeMask & possibleOpenGestureModes)>0);
    }
    else{
        MMCloseDrawerGestureMode possibleCloseGestureModes = [self possibleCloseGestureModesForGestureRecognizer:gestureRecognizer
                                                                                                       withTouch:touch];
        return ((self.closeDrawerGestureModeMask & possibleCloseGestureModes)>0);
    }
    return shouldReceiveTouch;
}

#pragma mark Gesture Recogizner Delegate Helpers
-(MMCloseDrawerGestureMode)possibleCloseGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouch:(UITouch*)touch{
    CGPoint point = [touch locationInView:self.childControllerContainerView];
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
        if([self isPointContainedWithRightBezelRect:point] &&
           self.openSide == MMDrawerSideLeft){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithinLeftBezelRect:point] &&
           self.openSide == MMDrawerSideRight){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithinCenterViewContentRect:point] == NO &&
           [self isPointContainedWithinNavigationRect:point] == NO){
            possibleCloseGestureModes |= MMCloseDrawerGestureModePanningDrawerView;
        }
    }
    if((self.closeDrawerGestureModeMask & MMCloseDrawerGestureModeCustom) > 0 &&
       self.gestureShouldRecognizeTouch){
        if(self.gestureShouldRecognizeTouch(self,gestureRecognizer,touch)){
            possibleCloseGestureModes |= MMCloseDrawerGestureModeCustom;
        }
    }
    return possibleCloseGestureModes;
}

-(MMOpenDrawerGestureMode)possibleOpenGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouch:(UITouch*)touch{
    CGPoint point = [touch locationInView:self.childControllerContainerView];
    MMOpenDrawerGestureMode possibleOpenGestureModes = MMOpenDrawerGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleOpenGestureModes |= MMOpenDrawerGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleOpenGestureModes |= MMOpenDrawerGestureModePanningCenterView;
        }
        if([self isPointContainedWithinLeftBezelRect:point] &&
           self.leftDrawerViewController){
            possibleOpenGestureModes |= MMOpenDrawerGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithRightBezelRect:point] &&
           self.rightDrawerViewController){
            possibleOpenGestureModes |= MMOpenDrawerGestureModeBezelPanningCenterView;
        }
    }
    if((self.openDrawerGestureModeMask & MMOpenDrawerGestureModeCustom) > 0 &&
       self.gestureShouldRecognizeTouch){
        if(self.gestureShouldRecognizeTouch(self,gestureRecognizer,touch)){
            possibleOpenGestureModes |= MMOpenDrawerGestureModeCustom;
        }
    }
    return possibleOpenGestureModes;
}

-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point{
    CGRect navigationBarRect = CGRectNull;
    if([self.centerViewController isKindOfClass:[UINavigationController class]]){
        UINavigationBar * navBar = [(UINavigationController*)self.centerViewController navigationBar];
        navigationBarRect = [navBar convertRect:navBar.frame toView:self.childControllerContainerView];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.childControllerContainerView.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinCenterViewContentRect:(CGPoint)point{
    CGRect centerViewContentRect = self.centerContainerView.frame;
    centerViewContentRect = CGRectIntersection(centerViewContentRect,self.childControllerContainerView.bounds);
    return (CGRectContainsPoint(centerViewContentRect, point) &&
            [self isPointContainedWithinNavigationRect:point] == NO);
}

-(BOOL)isPointContainedWithinLeftBezelRect:(CGPoint)point{
    CGRect leftBezelRect = CGRectNull;
    CGRect tempRect;
    CGRectDivide(self.childControllerContainerView.bounds, &leftBezelRect, &tempRect, MMDrawerBezelRange, CGRectMinXEdge);
    return (CGRectContainsPoint(leftBezelRect, point) &&
            [self isPointContainedWithinCenterViewContentRect:point]);
}

-(BOOL)isPointContainedWithRightBezelRect:(CGPoint)point{
    CGRect rightBezelRect = CGRectNull;
    CGRect tempRect;
    CGRectDivide(self.childControllerContainerView.bounds, &rightBezelRect, &tempRect, MMDrawerBezelRange, CGRectMaxXEdge);
    
    return (CGRectContainsPoint(rightBezelRect, point) &&
            [self isPointContainedWithinCenterViewContentRect:point]);
}
@end
