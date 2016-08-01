//
//  MapViewController.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "MapViewController.h"
#import "InformationViewController.h"
#import <IndoorGuide/IGGuideManager.h>
#import <IndoorGuide/IGPositioningDelegate.h>
#import <IndoorGuide/IGDirectionsDelegate.h>
#import <CoreLocation/CoreLocation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#define DONT_UPDATE_FREE_POSITION_THRESHOLD 0.75
#define DONT_UPDATE_SINGLE_JUMP_POSITION_THRESHOLD 20.0
@interface MapViewController ()<IGPositioningDelegate,
                                IGDirectionsDelegate,
                                IGFloorPlanCollectionViewDelegate>
{
    BOOL useLocationOnRoute;
    NSMutableArray *enteredZoneIds;
    NSMutableArray *enteredZoneNames;
    
    CLLocation *currentVisibleLocation;
    
    FBSDKLoginButton *loginButton;
    FBSDKShareButton *shareButton;
    
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    enteredZoneIds = [NSMutableArray array];
    enteredZoneNames = [NSMutableArray array];
    NSLog(@"Reset entered zones");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.floorAboveButton.enabled = NO;
    self.floorBelowButton.enabled = NO;
    
    IGGuideManager *guideManager = [IGGuideManager sharedManager];
    guideManager.positioningDelegate = self;
    guideManager.directionsDelegate = self;
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    guideManager.useAccelerometer = [settings boolForKey:@"use_accelerometer"];
    guideManager.useCompass = [settings boolForKey:@"use_compass"];
    guideManager.useDeviceMotion = [settings boolForKey:@"use_gyroscope"];

    //guideManager.useEddystoneNamespace = @"af774f3518299426a456";
    guideManager.useIBeaconRangingInBackground = true;
    guideManager.useBluetooth = [settings boolForKey:@"use_bluetooth"];
    guideManager.useEddystoneNamespace = [settings stringForKey:@"eddystone_nid"];
    
    if([settings boolForKey:@"use_ibeacon"]) {
        guideManager.useIBeaconUUID = [[NSUUID alloc] initWithUUIDString:[settings stringForKey:@"ibeacon_uuid"]];
        if(guideManager.useIBeaconUUID == nil) {
            NSLog(@"You have configured the app to use iBeacons but the UUID128 isn't valid: %@", [settings stringForKey:@"ibeacon_uuid"]);
        }
    } else {
        guideManager.useIBeaconUUID = nil;
    }

    self.floorPlanView.delegate = self;
    self.floorPlanView.configuration = [guideManager getWidgetConfiguration];
    
    
    [guideManager startUpdates];
    useLocationOnRoute = NO;
    
    if(self.routingDestination) {
        /* Load routing destination POIs */
        
        NSMutableArray * pois = [guideManager getMutablePOIs:self.routingDestination];
        for(NSMutableDictionary *poi in pois) {
            
            IGFloorPlanMarker *marker = [IGFloorPlanMarker markerWithImage:[UIImage imageNamed:@"pin"] anchor:CGPointMake(0.5,1.0)];
            [marker setCoordinateAndAltitudeFromJSON:poi];
            [self.floorPlanView addMarker:marker toGroup:self.routingDestination];
        }
        
        [guideManager startRoutingToName:self.routingDestination];
    } else {
        //[guideManager startRoutingFrom:@"Platform 5" to:@"Platform 131"];
        [guideManager stopRouting];
        
    }
    
    NSUInteger idx = self.floorPlanView.currentFloorIndex;
    self.floorBelowButton.enabled = idx > 0;
    self.floorAboveButton.enabled = idx + 1 <  self.floorPlanView.floorCount;

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    IGGuideManager *guideManager = [IGGuideManager sharedManager];
    guideManager.positioningDelegate = nil;
    guideManager.directionsDelegate = nil;
    [guideManager stopUpdates];
}



-(IBAction)switchToFloorBelow:(id)sender
{
    [self.floorPlanView switchToFloorBelow:YES];
}
-(IBAction)switchToFloorAbove:(id)sender
{
    [self.floorPlanView switchToFloorAbove:YES];
}


-(void)guideManager:(IGGuideManager *)manager didUpdateHeading:(CLLocationDirection)newHeading accuracy:(CLLocationDirection)accuracyOfHeading
{
    [self.floorPlanView setUserHeading:newHeading accuracy:accuracyOfHeading];
}

-(void)guideManager:(IGGuideManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(useLocationOnRoute == NO) {
        /* Prevent jitter */
        if(currentVisibleLocation && !isnan(currentVisibleLocation.coordinate.latitude) && newLocation && !isnan(newLocation.coordinate.latitude) && newLocation.altitude == currentVisibleLocation.altitude) {
            CLLocationDistance distance = [currentVisibleLocation distanceFromLocation:newLocation];
            if(distance < DONT_UPDATE_FREE_POSITION_THRESHOLD) {
                return;
            }
        }
        
        /* Prevent single outliers */
        if(oldLocation && !isnan(oldLocation.coordinate.latitude) && newLocation && !isnan(newLocation.coordinate.latitude) && newLocation.altitude == oldLocation.altitude) {
            CLLocationDistance distance = [oldLocation distanceFromLocation:newLocation];
            if(distance >= DONT_UPDATE_SINGLE_JUMP_POSITION_THRESHOLD) {
                return;
            }
        }
        
        [self.floorPlanView setUserCoordinate:newLocation.coordinate accuracy:newLocation.horizontalAccuracy altitude:newLocation.altitude];
        currentVisibleLocation = newLocation;
    }

}

-(void)guideManager:(IGGuideManager *)manager didCompleteRouting:(NSArray *)routepoints
{
    useLocationOnRoute = NO;
    NSLog(@"Routing completed");
    [self.floorPlanView setRoute:routepoints];
}

-(void)guideManager:(IGGuideManager *)manager didFailRoutingWithError:(NSError *)err
{
    [self.floorPlanView clearRoute];
}

-(void)guideManager:(IGGuideManager *)manager didUpdateRoutePosition:(CLLocationCoordinate2D)pos altitude:(CLLocationDistance)alt direction:(CLLocationDirection)direction distanceToChange:(CLLocationDistance)toChange distanceToGoal:(CLLocationDistance)toGoal
{
    if(useLocationOnRoute) {
        [self.floorPlanView setUserCoordinate:pos accuracy:0 altitude:alt];
    }

}

-(void)guideManager:(IGGuideManager *)manager didEnterZone:(uint32_t)zone_id name:(NSString *)name
{
    NSLog(@"Entered zone %@", name);
    [enteredZoneIds addObject:[NSNumber numberWithUnsignedInt:zone_id]];
    [enteredZoneNames addObject:name];
    [self.zoneListTableView reloadData];
    
    // facebook share //
    loginButton = [[FBSDKLoginButton alloc] init];
    
    CGRect loginFrame = CGRectMake(5, 30, 85, 30);
    loginButton.frame = loginFrame;
    //loginButton.center = self.view.center;
    [self.floorPlanView addSubview:loginButton];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL
                          URLWithString:@"https://s3.amazonaws.com/open-bucket/pokemongo.jpg"];
    content.imageURL = [NSURL
                        URLWithString:@"https://s3.amazonaws.com/open-bucket/pokemongo.jpg"];
    content.contentTitle = @"Come and catch Pokemon";
    content.contentDescription = @"Come and catch Pokemon";
    
    shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    
    CGRect shareFrame = CGRectMake(95, 30, 70, 30);
    shareButton.frame = shareFrame;
    [self.floorPlanView addSubview:shareButton];
    
    [shareButton setHidden:NO];
    [loginButton setHidden:NO];
}
-(void)guideManager:(IGGuideManager *)manager didExitZone:(uint32_t)zone_id name:(NSString *)name
{
    NSLog(@"Exited zone %@", name);
    NSUInteger pos = [enteredZoneIds indexOfObject:[NSNumber numberWithUnsignedInt:zone_id]];
    if(pos != NSNotFound) {
        [enteredZoneIds removeObjectAtIndex:pos];
        [enteredZoneNames removeObjectAtIndex:pos];
    } else {
        NSLog(@"We exited a zone we had entered previous to the reset.");
    }
    [self.zoneListTableView reloadData];
    
    [shareButton setHidden:YES];
    [loginButton setHidden:YES];
}

#pragma mark - Tap
- (void)didTapAtCoordinate:(CLLocationCoordinate2D)coordinate altitude:(CLLocationDistance)altitude
{
    CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coordinate altitude:altitude horizontalAccuracy:2.0f verticalAccuracy:0.1f course:NAN speed:NAN timestamp:[NSDate date]];
                       
    [[IGGuideManager sharedManager] setImmediateLocation:loc];
}
-(void) didChangeCurrentFloor:(IGFloorPlanCollectionView*)fpView
{
    NSUInteger idx = fpView.currentFloorIndex;
    NSLog(@"At item index %lu", (unsigned long)idx);
    self.floorBelowButton.enabled = idx > 0;
    self.floorAboveButton.enabled = idx + 1 < fpView.floorCount;
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [enteredZoneIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ZoneCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"ZoneCell"];
    }
    
    cell.textLabel.text = [enteredZoneNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(sender == self.informationButton) {
        InformationViewController *iView = segue.destinationViewController;
        iView.urlString = kAppInfoURL;
    }
}


@end
