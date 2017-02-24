//
//  MovieDetailViewController.m
//  MovieSearch
//
//  Created by akshay bansal on 2/25/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface MovieDetailViewController (){
    SearchResultDownloader *sRdataDownloader;
    
}

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sRdataDownloader=[SearchResultDownloader sharedInstance];
    self.movie_poster.layer.masksToBounds=true;
    self.movie_poster.layer.cornerRadius=self.movie_poster.layer.bounds.size.width/2;
    self.mdetailActivityIndicator.hidesWhenStopped=true;
    if (!self.mdetails.plot) {
        
        [sRdataDownloader DownloadDataForURL:[NSString stringWithFormat:@"https://www.omdbapi.com/?i=%@&y=&plot=short&r=json",self.mdetails.imdbID]];
        sRdataDownloader.delegate=self;
         [self.mdetailActivityIndicator startAnimating];
    }
    else
    {
        self.movieName.text=self.mdetails.title;
        self.genre.text=self.mdetails.genre;
        self.release_Date.text=self.mdetails.released;
        self.imdb_Rating.text=self.mdetails.imdbRaiting;
        self.plot.text=self.mdetails.plot;
        [self.movie_poster sd_setImageWithURL:[NSURL URLWithString:self.mdetails.poster_url]                 placeholderImage:[UIImage imageNamed:@"No_Image.png"]];
    
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DownLoadCompletedWithData:(NSDictionary *)searchResult
{
    self.mdetails.released=[searchResult valueForKey:@"Released"];
    self.mdetails.genre=[searchResult valueForKey:@"Genre"];
    self.mdetails.imdbRaiting=[searchResult valueForKey:@"imdbRating"];
    self.mdetails.plot=[searchResult valueForKey:@"Plot"];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        [self.mdetailActivityIndicator stopAnimating];
        self.movieName.text=self.mdetails.title;
        self.genre.text=self.mdetails.genre;
        self.release_Date.text=self.mdetails.released;
        self.imdb_Rating.text=self.mdetails.imdbRaiting;
        self.plot.text=self.mdetails.plot;
        [self.movie_poster sd_setImageWithURL:[NSURL URLWithString:self.mdetails.poster_url]                 placeholderImage:[UIImage imageNamed:@"No_Image.png"]];
        
    });

}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
