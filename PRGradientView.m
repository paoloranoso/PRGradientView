//
//  PRGradientView.m
//
//  Created by Paolo Ranoso on 11/29/14
//  Copyright (c) 2014 Paolo Ranoso
//
// This code is distributed under the terms and conditions of the MIT license.
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
//

#import "PRGradientView.h"

#define kGradientViewPadding 10

@interface PRGradientView ()
@property (nonatomic, copy) NSArray *gradientColors;
@property (nonatomic, assign) PRGradientType gradientType;
@end

@implementation PRGradientView

+(void)addGradientViewAsBackgroundToView:(UIView *)view withType:(PRGradientType)type usingColors:(NSArray *)colors{
    PRGradientView *gradientView = nil;
    if (type == PRGradientTypeRadial){
        gradientView = [[self alloc] initWithRadialGradientViewUsingColors:colors withFrame:view.frame];
    }else{
        gradientView = [[self alloc] initWithLinearGradientViewUsingColors:colors withFrame:view.frame];
    }
    [view addSubview:gradientView];
    [view sendSubviewToBack:gradientView];
}

-(id)initWithRadialGradientViewUsingColors:(NSArray *)colors withFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.gradientColors = colors;
        self.gradientType = PRGradientTypeRadial;
    }
    return self;
}


-(id)initWithLinearGradientViewUsingColors:(NSArray *)colors withFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.gradientColors = colors;
        self.gradientType = PRGradientTypeLinear;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSMutableArray *colorsToUse = [[NSMutableArray alloc] init];
    for (UIColor *color in _gradientColors) {
        [colorsToUse addObject:(__bridge id)color.CGColor];
    }
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CFArrayRef colors =(__bridge CFArrayRef)colorsToUse;
    CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpc, colors, nil);
    
    if (_gradientType == PRGradientTypeRadial) {
        CGContextDrawRadialGradient(ref, gradient, CGPointMake(self.frame.size.width/2,self.frame.size.height/2), 0, CGPointMake(self.frame.size.width/2,self.frame.size.height/2), self.frame.size.width + kGradientViewPadding, 0);
    }else{
        CGContextDrawLinearGradient(ref, gradient , CGPointMake(0, 0), CGPointMake(0,self.frame.size.height), kCGGradientDrawsAfterEndLocation);
    }
    
    CGColorSpaceRelease(colorSpc);
    CGGradientRelease(gradient);
}


@end
