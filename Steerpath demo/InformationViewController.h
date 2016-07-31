//
//  InformationViewController.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppInfoURL @"http://www.steerpath.com/appinfo/steerpath"
@interface InformationViewController : UIViewController<UIWebViewDelegate>

@property IBOutlet UIWebView *webView;
@property IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSString *urlString;
@end
