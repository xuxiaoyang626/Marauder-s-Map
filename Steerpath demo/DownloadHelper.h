//
//  DownloadHelper.h
//  Marauder's Map
//
//  Created by xuxiaoyang on 7/30/16.
//  Copyright © 2016 xuxiaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject

enum DownloadHelperCachePolicy {
    DHelperUseCached,
    DHelperRefreshCached,
    DHelperRequireRefresh,
    DHelperRequireCached,
};


+ (NSString *)getCacheFile:(NSString *)url;
+ (void) removeFromCache:(NSString *)url;
+ (NSData *)get:(NSString *)url;
+ (NSData *)get:(NSString *)url cachePolicy:(enum DownloadHelperCachePolicy)policy;

+ (NSDictionary*) getJSONDict:(NSString *)url;
+ (NSArray*) getJSONArray:(NSString *)url;
@end
