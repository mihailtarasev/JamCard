//
//  PECModelNews.h
//  JamCard
//
//  Created by Admin on 1/7/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelNews : PECMainModel

@property int idNews;
@property (strong, nonatomic) NSString *newsTitle;
@property (strong, nonatomic) NSString *newsText;
@property (strong, nonatomic) NSString *newsDate;

@end