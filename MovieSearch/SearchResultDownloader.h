//
//  SearchResultDownloader.h
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DownloadCompleteDelegate <NSObject>
- (void)DownLoadCompletedWithData:(NSDictionary*)searchResult ;
@end


@interface SearchResultDownloader : NSObject
+(instancetype)sharedInstance;
-(void)DownloadDataForURL:(NSString *)urlString;
@property (nonatomic, weak) id <DownloadCompleteDelegate> delegate;


@end
