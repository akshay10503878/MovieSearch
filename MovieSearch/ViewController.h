//
//  ViewController.h
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultDownloader.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DownloadCompleteDelegate>

@property (strong, nonatomic) IBOutlet UITableView *searchResultTAbleView;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UIImageView *activityIndicatorImage;

@end

