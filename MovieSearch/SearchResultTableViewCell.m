//
//  SearchResultTableViewCell.m
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.poster.layer.masksToBounds=TRUE;
    self.poster.layer.cornerRadius=self.poster.layer.bounds.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
