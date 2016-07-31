//
//  XHRadarIndicatorView.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHRadarIndicatorView : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) BOOL clockwise;

@end
