//
//  PECModelPartner.h
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelPartner : PECMainModel

@property int idPartner;
@property (strong, nonatomic) NSString *namePartrner;
@property (strong, nonatomic) NSString *nickNamePartrner;
@property (strong, nonatomic) NSString *openingHoursPartrner;
@property (strong, nonatomic) NSString *descPartrner;
@property (strong, nonatomic) NSString *descShortPartrner;
@property (strong, nonatomic) NSString *emailPartrner;
@property (strong, nonatomic) NSString *licensePartrner;
@property int typeIdPartrner;
@property (strong, nonatomic) NSString *typeNamePartrner;
@property (strong, nonatomic) NSString *typeCardLogoPartrner;
@property (strong, nonatomic) NSString *logoPartrner;
@property (strong, nonatomic) NSString *logoCardPartrner;
@property (strong, nonatomic) NSString *mp_site;


@property (strong, nonatomic) NSArray *arrPoints;

@end