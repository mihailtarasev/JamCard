//
//  PECBuilderModelCard.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECModelPartner.h"

@interface PECBuilderModel : NSObject

+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error objectModel: (NSString*)model;
//- (void)getDataAtCard: (NSString*)urlStr;
+ (NSMutableArray*)arrObjectsCards;
+(NSDictionary*)sortArrayAtLiters: (NSMutableArray*) arrayObjects nameKey:(NSString*) nameKey mode:(bool)mode searchText:(NSString*)searchText;

// Общий для всех запросов парсинг ошибок и данных
+ (NSArray*)getArrayFromJsonDataServer:(NSData *)objectNotation error:(NSError **)error;

+ (NSMutableArray *)parserJSONPoints:(NSArray *)objectNotation error:(NSError **)error;

// Парсер модель пользователей
+ (NSMutableArray *)parserJSONUsers:(NSData *)objectNotation userTel: (NSString*)userTel error:(NSError **)error;

// Парсер модель партнеров
+ (NSMutableArray *)parserJSONPartners:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель объектов ближайших к пользователю партнеров
+ (NSMutableArray *)parserJSONPartnersByLoc:(NSData *)objectNotation error:(NSError **)error;

// Если пользователь не авторизован и переходит на первый экран карточек
// Собираем из данных о ближайших партнерах массив карточек в порядке убывания от клиента
+ (NSMutableArray *)parsPartnerLocByCard:(NSArray *)objectNotation error:(NSError **)error;

// Собираем из данных о всех партнерах массив карточек
+ (NSMutableArray *)parsPartnerAllByCard:(NSArray *)objectNotation error:(NSError **)error;

// Парсер модель карточек заполненная информацией от партнеров
+ (NSMutableArray *)parsJSONCardPartnerInfo:(NSData *)objectNotation error:(NSError **)error;

// Парсер наличия номера телефона в базе данных
+ (int)parserNumTelInDB:(NSData *)objectNotation error:(NSError **)error;

// Парсер получения u_id при регистрации нового пользователя
+ (long)parserAddUserU_ID:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель спецпредложений
+ (NSMutableArray *)parserJSONActions:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель спецпредложений из пользовательского id
+ (NSMutableArray *)parserJSONActionsFromUserId:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель объектов НОВОСТЕЙ партнеров
+ (NSMutableArray *)parserJSONPartnersNews:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель объектов категории партнеров
+ (NSMutableArray *)parserJSONCategory:(NSData *)objectNotation error:(NSError **)error;

// Получить модель партнера по его id
+(PECModelPartner*)getModelParnterAtId: (int) idPartner;

// Идентифицирую номер в зависимости от названия города
+ (int)numCityFromItName:(NSString*)nameCity;

// Добавление экрана загрузки данных с сервера
+(void)addViewLoadingData:(UIView*) superView;

// Заполняю модель карточек информацией на основании информации о партнерах и информацией о карточках зарегестрированного пользователя
+ (void) createModelDataCardFromDataPartnerLoc: (BOOL)localication
                               autorizationUser:(BOOL)autorizationUser
                             numberCityLocation:(int)numberCityLocation
                                       addrLong:(double)addrLong
                                        addrLat:(double)addrLat
                                       callback:(void (^)(id)) callback;

// Обновление пользовательских данных
+ (void)uploadModelDataSettings:(int) countCardInView
                      idCountry:(int) idCountry
                            lat:(double) lat
                         longit:(double) longit
                     locationEn:(int) locationEn
                        autoriz:(int) autoriz
                     uploadData:(int) uploadData;

@end
