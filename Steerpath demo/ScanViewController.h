//
//  ViewController.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHRadarView.h"

@interface ScanViewController : UIViewController <XHRadarViewDataSource, XHRadarViewDelegate>

@property (nonatomic, strong) XHRadarView *radarView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@end

