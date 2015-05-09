//
//  MMDrawerControllerTests.m
//  MMDrawerControllerTests
//
//  Created by Eytan Biala on 4/18/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "MMDrawerController.h"
#import <Specta/Specta.h>

SpecBegin(MMDrawerControllerTests)

describe(@"drawer controller", ^{

    __block MMDrawerController *drawerController;

    beforeAll(^{
        UIViewController *center = [[UIViewController alloc] init];
        center.view.backgroundColor = [UIColor greenColor];

        UIViewController *left = [[UIViewController alloc] init];
        left.view.backgroundColor = [UIColor blueColor];

        UIViewController *right = [[UIViewController alloc] init];
        right.view.backgroundColor = [UIColor magentaColor];

        drawerController = [[MMDrawerController alloc] initWithCenterViewController:center
                                                           leftDrawerViewController:left
                                                          rightDrawerViewController:right];

        [[UIApplication sharedApplication] keyWindow].rootViewController = drawerController;
    });

    beforeEach(^{
        waitUntil(^(DoneCallback done) {
            [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                done();
            }];
        });
    });

    it(@"should open the left side", ^{

        waitUntil(^(DoneCallback done){
            [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                expect(drawerController.openSide).to.equal(MMDrawerSideLeft);
                done();
            }];
        });
    });

    it(@"should open the right side", ^{

        waitUntil(^(DoneCallback done){
            [drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
                expect(drawerController.openSide).to.equal(MMDrawerSideRight);
                done();
            }];
        });
    });

    it(@"should open the right side and then toggle it closed", ^{

        waitUntil(^(DoneCallback done){
            [drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished){
                [drawerController toggleDrawerSide:drawerController.openSide animated:YES completion:^(BOOL finished){
                    expect(drawerController.openSide).to.equal(MMDrawerSideNone);
                    done();
                }];
            }];
        });
    });

    it(@"should open the left side and then toggle it closed", ^{

        waitUntil(^(DoneCallback done){
            [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished){
                [drawerController toggleDrawerSide:drawerController.openSide animated:YES completion:^(BOOL finished){
                    expect(drawerController.openSide).to.equal(MMDrawerSideNone);
                    done();
                }];
            }];
        });
    });

    it(@"should bounce open the left side", ^{

        waitUntil(^(DoneCallback done){
            [drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:^(BOOL finished){
                expect(drawerController.openSide).to.equal(MMDrawerSideNone);
                done();
            }];
        });
    });

    it(@"should bounce open the right side", ^{

        waitUntil(^(DoneCallback done){
            [drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:^(BOOL finished){
                expect(drawerController.openSide).to.equal(MMDrawerSideNone);
                done();
            }];
        });
    });
});

SpecEnd
