//
//  DownloadHelper.m
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import "DownloadHelper.h"
#import <CommonCrypto/CommonDigest.h>


@implementation DownloadHelper

+ (NSString *)sha1:(NSString *)stringToHash {
    const char *dataString = [stringToHash UTF8String];
    NSData *data = [NSData dataWithBytes:dataString length:strlen(dataString)];
    
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    if ( CC_SHA1([data bytes], (int)[data length], hash) ) {
        NSMutableString* output = [NSMutableString stringWithCapacity:sizeof(hash) * 2];
        for(int i = 0; i < sizeof(hash); i++) {
            [output appendFormat:@"%02x", hash[i]];
        }
        return output;
    }
    return nil;
}

+ (NSString *)getCacheFile:(NSString *)url {
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if(url) {
        return [cachesDirectory stringByAppendingPathComponent:[self sha1:url]];
    }
    return nil;
}


+(void) removeFromCache:(NSString *)url
{
    if(!url) {return;}
    /* Fetch a list of venues */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mainPath = [self getCacheFile:url];
    if ([fileManager fileExistsAtPath:mainPath])
    {
        [fileManager removeItemAtPath:mainPath error:nil];
        // TODO: Show error notificaion
    }
}

+(NSData *)get:(NSString *)url
{
    
    return [self get:url cachePolicy:DHelperRefreshCached];
    
}

+(NSData *)get:(NSString *)url cachePolicy:(enum DownloadHelperCachePolicy)policy
{
    if(!url) return nil;
    
    NSData *data = nil;
    NSString *cacheFile = [self getCacheFile:url];
    
    if(policy == DHelperUseCached || policy == DHelperRequireCached) {
        data = [NSData dataWithContentsOfFile:cacheFile options:NSDataReadingMappedIfSafe error:nil];
    }
    
    if(!data && policy != DHelperRequireCached) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data) {
            /* Storing for future use */
            [data writeToFile:cacheFile atomically:YES];
        }
    }
    
    if(data == nil && policy == DHelperRefreshCached) {
        data = [NSData dataWithContentsOfFile:cacheFile options:NSDataReadingMappedIfSafe error:nil];
    }
    return data;
}

+(NSDictionary*) getJSONDict:(NSString *)url
{
    NSDictionary *d = nil;
    NSData *venueListData = [DownloadHelper get:url];
    if(venueListData) {
        d = [NSJSONSerialization JSONObjectWithData:venueListData options:0 error:nil];
    }
    return d;
}

+(NSArray*) getJSONArray:(NSString *)url
{
    NSArray *d = nil;
    NSData *venueListData = [DownloadHelper get:url];
    if(venueListData) {
        d = [NSJSONSerialization JSONObjectWithData:venueListData options:0 error:nil];
    }
    return d;
}

@end
