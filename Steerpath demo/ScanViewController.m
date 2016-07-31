//
//  ViewController.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "ScanViewController.h"
#import "ESSEddystone.h"
#import "ESSBeaconScanner.h"
#include <time.h>
#include <stdlib.h>


#define MAP_BEACON_IDENTIFIER "ESSBeaconID: beaconID=<00000000 00000000 00620000 00000004>"
@interface ScanViewController () <ESSBeaconScannerDelegate> {
    ESSBeaconScanner *_scanner;
}
@property (nonatomic, strong) NSMutableArray *pointsArray;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"radar";
    
    XHRadarView *radarView = [[XHRadarView alloc] initWithFrame:self.view.bounds];
    radarView.frame = self.view.frame;
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = 200;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
    radarView.labelText = @"Looking for beacons around";
    [self.view addSubview:radarView];
    _radarView = radarView;
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-39, self.view.center.y-39, 78, 78)];
    avatarView.layer.cornerRadius = 39;
    avatarView.layer.masksToBounds = YES;
    
    [avatarView setImage:[UIImage imageNamed:@"avatar"]];
    [_radarView addSubview:avatarView];
    [_radarView bringSubviewToFront:avatarView];

    [self.radarView scan];
    [self startUpdatingRadar];
}

-(void)addPointOfBeacons: (int) num {
    _pointsArray = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i = 0; i < num; i++) {
       srand(time(NULL));
       NSInteger x = 10;
       srand(time(NULL));
       NSInteger y = 100;
       NSNumber* xWrapped = [NSNumber numberWithInt:x];
       NSNumber* yWrapped = [NSNumber numberWithInt:y];
       NSArray *point = @[xWrapped, yWrapped];
      [_pointsArray addObject:point];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scanner = [[ESSBeaconScanner alloc] init];
    _scanner.delegate = self;
    [_scanner startScanning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_scanner stopScanning];
    _scanner = nil;
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner
        didFindBeacon:(id)beaconInfo {
    NSString *info = [beaconInfo description];
        if ([info isEqualToString:@MAP_BEACON_IDENTIFIER]) {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.alertBody = @"You have entered building!";
            notification.soundName = @"Default.mp3";
            NSLog(@"Youve entered 062");
            [self addPointOfBeacons:1];
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            return;
        }
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"Scan finish，find %lu beacons", (unsigned long)weakSelf.pointsArray.count];
        [weakSelf.radarView show];
    });
}

#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView {
    return 4;
}
- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView {
    return [self.pointsArray count];
}
- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"point"]];
    [pointView addSubview:imageView];
    return pointView;
}
- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - XHRadarViewDelegate

- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
     [self performSegueWithIdentifier:@"scanFinish" sender:self];
}

@end

