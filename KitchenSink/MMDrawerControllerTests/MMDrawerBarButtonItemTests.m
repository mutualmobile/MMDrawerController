//
//  MMDrawerBarButtonItemTests.m
//  MMDrawerControllerKitchenSink
//
//  Created by Eytan Biala on 4/18/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "MMDrawerBarButtonItem.h"

@interface MMDrawerBarButtonItemTests : XCTestCase

@end

@implementation MMDrawerBarButtonItemTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testButtonTargetAndAction {
    id targetMock = OCMClassMock([NSObject class]);
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:targetMock action:@selector(testButtonTargetAndAction)];
    expect(button.target).to.beTruthy();
    expect(button.action).to.beTruthy();
}

@end
