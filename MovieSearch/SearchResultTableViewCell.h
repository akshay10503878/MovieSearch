//
//  SearchResultTableViewCell.h
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UILabel *year_release;
@property (strong, nonatomic) IBOutlet UIImageView *poster;

@end
