//
//  MMNavigationController.m
//  MMDrawerControllerKitchenSink
//
//  Created by Kevin Harwood on 7/19/13.
//  Copyright (c) 2013 Mutual Mobile. All rights reserved.
//

#import "MMNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface MMNavigationController ()

@end

@implementation MMNavigationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

@end
