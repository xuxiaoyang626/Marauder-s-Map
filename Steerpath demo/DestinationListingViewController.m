//
//  DestinationListingViewController.m
//  Steerpath demo
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "DestinationListingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <IndoorGuide/IGGuideManager.h>
#import "MapViewController.h"
#import "DownloadHelper.h"

#define API_KEY @"AIzaSyDhxAjI3GXDX4lKGLu_SxdvuHetCGPNNbM"
#define SAMPLE_RATE 16000

@interface DestinationListingViewController ()<IGPositioningDelegate, UITableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSArray *destinationsList;
    NSMutableArray *filterList;
    BOOL filtered;
    BOOL reloadNDD;
}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation DestinationListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.destinationsTable.dataSource = self;

    /* Hide empty cells */
    self.destinationsTable.tableFooterView = [[UIView alloc] init];
    
    filtered = NO;
    self.searchBar.delegate = (id)self;
    
    /* record init */
    NSURL *soundFileURL = [NSURL fileURLWithPath:[self soundFilePath]];
    NSDictionary *recordSettings = @{AVEncoderAudioQualityKey:@(AVAudioQualityMax),
                                     AVEncoderBitRateKey: @16,
                                     AVNumberOfChannelsKey: @1,
                                     AVSampleRateKey: @(SAMPLE_RATE)};
    NSError *error;
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
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
        filterList = nil;
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

    if(filtered) {
        if(indexPath && indexPath.row >= 0 && indexPath.row < filterList.count) {
            NSString *destination = [filterList objectAtIndex:indexPath.row];
            NSLog(@"Destination %@",destination);
            
            mapView.routingDestination = destination;
        } else {
            mapView.routingDestination = nil;
        }
    } else {
        if(indexPath && indexPath.row >= 0 && indexPath.row < destinationsList.count) {
            NSString *destination = [destinationsList objectAtIndex:indexPath.row];
            NSLog(@"Destination %@",destination);
        
            mapView.routingDestination = destination;
        } else {
            mapView.routingDestination = nil;
        }
    }
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.destinationsTable) {
        if(filtered) {
            return [filterList count];
        } else {
            return [destinationsList count];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DestinationCell"];
    if(cell) {
        if(filtered) {
            cell.textLabel.text = [filterList objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [destinationsList objectAtIndex:indexPath.row];
        }
    }
    return cell;
}



/* speech to text related */
- (NSString *) soundFilePath {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    return [docsDir stringByAppendingPathComponent:@"sound.caf"];
}

- (IBAction)recordAudio:(id)sender {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [_audioRecorder record];
}

- (IBAction)speech2text:(id)sender {
    // stop record
    if (_audioRecorder.recording) {
        [_audioRecorder stop];
    }
    
    // processAudio
    NSString *service = @"https:/speech.googleapis.com/v1/speech:recognize";
    service = [service stringByAppendingString:@"?key="];
    service = [service stringByAppendingString:API_KEY];
    
    NSData *audioData = [NSData dataWithContentsOfFile:[self soundFilePath]];
    NSDictionary *initialRequest = @{@"encoding":@"LINEAR16",
                                     @"sampleRate":@(SAMPLE_RATE),
                                     @"languageCode":@"en-US",
                                     @"maxAlternatives":@30};
    NSDictionary *audioRequest = @{@"content":[audioData base64EncodedStringWithOptions:0]};
    NSDictionary *requestDictionary = @{@"initialRequest":initialRequest,
                                        @"audioRequest":audioRequest};
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary
                                                          options:0
                                                            error:&error];
    
    NSString *path = service;
    NSURL *URL = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSString *contentType = @"application/json";
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithRequest:request
     completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            // NSString *stringResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            // _searchBar.text = stringResult;
                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            self.searchBar.text = json[@"responses"][0][@"results"][0][@"alternatives"][0][@"transcript"];
                            
                            if(self.searchBar.text.length == 0) {
                                filtered = NO;
                            } else {
                                filtered = YES;
                                filterList = [[NSMutableArray alloc] init];
                                
                                for(NSString *myString in destinationsList) {
                                    NSRange nameRange = [myString rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                                    if(nameRange.location != NSNotFound) {
                                        [filterList addObject:myString];
                                    }
                                }
                                
                                if(filterList == nil || [filterList count] == 0) {
                                    filtered = NO;
                                }
                            }
                            [self.destinationsTable reloadData];
                        });
     }];
    [task resume];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if(text.length == 0) {
        filtered = NO;
    } else {
        filtered = YES;
        filterList = [[NSMutableArray alloc] init];
        
        for(NSString *myString in destinationsList) {
            NSRange nameRange = [myString rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) {
                [filterList addObject:myString];
            }
        }
        
        if(filterList == nil || [filterList count] == 0) {
            filtered = NO;
        }
    }
    [self.destinationsTable reloadData];
}

@end
