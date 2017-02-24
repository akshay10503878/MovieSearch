//
//  ViewController.m
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultTableViewCell.h"
#import "MovieDetails.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MovieDetailViewController.h"

@interface ViewController ()
{
    UIActivityIndicatorView *spinner;
    Boolean loadingData ;
    NSMutableArray *searchResultArray;
    Boolean isNextPageAvailabe;
    int pageno;
    SearchResultDownloader *sRdataDownloader;

    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    loadingData = false;
    searchResultArray=[[NSMutableArray alloc] init];
    [self initFooterView];
    sRdataDownloader=[SearchResultDownloader sharedInstance];
    sRdataDownloader.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowError) name:@"Error" object:nil];
    [self.activityIndicator setHidesWhenStopped:true];
    [self.activityIndicator stopAnimating];
    


}


-(void)ShowError
{
    [self.activityIndicator stopAnimating];
    isNextPageAvailabe=false;
    pageno=1;
    loadingData=false;
    [searchResultArray removeAllObjects];
    [self.searchResultTAbleView reloadData];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"ERROR!"
                                  message:@"Search Again"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Do some thing here
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                  // [self.RefreshQuiz sendActionsForControlEvents:UIControlEventTouchUpInside];
                                   
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}



-(void)initFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.searchResultTAbleView.layer.bounds.size.width, 60.0)];
    
   spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.frame = CGRectMake(self.searchResultTAbleView.layer.bounds.size.width/2, 5.0, 50.0, 50.0);
    spinner.hidesWhenStopped = YES;
    [footerView addSubview:spinner];
    [self.searchResultTAbleView setTableFooterView:footerView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([[segue identifier] isEqualToString:@"DetailViewControllerSegue"]) {
        MovieDetailViewController *vc=[segue destinationViewController];
        //(DetailViewController *)[[segue destinationViewController] topViewController];
        NSIndexPath *indexPath = [self.searchResultTAbleView indexPathForSelectedRow];
        vc.mdetails=[searchResultArray objectAtIndex:indexPath.row];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SearchResultTableViewCell" forIndexPath:indexPath];
   
    if (cell==nil) {
   
        cell=[[SearchResultTableViewCell alloc] init];
    }

    MovieDetails *md=[searchResultArray objectAtIndex:indexPath.row];
    cell.movieTitle.text=md.title;
    cell.year_release.text=md.year;
    [cell.poster sd_setImageWithURL:[NSURL URLWithString:md.poster_url]                 placeholderImage:[UIImage imageNamed:@"No_Image.png"]];
    
    if (isNextPageAvailabe && !loadingData && indexPath.row == [searchResultArray count]-1 ){
        [spinner startAnimating];
        loadingData = true;
        [self refreshResults2];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{


}

-(void) refreshResults2 {
    
            [sRdataDownloader DownloadDataForURL:[NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json&type=movie&page=%d",self.searchText.text,pageno]];
    
    
}


-(void)DownLoadCompletedWithData:(NSDictionary *)searchResult{
    
    NSDictionary *result;
    if (![[searchResult allKeys] containsObject:@"Search"]) {
        [self ShowError];
        return;
    }
    result=[searchResult objectForKey:@"Search"];
    
    
    if ([searchResultArray count]==0) {
        if ([result count]==0) {
            //show no result found
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"No Result Found!"
                                              message:@"Search Again"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               //Do some thing here
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                [spinner stopAnimating];
                [self.activityIndicator stopAnimating];
            });
            
            return;
        }
    }
    
    
    
    if ([searchResult valueForKey:@"totalResults"]) {
        if ([[searchResult valueForKey:@"totalResults"] integerValue]>[searchResultArray count]+[result count]) {
            isNextPageAvailabe=true;
            pageno=pageno+1;
        }
        else
        {
            isNextPageAvailabe=false;
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        
    [self.searchResultTAbleView beginUpdates];
    for (NSDictionary *obj in result) {
        MovieDetails *md=[[MovieDetails alloc] init];
        md.title=[obj valueForKey:@"Title"];
        md.year=[obj valueForKey:@"Year"];
        md.imdbID=[obj valueForKey:@"imdbID"];
        md.poster_url=[obj valueForKey:@"Poster"];
        [searchResultArray addObject:md];
        [self.searchResultTAbleView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[searchResultArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        [self.searchResultTAbleView endUpdates];
        
        [self.activityIndicator stopAnimating];
        [spinner stopAnimating];
        loadingData = false;
    });


}

- (IBAction)SearchButtonPressed:(id)sender {
    
    if ([self.searchText.text length]>2) {
        
        [self.activityIndicator startAnimating];
        isNextPageAvailabe=false;
        pageno=1;
        loadingData=false;
        [searchResultArray removeAllObjects];
        [self.searchResultTAbleView reloadData];
         [sRdataDownloader DownloadDataForURL:[NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json&type=movie",self.searchText.text]];
        
    }
    else
    {
        //error enter min 2 letter word
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Invalid String!"
                                      message:@"word should contain min 3 letter"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

@end
