//
//  XHRadarPointView.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "XHRadarPointView.h"

@implementation XHRadarPointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - select point
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if(touch.tapCount == 1)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemRadarPointView:)]) {
            [self.delegate didSelectItemRadarPointView:self];
        }
    }
}

@end
