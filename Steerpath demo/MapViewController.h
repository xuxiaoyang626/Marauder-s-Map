//
//  MapViewController.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IndoorGuide/IGFloorPlanCollectionView.h>

@interface MapViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property IBOutlet IGFloorPlanCollectionView *floorPlanView;
@property (atomic) NSString *routingDestination;

@property IBOutlet UIBarButtonItem *floorAboveButton;
@property IBOutlet UIBarButtonItem *floorBelowButton;

@property IBOutlet UIButton *informationButton;

@property IBOutlet UITableView *zoneListTableView;

-(IBAction)switchToFloorBelow:(id)sender;
-(IBAction)switchToFloorAbove:(id)sender;

@end
