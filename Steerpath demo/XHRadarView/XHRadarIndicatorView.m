//
//  XHRadarIndicatorView.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//
#import "XHRadarIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

@implementation XHRadarIndicatorView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // Drawing code
    
    //An opaque type that represents a Quartz 2D drawing environment.

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *aColor = self.startColor;
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetLineWidth(context, 0);
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, self.radius, (self.clockwise?self.angle:0) * M_PI / 180, (self.clockwise?(self.angle -1):1)  * M_PI / 180, self.clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    const CGFloat *startColorComponents = CGColorGetComponents(self.startColor.CGColor); //RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(self.endColor.CGColor); //RGB components
    
    CGFloat R, G, B, A;
    //NSLog(@"1111111111111");
    for (int i = 0; i<= self.angle; i++) {
        CGFloat ratio = (self.clockwise?(self.angle -i):i)/self.angle;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0])*ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1])*ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2])*ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3])*ratio;
        //NSLog(@"RGBA: %f, %f, %f, %f", R, G, B, A);
        UIColor *aColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextMoveToPoint(context, self.center.x, self.center.y);
        CGContextAddArc(context, self.center.x, self.center.y, self.radius,  i * M_PI / 180, (i + (self.clockwise?-1:1)) * M_PI / 180, self.clockwise);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
