//
//  PECModelsData.m
//  JamCard
//
//  Created by Admin on 12/30/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECModelsData.h"
#import "PECModelDataCards.h"
#import "PECModelSettings.h"

// Модель данных карточек
static NSMutableArray *MODEL_CARDS;

// Модель данных акции
static NSMutableArray *MODEL_ACTIONS;

// Модель данных пользователей
static NSMutableArray *MODEL_USERS;

// Модель данных партнеров
static NSMutableArray *MODEL_PARTNERS;

// Модель данных ближайших к пользователю партнеров
static NSMutableArray *MODEL_PARTNERS_BY_LOC;

// Модель данных объектов партнеров
static NSMutableArray *MODEL_POINTS;

// Идентификатор пользователя
static int USER_ID;

// Новости пользователя
static NSMutableArray *PARTNER_NEWS;

// Модель данных объектов настроек
static  PECModelSettings *MODEL_SETTINGS;

// Модель данных объектов Категории партнеров
static  NSMutableArray *MODEL_CATEGORY;

@implementation PECModelsData


+(NSMutableArray*)getModelCard{ return [MODEL_CARDS copy];}
+(void)setModelCard: (NSMutableArray*)obj{MODEL_CARDS = obj;}

// Модель данных акции
+(NSMutableArray*)getModelAction{ return [MODEL_ACTIONS copy];}
+(void)setModelAction: (NSMutableArray*)obj{ MODEL_ACTIONS = obj; }

// Модель данных пользователей
+(NSMutableArray*)getModelUser{ return [MODEL_USERS copy];}
+(void)setModelUser: (NSMutableArray*)obj{ MODEL_USERS = obj;}

// Модель данных партнеров
+(NSMutableArray*)getModelPartners{ return [MODEL_PARTNERS copy];}
+(void)setModelPartners: (NSMutableArray*)obj{ MODEL_PARTNERS = obj; }

// Модель данных ближайших к пользователю партнеров
+(NSMutableArray*)getModelPartnersByLoc{ return [MODEL_PARTNERS_BY_LOC copy];}
+(void)setModelPartnersByLoc: (NSMutableArray*)obj{ MODEL_PARTNERS_BY_LOC = obj; }

// Модель данных объектов партнеров
+(NSMutableArray*)getModelPoints{ return [MODEL_POINTS copy];}
+(void)setModelPoints: (NSMutableArray*)obj{ MODEL_POINTS = obj; }

// Идентификатор пользователя
+(int)getUserId{ return USER_ID;}
+(void)setUserId: (int)uId{ USER_ID = uId; }

// Новости пользователя
+(NSMutableArray*)getModelNewsPartner{ return [PARTNER_NEWS copy];}
+(void)setModelNewsPartner: (NSMutableArray*)pId{ PARTNER_NEWS = pId; }

// Модель данных объектов настроек
+(PECModelSettings*)getModelSettings{ return MODEL_SETTINGS; }
+(void)setModelSettings: (PECModelSettings*)obj{ /*NSLog(@"obj %i",obj.idCountry);*/ MODEL_SETTINGS = obj; }

// Категории партнеров
+(NSMutableArray*)getModelCategory{ return MODEL_CATEGORY; }
+(void)setModelCategory: (NSMutableArray*)obj{ MODEL_CATEGORY = obj; }

@end
