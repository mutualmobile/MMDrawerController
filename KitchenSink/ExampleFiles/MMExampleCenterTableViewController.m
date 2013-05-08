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

#import <QuartzCore/QuartzCore.h>

@interface MMExampleCenterTableViewController ()

@end

@implementation MMExampleCenterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton];
    
    [self.navigationController.navigationBar setTintColor:[UIColor
                                                           colorWithRed:78.0/255.0
                                                           green:156.0/255.0
                                                           blue:206.0/255.0
                                                           alpha:1.0]];
    
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 2) {
        return 2;
    }
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MMCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if (indexPath.section != 2) {
        MMDrawerAnimationType animationTypeForSection;
        if(indexPath.section == 0){
            animationTypeForSection = [[MMExampleDrawerVisualStateManager sharedManager] leftDrawerAnimationType];
        }
        else {
            animationTypeForSection = [[MMExampleDrawerVisualStateManager sharedManager] rightDrawerAnimationType];
        }
        
        if(animationTypeForSection == indexPath.row){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell.textLabel setTextColor:[UIColor
                                          colorWithRed:1.0/255.0
                                          green:15.0/255.0
                                          blue:25.0/255.0
                                          alpha:1.0]];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setTextColor:[UIColor
                                          colorWithRed:79.0/255.0
                                          green:93.0/255.0
                                          blue:102.0/255.0
                                          alpha:1.0]];
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
    }
    else{
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"Left Drawer"];
                if (self.mm_drawerController.leftDrawerViewController == nil) {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
                else{
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                break;
            case 1:
                [cell.textLabel setText:@"Right Drawer"];
                if (self.mm_drawerController.rightDrawerViewController == nil) {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
                else{
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                break;
        }
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Left Drawer Animation";
        case 1:
            return @"Right Drawer Animation";
        case 2:
            return @"Enable Drawer Side";
        default:
            return nil;
            break;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 30)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(containerView.bounds, 14, 0)];
    
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleLabel setTextColor:[UIColor colorWithRed:3.0/255.0
                                             green:48.0/255.0
                                              blue:77.0/255.0
                                             alpha:1.0]];
    [titleLabel setShadowColor:[[UIColor whiteColor] colorWithAlphaComponent:.5]];
    [titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [containerView addSubview:titleLabel];
    
    return containerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:indexPath.row];
            break;
        case 1:
            [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:indexPath.row];
            break;
        case 2:
            if (indexPath.row == 0) {
                if (self.mm_drawerController.leftDrawerViewController != nil) {
                    [self.mm_drawerController setLeftDrawerViewController:nil];
                }
                else{
                    UIViewController * leftSideDrawerViewController = [[MMExampleLeftSideDrawerViewController alloc] init];
                    [self.mm_drawerController setLeftDrawerViewController:leftSideDrawerViewController];
                }
            }
            else{
                if (self.mm_drawerController.rightDrawerViewController != nil) {
                    [self.mm_drawerController setRightDrawerViewController:nil];
                }
                else{
                    UIViewController * leftSideDrawerViewController = [[MMExampleRightSideDrawerViewController alloc] init];
                    [self.mm_drawerController setRightDrawerViewController:leftSideDrawerViewController];
                }
            }
            break;
        default:
            break;
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
