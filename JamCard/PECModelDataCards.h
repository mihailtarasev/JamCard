//
//  PECModelDataCards.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelDataCards : PECMainModel

// Поля карточки
@property int idCard;
@property (strong, nonatomic) NSString *numberCard;
@property (strong, nonatomic) NSString *formatCard;
@property int discountCard;
@property int statusCard;
@property (strong, nonatomic) NSDate *activationDateCards;
@property (strong, nonatomic) NSString *descCard;

// Поля партнеров
@property int distanceCard;
@property (strong, nonatomic) NSString *urlImgCard;
@property (strong, nonatomic) NSData *dataImgCard;
@property (strong, nonatomic) NSString *nameCompany;

@property int typeIdCard;
@property (strong, nonatomic) NSString *typeNameCard;

// Поля местоположения карточки
@property int idAddressCard;

// Отредактировать или удалить
@property (strong, nonatomic) NSString *nameCard;
@property int cardActivate;
@property (strong, nonatomic) NSString *numberPartberCard;
@property (strong, nonatomic) NSString *idUserCard;
@property (strong, nonatomic) NSString *dateActivateCard;
@property (strong, nonatomic) UIView *uiCards;




@end