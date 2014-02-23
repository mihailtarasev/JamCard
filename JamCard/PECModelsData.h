//
//  PECModelsData.h
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECModelSettings.h"

@interface PECModelsData : NSObject

// Модель данных карточек
+(NSMutableArray*)getModelCard;
+(void)setModelCard: (NSMutableArray*)obj;

// Модель данных акции
+(NSMutableArray*)getModelAction;
+(void)setModelAction: (NSMutableArray*)obj;

// Модель данных пользователей
+(NSMutableArray*)getModelUser;
+(void)setModelUser: (NSMutableArray*)obj;

// Модель данных партнеров
+(NSMutableArray*)getModelPartners;
+(void)setModelPartners: (NSMutableArray*)obj;

// Модель данных ближайших к пользователю партнеров
+(NSMutableArray*)getModelPartnersByLoc;
+(void)setModelPartnersByLoc: (NSMutableArray*)obj;

// Модель данных объектов партнеров
+(NSMutableArray*)getModelPoints;
+(void)setModelPoints: (NSMutableArray*)obj;

// Идентификатор пользователя
+(int)getUserId;
+(void)setUserId: (int)uId;

// Модель данных объектов настроек
+(PECModelSettings*)getModelSettings;
+(void)setModelSettings: (PECModelSettings*)obj;

// Новости пользователя
+(NSMutableArray*)getModelNewsPartner;
+(void)setModelNewsPartner: (NSMutableArray*)pId;

// Категории партнеров
+(NSMutableArray*)getModelCategory;
+(void)setModelCategory: (NSMutableArray*)obj;

@end
