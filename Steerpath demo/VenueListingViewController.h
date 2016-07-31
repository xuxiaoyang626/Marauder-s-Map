//
//  VenueListingViewController.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface VenueListingViewController : UIViewController

@property IBOutlet UITableView *venueTable;
@property IBOutlet UIActivityIndicatorView *listLoadingIndicator;

@property IBOutlet UIButton *informationButton;

@end
