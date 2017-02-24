//
//  MovieDetailViewController.h
//  MovieSearch
//
//  Created by akshay bansal on 2/25/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDetails.h"
#import "SearchResultDownloader.h"

@interface MovieDetailViewController : UIViewController<DownloadCompleteDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *movie_poster;
@property (strong, nonatomic) IBOutlet UILabel *movieName;
@property (strong, nonatomic) IBOutlet UILabel *genre;
@property (strong, nonatomic) IBOutlet UILabel *release_Date;
@property (strong, nonatomic) IBOutlet UILabel *imdb_Rating;
@property (strong, nonatomic) IBOutlet UILabel *plot;
@property (strong, nonatomic) MovieDetails *mdetails;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mdetailActivityIndicator;
- (IBAction)backButtonPressed:(id)sender;

@end
