//
//  XHRadarPointView.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHRadarPointViewDelegate;

@interface XHRadarPointView : UIView

@property (nonatomic, assign) id <XHRadarPointViewDelegate> delegate;

@end

@protocol XHRadarPointViewDelegate <NSObject>

@optional

- (void)didSelectItemRadarPointView:(XHRadarPointView *)radarPointView;

@end
