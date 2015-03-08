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


#import "MMExampleSideDrawerViewController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "MMLogoView.h"
#import "MMNavigationController.h"

@implementation MMExampleSideDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(OSVersionIsAtLeastiOS7()){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    else {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UIColor * tableViewBackgroundColor;
    if(OSVersionIsAtLeastiOS7()){
        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                                   green:113.0/255.0
                                                    blue:115.0/255.0
                                                   alpha:1.0];
    }
    else {
        tableViewBackgroundColor = [UIColor colorWithRed:77.0/255.0
                                                   green:79.0/255.0
                                                    blue:80.0/255.0
                                                   alpha:1.0];
    }
    [self.tableView setBackgroundColor:tableViewBackgroundColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
                                         green:164.0/255.0
                                          blue:166.0/255.0
                                         alpha:1.0];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }


    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
    
    CGSize logoSize = CGSizeMake(58, 62);
    MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tableView.bounds)-logoSize.width/2.0,
                                                                     -logoSize.height-logoSize.height/4.0,
                                                                     logoSize.width,
                                                                     logoSize.height)];
    [logo setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.tableView addSubview:logo];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case MMDrawerSectionViewSelection:
            return 2;
        case MMDrawerSectionDrawerWidth:
            return self.drawerWidths.count;
        case MMDrawerSectionShadowToggle:
            return 7;
        case MMDrawerSectionOpenDrawerGestures:
            return 3;
        case MMDrawerSectionCloseDrawerGestures:
            return 6;
        case MMDrawerSectionCenterHiddenInteraction:
            return 3;
        case MMDrawerSectionStretchDrawer:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    switch (indexPath.section) {
        case MMDrawerSectionViewSelection:
            if(indexPath.row == 0){
                [cell.textLabel setText:@"Quick View Change"];
            }
            else {
                [cell.textLabel setText:@"Full View Change"];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case MMDrawerSectionDrawerWidth:{
            //Implement in Subclass
            break;
        }
        case MMDrawerSectionShadowToggle:{
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Show Shadow"];
                    if(self.mm_drawerController.showsShadow)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 1:
                    [cell.textLabel setText:@"Shadow Radius 10"];
                    if(self.mm_drawerController.showsShadow && (fabsf(self.mm_drawerController.shadowRadius - 10.0) <= 0.001))
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 2:
                    [cell.textLabel setText:@"Shadow Radius 5"];
                    if(self.mm_drawerController.showsShadow && fabsf(self.mm_drawerController.shadowRadius - 5.0) <= 0.001)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 3:
                    [cell.textLabel setText:@"Shadow Opacity 0.8"];
                    if(self.mm_drawerController.showsShadow && fabsf(self.mm_drawerController.shadowOpacity - 0.8) <= 0.001)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 4:
                    [cell.textLabel setText:@"Shadow Opacity 0.4"];
                    if(self.mm_drawerController.showsShadow && fabsf(self.mm_drawerController.shadowOpacity - 0.4) <= 0.001)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 5:
                    [cell.textLabel setText:@"Shadow Color Black"];
                    if(self.mm_drawerController.showsShadow && self.mm_drawerController.shadowColor == [UIColor blackColor].CGColor)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 6:
                    [cell.textLabel setText:@"Shadow Color Gray"];
                    if(self.mm_drawerController.showsShadow && self.mm_drawerController.shadowColor == [UIColor darkGrayColor].CGColor)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        case MMDrawerSectionOpenDrawerGestures:{
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Pan Nav Bar"];
                    if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModePanningNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 1:
                    [cell.textLabel setText:@"Pan Center View"];
                    if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModePanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 2:
                    [cell.textLabel setText:@"Bezel Pan Center View"];
                    if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModeBezelPanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                default:
                    break;
            }
            break;
        }
        case MMDrawerSectionCloseDrawerGestures:{
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Pan Nav Bar"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 1:
                    [cell.textLabel setText:@"Pan Center View"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 2:
                    [cell.textLabel setText:@"Bezel Pan Center View"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeBezelPanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 3:
                    [cell.textLabel setText:@"Tap Nav Bar"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeTapNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 4:
                    [cell.textLabel setText:@"Tap Center View"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeTapCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 5:
                    [cell.textLabel setText:@"Pan Drawer View"];
                    if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningDrawerView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                default:
                    break;
            }
            break;
        }
        case MMDrawerSectionCenterHiddenInteraction:{
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"None"];
                    if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeNone)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 1:
                    [cell.textLabel setText:@"Full"];
                    if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeFull)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                case 2:
                    [cell.textLabel setText:@"Nav Bar Only"];
                    if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeNavigationBarOnly)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        case MMDrawerSectionStretchDrawer:{
            [cell.textLabel setText:@"Stretch Drawer"];
            if(self.mm_drawerController.shouldStretchDrawer)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            else
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case MMDrawerSectionViewSelection:
            return @"New Center View";
        case MMDrawerSectionDrawerWidth:
            return @"Drawer Width";
        case MMDrawerSectionShadowToggle:
            return @"Shadow";
        case MMDrawerSectionOpenDrawerGestures:
            return @"Drawer Open Gestures";
        case MMDrawerSectionCloseDrawerGestures:
            return @"Drawer Close Gestures";
        case MMDrawerSectionCenterHiddenInteraction:
            return @"Open Center Interaction Mode";
        case MMDrawerSectionStretchDrawer:
            return @"Strech Drawer";
        default:
            return nil;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMSideDrawerSectionHeaderView * headerView;
    if(OSVersionIsAtLeastiOS7()){
        headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0)];
    }
    else {
        headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    }
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(OSVersionIsAtLeastiOS7()){
        return 56.0;
    }
    else {
        return 23.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MMDrawerSectionViewSelection:{
            MMExampleCenterTableViewController * center = [[MMExampleCenterTableViewController alloc] init];
            
            UINavigationController * nav = [[MMNavigationController alloc] initWithRootViewController:center];
            
            if(indexPath.row%2==0){
                [self.mm_drawerController
                 setCenterViewController:nav
                 withCloseAnimation:YES
                 completion:nil];
            }
            else {
                [self.mm_drawerController
                 setCenterViewController:nav
                 withFullCloseAnimation:YES
                 completion:nil];
            }
            break;
        }
            
        case MMDrawerSectionDrawerWidth:{
            //Implement in Subclass
            break;
        }
        case MMDrawerSectionShadowToggle:{
            switch (indexPath.row) {
                case 0:
                    [self.mm_drawerController setShowsShadow:!self.mm_drawerController.showsShadow];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 1:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowRadius:10.0];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 2:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowRadius:5.0];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 3:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowOpacity:0.8];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 4:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowOpacity:0.4];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 5:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowColor:[UIColor blackColor].CGColor];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                case 6:
                    [self.mm_drawerController setShowsShadow:YES];
                    [self.mm_drawerController setShadowColor:[UIColor darkGrayColor].CGColor];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        case MMDrawerSectionOpenDrawerGestures:{
            switch (indexPath.row) {
                case 0:
                    self.mm_drawerController.openDrawerGestureModeMask ^= MMOpenDrawerGestureModePanningNavigationBar;
                    break;
                case 1:
                    self.mm_drawerController.openDrawerGestureModeMask ^=  MMOpenDrawerGestureModePanningCenterView;
                    break;
                case 2:
                    self.mm_drawerController.openDrawerGestureModeMask ^=  MMOpenDrawerGestureModeBezelPanningCenterView;
                    break;
                default:
                    break;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case MMDrawerSectionCloseDrawerGestures:{
            switch (indexPath.row) {
                case 0:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningNavigationBar;
                    break;
                case 1:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningCenterView;
                    break;
                case 2:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModeBezelPanningCenterView;
                    break;
                case 3:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModeTapNavigationBar;
                    break;
                case 4:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModeTapCenterView;
                    break;
                case 5:
                    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningDrawerView;
                    break;
                default:
                    break;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case MMDrawerSectionCenterHiddenInteraction:{
            self.mm_drawerController.centerHiddenInteractionMode = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case MMDrawerSectionStretchDrawer:{
            self.mm_drawerController.shouldStretchDrawer = !self.mm_drawerController.shouldStretchDrawer;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        default:
            break;
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
