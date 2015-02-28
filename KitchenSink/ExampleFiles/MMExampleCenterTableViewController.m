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


#import "MMExampleCenterTableViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionStatusBarBackgroundState,
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

@interface MMExampleCenterTableViewController ()

@end

@implementation MMExampleCenterTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    

    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    if(OSVersionIsAtLeastiOS7()){
        UIColor * barColor = [UIColor
                              colorWithRed:217.0/255.0
                              green:219.0/255.0
                              blue:220.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        UIColor * barColor = [UIColor
                              colorWithRed:78.0/255.0
                              green:156.0/255.0
                              blue:206.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    
    MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
    [self.navigationItem setTitleView:logo];
    [self.navigationController.view.layer setCornerRadius:10.0f];
    
    
    UIView *backView = [[UIView alloc] init];
    [backView setBackgroundColor:[UIColor colorWithRed:208.0/255.0
                                                 green:208.0/255.0
                                                  blue:208.0/255.0
                                                 alpha:1.0]];
    [self.tableView setBackgroundView:backView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Center will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Center did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Center will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Center did disappear");
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case MMCenterViewControllerSectionLeftDrawerAnimation:
        case MMCenterViewControllerSectionRightDrawerAnimation:
            return 5;
        case MMCenterViewControllerSectionLeftViewState:
        case MMCenterViewControllerSectionRightViewState:
            return 1;
        case MMCenterViewControllerSectionStatusBarBackgroundState:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MMCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    UIColor * selectedColor = [UIColor
                               colorWithRed:1.0/255.0
                               green:15.0/255.0
                               blue:25.0/255.0
                               alpha:1.0];
    UIColor * unselectedColor = [UIColor
                                 colorWithRed:79.0/255.0
                                 green:93.0/255.0
                                 blue:102.0/255.0
                                 alpha:1.0];
    
    switch (indexPath.section) {
        case MMCenterViewControllerSectionStatusBarBackgroundState:
            if(self.mm_drawerController.statusBarBackgroundViewMode == indexPath.row){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell.textLabel setTextColor:selectedColor];
            }
            else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setTextColor:unselectedColor];
            }
            switch (indexPath.row) {
                case MMStatusBarBackgroundViewModeNone:
                    [cell.textLabel setText:@"None"];
                    break;
                case MMStatusBarBackgroundViewModeOpaque:
                    [cell.textLabel setText:@"Opaque"];
                    break;
                case MMStatusBarBackgroundViewModeVariable:
                    [cell.textLabel setText:@"Variable"];
                    break;
                default:
                    break;
            }
            break;
        case MMCenterViewControllerSectionLeftDrawerAnimation:
        case MMCenterViewControllerSectionRightDrawerAnimation:{
             MMDrawerAnimationType animationTypeForSection;
            if(indexPath.section == MMCenterViewControllerSectionLeftDrawerAnimation){
                animationTypeForSection = [[MMExampleDrawerVisualStateManager sharedManager] leftDrawerAnimationType];
            }
            else {
                animationTypeForSection = [[MMExampleDrawerVisualStateManager sharedManager] rightDrawerAnimationType];
            }
            
            if(animationTypeForSection == indexPath.row){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell.textLabel setTextColor:selectedColor];
            }
            else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setTextColor:unselectedColor];
            }
            switch (indexPath.row) {
                case MMDrawerAnimationTypeNone:
                    [cell.textLabel setText:@"None"];
                    break;
                case MMDrawerAnimationTypeSlide:
                    [cell.textLabel setText:@"Slide"];
                    break;
                case MMDrawerAnimationTypeSlideAndScale:
                    [cell.textLabel setText:@"Slide and Scale"];
                    break;
                case MMDrawerAnimationTypeSwingingDoor:
                    [cell.textLabel setText:@"Swinging Door"];
                    break;
                case MMDrawerAnimationTypeParallax:
                    [cell.textLabel setText:@"Parallax"];
                    break;
                default:
                    break;
            }
             break;   
        }
        case MMCenterViewControllerSectionLeftViewState:{
            [cell.textLabel setText:@"Enabled"];
            if(self.mm_drawerController.leftDrawerViewController){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell.textLabel setTextColor:selectedColor];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setTextColor:unselectedColor];
            }
            break;
        }
        case MMCenterViewControllerSectionRightViewState:{
            [cell.textLabel setText:@"Enabled"];
            if(self.mm_drawerController.rightDrawerViewController){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell.textLabel setTextColor:selectedColor];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setTextColor:unselectedColor];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case MMCenterViewControllerSectionStatusBarBackgroundState:
            return @"Status Bar Background View Mode";
        case MMCenterViewControllerSectionLeftDrawerAnimation:
            return @"Left Drawer Animation";
        case MMCenterViewControllerSectionRightDrawerAnimation:
            return @"Right Drawer Animation";
        case MMCenterViewControllerSectionLeftViewState:
            return @"Left Drawer";
        case MMCenterViewControllerSectionRightViewState:
            return @"Right Drawer";
        default:
            return nil;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMExampleCenterTableViewController * center;
    UINavigationController * nav;
    
    switch (indexPath.section) {
        case MMCenterViewControllerSectionStatusBarBackgroundState:
            [self.mm_drawerController setStatusBarBackgroundViewMode:indexPath.row];
            
            center = [[MMExampleCenterTableViewController alloc] init];
            nav = [[MMNavigationController alloc] initWithRootViewController:center];
            self.mm_drawerController.centerViewController = nav;
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case MMCenterViewControllerSectionLeftDrawerAnimation:
        case MMCenterViewControllerSectionRightDrawerAnimation:{
            if(indexPath.section == MMCenterViewControllerSectionLeftDrawerAnimation){
                [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:indexPath.row];
            }
            else {
                [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:indexPath.row];
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case MMCenterViewControllerSectionLeftViewState:
        case MMCenterViewControllerSectionRightViewState:{
            UIViewController * sideDrawerViewController;
            MMDrawerSide drawerSide = MMDrawerSideNone;
            if(indexPath.section == MMCenterViewControllerSectionLeftViewState){
                sideDrawerViewController = self.mm_drawerController.leftDrawerViewController;
                drawerSide = MMDrawerSideLeft;
            }
            else if(indexPath.section == MMCenterViewControllerSectionRightViewState){
                sideDrawerViewController = self.mm_drawerController.rightDrawerViewController;
                drawerSide = MMDrawerSideRight;
            }
            
            if(sideDrawerViewController){
                [self.mm_drawerController
                 closeDrawerAnimated:YES
                 completion:^(BOOL finished) {
                     if(drawerSide == MMDrawerSideLeft){
                         [self.mm_drawerController setLeftDrawerViewController:nil];
                         [self.navigationItem setLeftBarButtonItems:nil animated:YES];
                     }
                     else if(drawerSide == MMDrawerSideRight){
                         [self.mm_drawerController setRightDrawerViewController:nil];
                         [self.navigationItem setRightBarButtonItem:nil animated:YES];
                     }
                     [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                     [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                     [tableView deselectRowAtIndexPath:indexPath animated:YES];
                 }];

            }
            else {
                if(drawerSide == MMDrawerSideLeft){
                    UIViewController * vc = [[MMExampleLeftSideDrawerViewController alloc] init];
                    if(OSVersionIsAtLeastiOS7()){
                        UINavigationController * navC = [[MMNavigationController alloc] initWithRootViewController:vc];
                        [self.mm_drawerController setLeftDrawerViewController:navC];
                    }
                    else {
                        [self.mm_drawerController setLeftDrawerViewController:vc];
                    }
                    [self setupLeftMenuButton];
                }
                else if(drawerSide == MMDrawerSideRight){
                    UIViewController * vc = [[MMExampleRightSideDrawerViewController alloc] init];
                    if(drawerSide == MMDrawerSideLeft){
                        UINavigationController * navC = [[MMNavigationController alloc] initWithRootViewController:vc];
                        [self.mm_drawerController setRightDrawerViewController:navC];
                    }
                    else {
                        [self.mm_drawerController setRightDrawerViewController:vc];
                    }
                    [self setupRightMenuButton];
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

@end
