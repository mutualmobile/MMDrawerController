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

#import "MMSideDrawerSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface MMSideDrawerSectionHeaderView ()
@property (nonatomic, strong) UILabel * label;
@end

@implementation MMSideDrawerSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self setBackgroundColor:[UIColor colorWithRed:77.0/255.0
                                                 green:79.0/255.0
                                                  blue:80.0/255.0
                                                 alpha:1.0]];
        
        _label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10.0, 2.0)];
        [self.label setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:[UIColor colorWithRed:203.0/255.0
                                            green:206.0/255.0
                                             blue:209.0/255.0
                                            alpha:1.0]];
        [self.label setShadowOffset:CGSizeMake(0, 1)];
        [self.label setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
        [self.label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:self.label];
        [self setClipsToBounds:NO];        
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.label setText:self.title];
}

-(void)drawRect:(CGRect)rect{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.373 green: 0.388 blue: 0.404 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.216 green: 0.231 blue: 0.243 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.451 green: 0.463 blue: 0.475 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 0.184 green: 0.2 blue: 0.212 alpha: 1];
    UIColor* fillColor2 = [UIColor colorWithRed: 0.373 green: 0.388 blue: 0.404 alpha: 0];
    
    //// Gradient Declarations
    NSArray* gradient2Colors = [NSArray arrayWithObjects:
                                (id)color.CGColor,
                                (id)fillColor2.CGColor, nil];
    CGFloat gradient2Locations[] = {0, 1};
    CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
    
    //// Frames
    CGRect frame = CGRectMake(0, -1, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)+1);
    
    
    //// Fill Drawing
    CGRect fillRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - 1);
    UIBezierPath* fillPath = [UIBezierPath bezierPathWithRect: fillRect];
    CGContextSaveGState(context);
    [fillPath addClip];
    CGContextDrawLinearGradient(context, gradient2,
                                CGPointMake(CGRectGetMidX(fillRect), CGRectGetMinY(fillRect)),
                                CGPointMake(CGRectGetMidX(fillRect), CGRectGetMaxY(fillRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// TopStroke Drawing
    UIBezierPath* topStrokePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), 1)];
    [color4 setFill];
    [topStrokePath fill];
    
    
    //// Highlight Drawing
    UIBezierPath* highlightPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 1, CGRectGetWidth(frame), 1)];
    [color3 setFill];
    [highlightPath fill];
    
    
    //// BottomStroke Drawing
    UIBezierPath* bottomStrokePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + CGRectGetHeight(frame) - 1, CGRectGetWidth(frame), 1)];
    [color2 setFill];
    [bottomStrokePath fill];
    
    
    //// Cleanup
    CGGradientRelease(gradient2);
    CGColorSpaceRelease(colorSpace);
    

}

@end
