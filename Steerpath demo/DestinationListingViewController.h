//
//  DestinationListingViewController.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestinationListingViewController : UIViewController

@property IBOutlet UITableView *destinationsTable;
@property IBOutlet UIActivityIndicatorView *nddLoadingIndicator;
@property IBOutlet UIBarButtonItem *mapButton;

@property (nonatomic) NSURL *nddURL;
@end
