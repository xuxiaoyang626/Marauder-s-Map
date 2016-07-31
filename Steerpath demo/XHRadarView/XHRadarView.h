//
//  XHRadarView.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHRadarPointView.h"

@class XHRadarIndicatorView;

@protocol XHRadarViewDataSource;
@protocol XHRadarViewDelegate;

@interface XHRadarView : UIView <XHRadarPointViewDelegate> {
    
}

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *indicatorStartColor;
@property (nonatomic, strong) UIColor *indicatorEndColor;
@property (nonatomic, assign) CGFloat indicatorAngle;
@property (nonatomic, assign) BOOL indicatorClockwise;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) UIView *pointsView;
@property (nonatomic, strong) XHRadarIndicatorView *indicatorView;

@property (nonatomic, assign) id <XHRadarViewDataSource> dataSource;
@property (nonatomic, assign) id <XHRadarViewDelegate> delegate;

-(void)scan;
-(void)stop;
-(void)show;
-(void)hide;

@end


@protocol XHRadarViewDataSource <NSObject>

@optional

- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView;
- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView;
- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index;
- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index;

@end

@protocol XHRadarViewDelegate <NSObject>

@optional

- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index;

@end
