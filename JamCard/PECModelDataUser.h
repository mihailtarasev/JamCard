//
//  PECModelDataUser.h
//  JamCard
//
//  Created by Admin on 12/4/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelDataUser : PECMainModel


@property int usRegistration;
@property int idUser;

@property (strong, nonatomic) NSString *usName;
@property (strong, nonatomic) NSString *usFamily;
@property (strong, nonatomic) NSString *usDate;
@property (strong, nonatomic) NSString *usMail;
@property (strong, nonatomic) NSString *usSex;
@property (strong, nonatomic) NSString *usTelephone;
@property (strong, nonatomic) NSString *usPromo;
@property (strong, nonatomic) NSString *usScore;

@end
