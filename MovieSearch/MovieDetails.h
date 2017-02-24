//
//  MovieDetails.h
//  MovieSearch
//
//  Created by akshay bansal on 2/24/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDetails : NSObject

@property(nonatomic,strong)NSString* imdbID;
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* genre;
@property(nonatomic,strong)NSString* poster_url;
@property(nonatomic,strong)NSString* released;
@property(nonatomic,strong)NSString* plot;
@property(nonatomic,strong)NSString* imdbRaiting;
@property(nonatomic,strong)NSString* imdbVotes;
@property(nonatomic,strong)NSString* year;
@property(nonatomic,strong)NSData* data;


@end
