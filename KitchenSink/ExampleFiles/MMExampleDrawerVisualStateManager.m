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


#import "MMExampleDrawerVisualStateManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation MMExampleDrawerVisualStateManager

+ (MMExampleDrawerVisualStateManager *)sharedManager {
    static MMExampleDrawerVisualStateManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MMExampleDrawerVisualStateManager alloc] init];
        [_sharedManager setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
        [_sharedManager setRightDrawerAnimationType:MMDrawerAnimationTypeParallax];
    });
    
    return _sharedManager;
}

-(MMDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(MMDrawerSide)drawerSide{
    MMDrawerAnimationType animationType;
    if(drawerSide == MMDrawerSideLeft){
        animationType = self.leftDrawerAnimationType;
    }
    else {
        animationType = self.rightDrawerAnimationType;
    }
    
    MMDrawerControllerDrawerVisualStateBlock visualStateBlock = nil;
    switch (animationType) {
        case MMDrawerAnimationTypeSlide:
            visualStateBlock = [MMDrawerVisualState slideVisualStateBlock];
            break;
        case MMDrawerAnimationTypeSlideAndScale:
            visualStateBlock = [MMDrawerVisualState slideAndScaleVisualStateBlock];
            break;
        case MMDrawerAnimationTypeParallax:
            visualStateBlock = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            break;
        case MMDrawerAnimationTypeSwingingDoor:
            visualStateBlock = [MMDrawerVisualState swingingDoorVisualStateBlock];
            break;
        default:
            visualStateBlock =  ^(MMDrawerController * drawerController, MMDrawerSide drawerSide, CGFloat percentVisible){
                
                if (percentVisible > 1.f) {
                    MMDrawerControllerDrawerVisualStateBlock stateBlock = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.f];
                    stateBlock(drawerController, drawerSide, percentVisible);
                }
                else{
                    UIViewController *viewController = nil;
                    if (drawerSide == MMDrawerSideLeft) {
                        viewController = drawerController.leftDrawerViewController;
                    }
                    else if(drawerSide == MMDrawerSideRight){
                        viewController = drawerController.rightDrawerViewController;
                    }
                    
                    viewController.view.layer.transform = CATransform3DIdentity;
                }
            };
            break;
    }
    return visualStateBlock;
}
@end
