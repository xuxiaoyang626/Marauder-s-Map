//
//  DestinationListingViewController.m
//  Steerpath demo
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "DestinationListingViewController.h"

#import  <IndoorGuide/IGGuideManager.h>
#import "MapViewController.h"

#import "DownloadHelper.h"

@interface DestinationListingViewController ()<IGPositioningDelegate, UITableViewDataSource>
{
    NSArray *destinationsList;
    BOOL reloadNDD;
}
@end

@implementation DestinationListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.destinationsTable.dataSource = self;

    /* Hide empty cells */
    self.destinationsTable.tableFooterView = [[UIView alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(reloadNDD) {
        /* Start animation and load list of targets from NDD */
        destinationsList = nil;
        [self.nddLoadingIndicator startAnimating];
        IGGuideManager *guideManager = [IGGuideManager sharedManager];
        guideManager.positioningDelegate = self;
        
        [self.destinationsTable reloadData];
        self.mapButton.enabled = NO;

        [guideManager setNDDUrl:self.nddURL];
        
    } else if([self.destinationsTable indexPathForSelectedRow]){
        [self.destinationsTable deselectRowAtIndexPath:[self.destinationsTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)setNddURL:(NSURL *)nddURL
{
    _nddURL = nddURL;
    reloadNDD = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IGGuideManager *guideManager = [IGGuideManager sharedManager];
    guideManager.positioningDelegate = nil;
}
#pragma mark - IGPositioningDelegate
- (void)guideManagerDidLoadNDD:(IGGuideManager *)manager
{
    NSDictionary *destinationsJson = [manager getNDDProperty:@"targets"];
    destinationsList = [[destinationsJson allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.destinationsTable reloadData];
    [self.nddLoadingIndicator stopAnimating];
    self.mapButton.enabled = YES;
    reloadNDD = NO;
}

- (void)guideManager:(IGGuideManager *)manager didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc ] initWithTitle:@"Loading failed"
                                 message:[NSString stringWithFormat:@"Failed to load the positioning file: %@", error]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles: nil] show];

    [self.nddLoadingIndicator stopAnimating];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController* mapView = segue.destinationViewController;
    NSIndexPath *indexPath = [self.destinationsTable indexPathForSelectedRow];

    
    if(indexPath && indexPath.row >= 0 && indexPath.row < destinationsList.count) {
        NSString *destination = [destinationsList objectAtIndex:indexPath.row];
        NSLog(@"Destination %@",destination);
        
        mapView.routingDestination = destination;
    } else {
        mapView.routingDestination = nil;
    }
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.destinationsTable) {
        return [destinationsList count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DestinationCell"];
    if(cell) {
        cell.textLabel.text = [destinationsList objectAtIndex:indexPath.row];
    }
    return cell;
}

@end
