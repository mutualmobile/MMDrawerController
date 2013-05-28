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


#import "MMLogoView.h"

@implementation MMLogoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* mmFill = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.196];
    UIColor* shape1DropShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
    UIColor* shape1InnerShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.392];
    
    //// Shadow Declarations
    UIColor* mmDropShadow = shape1DropShadowColor;
    CGSize mmDropShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat mmDropShadowBlurRadius = 0;
    UIColor* mmInnerShadow = shape1InnerShadowColor;
    CGSize mmInnerShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat mmInnerShadowBlurRadius = 0;
    
    //// Frames
    CGRect frame = self.bounds;
    
    
    //// mmGroup
    {
        //// mmShape Drawing
        UIBezierPath* mmShapePath = [UIBezierPath bezierPath];
        [mmShapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51759 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96761 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37558 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.91398 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46395 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96761 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41351 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.94854 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31759 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76824 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.33346 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87556 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31234 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.82249 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31904 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75325 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75459 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28470 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75535 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.29666 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75510 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.29065 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75535 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.14274 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70173 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.23106 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75535 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.18067 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73625 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.14274 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44291 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.06451 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63038 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.06451 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51425 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45528 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15799 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48085 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14832 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46207 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15176 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47120 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14832 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50639 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15799 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49051 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14832 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.49957 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15176 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50639 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20462 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.52050 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17087 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52050 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19177 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.19390 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48951 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.19386 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65510 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.14397 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53518 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.14397 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60942 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28476 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68936 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21821 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67720 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.25047 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68936 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37557 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65514 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.31904 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68936 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.35128 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67720 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68812 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37025 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71365 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36056 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.69491 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36401 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.70403 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36056 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.73923 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37025 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.72332 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36056 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.73241 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36401 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.73923 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41681 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.75333 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38310 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75333 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.40399 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42673 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70173 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42670 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.86737 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37681 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.74744 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.37681 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.82172 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51759 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90159 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.45104 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88944 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48328 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90159 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60840 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.86743 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55183 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90159 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58413 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88944 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92092 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58246 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.94646 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57284 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.92773 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57623 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.93682 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57284 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.97208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58246 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.95617 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57284 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.96523 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57623 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.97208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62912 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.98615 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59535 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.98615 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61626 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.65956 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.91398 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51759 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96761 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.62160 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.94854 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57117 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96761 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51759 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96761 * CGRectGetHeight(frame))];
        [mmShapePath closePath];
        [mmShapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51965 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81940 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49408 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.80982 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81940 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50091 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81600 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49408 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76313 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.48000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79686 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77600 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80659 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47824 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80662 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.31264 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.85650 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.43259 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.85650 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35831 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71574 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27840 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.78226 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.29053 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75001 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27840 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62493 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.31260 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.68146 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27840 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.64921 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.29053 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31239 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59752 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28684 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60718 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30556 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60378 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.29644 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60718 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.26125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59752 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.27718 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60718 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.26808 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60378 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.26125 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55093 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.24715 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58467 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.24715 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56377 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57377 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.26601 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57380 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10041 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.62368 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.22029 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.62368 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14606 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48291 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06617 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54946 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07832 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.51721 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06617 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10040 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44863 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06617 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.41637 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07832 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.07956 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38530 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.05400 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39496 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.07274 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39149 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.06365 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39496 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38530 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.04434 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39496 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.03525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39149 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33867 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.01434 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37241 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.01434 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35151 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.34095 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05378 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48291 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00013 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37888 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01919 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42931 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00013 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62491 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05378 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53657 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00013 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.58700 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01919 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68292 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19950 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66705 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09219 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.68815 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14529 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68143 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21454 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69786 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21318 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71580 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21244 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.70379 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21269 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.70984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21244 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.85774 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.26604 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.76941 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21244 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.81981 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23147 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.85774 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52485 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.93599 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33738 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.93599 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45349 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54521 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.80977 * CGRectGetHeight(frame))];
        [mmShapePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51965 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81940 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53840 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81600 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52930 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81940 * CGRectGetHeight(frame))];
        [mmShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51965 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.81940 * CGRectGetHeight(frame))];
        [mmShapePath closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mmDropShadowOffset, mmDropShadowBlurRadius, mmDropShadow.CGColor);
        
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        [mmFill setFill];
        [mmShapePath fill];
        
        ////// mmShape Inner Shadow
        CGRect mmShapeBorderRect = CGRectInset([mmShapePath bounds], -mmInnerShadowBlurRadius, -mmInnerShadowBlurRadius);
        mmShapeBorderRect = CGRectOffset(mmShapeBorderRect, -mmInnerShadowOffset.width, -mmInnerShadowOffset.height);
        mmShapeBorderRect = CGRectInset(CGRectUnion(mmShapeBorderRect, [mmShapePath bounds]), -1, -1);
        
        UIBezierPath* mmShapeNegativePath = [UIBezierPath bezierPathWithRect: mmShapeBorderRect];
        [mmShapeNegativePath appendPath: mmShapePath];
        mmShapeNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = mmInnerShadowOffset.width + round(mmShapeBorderRect.size.width);
            CGFloat yOffset = mmInnerShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        mmInnerShadowBlurRadius,
                                        mmInnerShadow.CGColor);
            
            [mmShapePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(mmShapeBorderRect.size.width), 0);
            [mmShapeNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [mmShapeNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
    }
}

@end
