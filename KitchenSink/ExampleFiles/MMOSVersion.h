#import <Foundation/Foundation.h>

static BOOL OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

