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


#import "MMTableViewCell.h"

@interface MMDisclosureIndicator : UIView
@property (nonatomic, strong) UIColor * color;
@end

@implementation MMDisclosureIndicator
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* shadow = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.46];
    UIColor* chevronColor = self.color;
    
    //// Shadow Declarations
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0;
    
    //// Frames
    CGRect frame = self.bounds;
    
    
    //// chevron Drawing
    UIBezierPath* chevronPath = [UIBezierPath bezierPath];
    [chevronPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01667 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.98000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48333 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98333 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81667 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48333 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15000 * CGRectGetHeight(frame))];
    [chevronPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01667 * CGRectGetHeight(frame))];
    [chevronPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [chevronColor setFill];
    [chevronPath fill];
    CGContextRestoreGState(context);
}
@end

@interface MMCustomCheckmark : UIControl
@property (nonatomic, strong) UIColor * color;
@end

@implementation MMCustomCheckmark

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    //// Color Declarations
    UIColor* checkMarkColor = self.color;

    //// Frames
    CGRect frame = self.bounds;
    
    
    //// checkMark Drawing
    UIBezierPath* checkMarkPath = [UIBezierPath bezierPath];
    [checkMarkPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.07087 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48855 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.12500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45284 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.21038 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47898 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.15489 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.43312 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.19312 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44482 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51450 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79528 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49163 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.89286 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53176 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.82945 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52152 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87313 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38337 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29800 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93814 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.35348 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98401 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31526 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97230 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.04800 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58613 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.07087 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48855 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.03074 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55196 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.04098 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50828 * CGRectGetHeight(frame))];
    [checkMarkPath closePath];
    [checkMarkPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92048 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00641 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.93750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02427 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96038 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.12184 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.96739 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04399 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.97764 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08768 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51450 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93814 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42913 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49724 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97230 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45902 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98401 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32087 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.89286 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29800 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79528 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.29098 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87313 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.28074 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.82945 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.83511 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.03255 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92048 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00641 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.85237 * CGRectGetWidth(frame), CGRectGetMinY(frame) + -0.00161 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.89059 * CGRectGetWidth(frame), CGRectGetMinY(frame) + -0.01331 * CGRectGetHeight(frame))];
    [checkMarkPath closePath];
    [checkMarkPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85714 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.47202 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81769 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92857 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96802 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47202 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92857 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.34048 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96802 * CGRectGetHeight(frame))];
    [checkMarkPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85714 * CGRectGetHeight(frame))];
    [checkMarkPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81769 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.34048 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame))];
    [checkMarkPath closePath];
    [checkMarkColor setFill];
    [checkMarkPath fill];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

@end

@implementation MMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryCheckmarkColor:[UIColor whiteColor]];
        [self setDisclosureIndicatorColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    [super setAccessoryType:accessoryType];
    if(accessoryType == UITableViewCellAccessoryCheckmark){
        MMCustomCheckmark * customCheckmark = [[MMCustomCheckmark alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [customCheckmark setColor:self.accessoryCheckmarkColor];
        [self setAccessoryView:customCheckmark];
    }
    else if(accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        MMDisclosureIndicator * di = [[MMDisclosureIndicator alloc] initWithFrame:CGRectMake(0, 0, 10, 14)];
        [di setColor:self.disclosureIndicatorColor];
        [self setAccessoryView:di];
    }
    else {
        [self setAccessoryView:nil];
    }
}

@end
