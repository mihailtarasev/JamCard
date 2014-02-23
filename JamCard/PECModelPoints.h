//
//  PECModelPoints.h
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"
#import "PECModelPartner.h"

@interface PECModelPoints : PECMainModel

// Адрес
@property int addressIdPartrner;
@property (strong, nonatomic) NSString *addressTextPartrner;
@property (strong, nonatomic) NSString *addressAreaPartrner;
@property (strong, nonatomic) NSString *addressMetroPartrner;
@property (strong, nonatomic) NSString *addressCityIdPartrner;
@property (strong, nonatomic) NSString *addressCityNamePartrner;
@property (strong, nonatomic) NSString *addressLatPartrner;
@property (strong, nonatomic) NSString *addressLongPartrner;
@property (strong, nonatomic) NSString *addressopenHoursPartrner;
@property (strong, nonatomic) NSString *addressTeleph1Partner;
@property (strong, nonatomic) NSString *addressTeleph2Partner;
@property (strong, nonatomic) NSString *addressTeleph3Partner;

@property (strong, nonatomic) PECModelPartner *modelPartner;

@end