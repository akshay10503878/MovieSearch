//
//  SearchResultDownloader.m
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "SearchResultDownloader.h"

@implementation SearchResultDownloader
+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)DownloadDataForURL:(NSString *)urlString
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error && data!=nil)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError=nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    
                    NSLog(@"Json Parsing Error");
                    
                }
                else {
                        [self.delegate DownLoadCompletedWithData:jsonResponse];
                }
            }
            else
            {
                NSLog(@"Response Error");
                dispatch_async(dispatch_get_main_queue(),^{[[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:nil];
                });
            }
        }
        else
        {
            NSLog(@"error : %@", error.description);
            dispatch_async(dispatch_get_main_queue(),^{[[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:nil];
            });
        }
    }] ;
    
    [postDataTask resume];
    [session finishTasksAndInvalidate];
}







@end
