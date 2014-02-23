//
//  PECModelPartnerByLoc.h
//  JamCard
//
//  Created by Admin on 1/2/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelPartnerByLoc : PECMainModel

@property int idPartner;
@property (strong, nonatomic) NSString *namePartrner;
@property (strong, nonatomic) NSString *descPartrner;
@property (strong, nonatomic) NSString *descShortPartrner;
@property (strong, nonatomic) NSString *openingHoursPartrner;
@property (strong, nonatomic) NSString *addrLatPartrner;
@property (strong, nonatomic) NSString *addrLongPartrner;

@property int typeIdPartrner;
@property (strong, nonatomic) NSString *typeNamePartrner;


@property int addrDistPartrner;
@property (strong, nonatomic) NSString *logoPartrner;
@property (strong, nonatomic) NSString *logoCardPartrner;

@end