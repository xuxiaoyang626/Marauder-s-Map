//
//  VenueListingViewController.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "VenueListingViewController.h"
#import "DownloadHelper.h"
#import "DestinationListingViewController.h"
#import "InformationViewController.h"

@interface VenueListingViewController ()<UITableViewDataSource>
{
    NSArray *venuesJsonArray;
}
@end

@implementation VenueListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* Hide empty cells */
    self.venueTable.tableFooterView = [[UIView alloc] init];

    self.venueTable.dataSource = self;
    
    NSString *nddOverride = [[NSUserDefaults standardUserDefaults] stringForKey:@"ndd_key"];
    if(nddOverride != nil && [nddOverride isEqualToString:@""] == NO) {
        if([nddOverride hasSuffix:@".ndd"]) {
            nddOverride = [nddOverride substringToIndex:[nddOverride length] - 4];
        }
        NSString *nddUrlString = nil;
        NSString *nddResourcePath = [[NSBundle mainBundle] pathForResource:nddOverride ofType:@"ndd"];
        if(nddResourcePath != nil) {
            nddUrlString = [[NSURL fileURLWithPath:nddResourcePath] absoluteString];
        } else {
            nddUrlString = [NSString stringWithFormat:@"https://s3-eu-west-1.amazonaws.com/ndd/%@.ndd", nddOverride];
        }
        
        venuesJsonArray = @[ @{
                                 @"title":[NSString stringWithFormat:@"Using Map: %@",nddOverride],
                                 @"ndd": nddUrlString,
                                 } ];
    } else {
        NSString *venueListDownloadUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"venue_list_url"];
        venuesJsonArray = [DownloadHelper getJSONArray:venueListDownloadUrl];
        if(!venuesJsonArray) {
            [DownloadHelper removeFromCache:venueListDownloadUrl];
        }
    }
    
    if(!venuesJsonArray) {
        [[[UIAlertView alloc ] initWithTitle:@"No venue list"
                                     message:@"Failed to load the venue list"
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles: nil] show];
    }
    [self.listLoadingIndicator stopAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.venueTable deselectRowAtIndexPath:[self.venueTable indexPathForSelectedRow] animated:animated];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(sender == self.informationButton) {
        InformationViewController *iView = segue.destinationViewController;
        iView.urlString = kAppInfoURL;
    } else {
        NSIndexPath *path = [self.venueTable indexPathForSelectedRow];
        NSDictionary *venueJson = [venuesJsonArray objectAtIndex:path.row];
    
        DestinationListingViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.nddURL = [NSURL URLWithString:[venueJson objectForKey:@"ndd"]];

        NSLog(@"Selected venue:\n%@",venueJson);
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.venueTable) {
        return([venuesJsonArray count]);
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    if(!cell) return nil;
    
    NSDictionary *venue = [venuesJsonArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [venue objectForKey:@"title"];
    return cell;
}
@end
