//
//  PECModelDataAction.h
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelDataAction : PECMainModel

@property int idAction;
@property (strong, nonatomic) NSString *textAction;
@property (strong, nonatomic) NSString *typeAction;
@property (strong, nonatomic) NSString *cardNumberAction;
@property (strong, nonatomic) NSString *cardFormatAction;
@property int rankAction;
@property (strong, nonatomic) NSString *logoAction;
@property (strong, nonatomic) NSData *logoDataAction;

@property (strong, nonatomic) NSString *startDateAction;
@property (strong, nonatomic) NSString *endDateAction;
@property int discountAction;
@property int partnerIdAction;

@property (strong, nonatomic) NSArray *arrPoints;

@property int distAction;

@property bool activationAction;


@end
