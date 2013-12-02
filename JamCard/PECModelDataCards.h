//
//  PECModelDataCards.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECModelDataCards : NSObject

@property int progrId;
@property (strong, nonatomic) NSString *idCard;
@property (strong, nonatomic) NSString *numberCard;
@property (strong, nonatomic) NSString *formatCard;
@property (strong, nonatomic) NSString *numberPartberCard;
@property (strong, nonatomic) NSString *statusCard;
@property (strong, nonatomic) NSString *idUserCard;
@property (strong, nonatomic) NSString *descCard;
@property (strong, nonatomic) NSString *dateActivateCard;
@property (strong, nonatomic) NSString *urlImgCard;
@property (strong, nonatomic) NSData *dataImgCard;

@end