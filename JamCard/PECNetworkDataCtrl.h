//
//  PECNetworkDataCtrl.h
//  JamCard
//
//  Created by Admin on 1/2/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DummyInterface)
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface PECNetworkDataCtrl : NSObject

// Скачивание данных всех карточек с сервера и запись их в модель данных
- (void)getCardDataServer: (NSString*) params callback:(void (^)(id)) callback;

// Скачивание данных всех партнеров с сервера и запись их в модель данных
- (void)getPartnerDataServer: (NSString*) params callback:(void (^)(id)) callback;

// Скачивание данных "Партнеров ближайших к пользователю" с сервера и запись их в модель данных
- (void)getPartnerByLocDataServer: (int) cityId addrLong: (double) addrLong addrLat: (double) addrLat callback:(void (^)(id)) callback;

// Скачивание данных пользователя с сервера и запись их в модель данных
- (void)getUserDataServer: (NSString*) params callback:(void (^)(id)) callback;

// Скачивание данных карточек в соответствии с данными от пользователя по его u_id
- (void)getCardUserDataServer: (int) userId callback:(void (^)(id)) callback;

// Запрос к серверу на наличие номера в базе данных
- (void)numTelInDataServer: (NSString*) userTel callback:(int (^)(int)) callback;

// Запрос к серверу для получения информации о пользователе по его номеру телефона
- (void)getUserInfoAtTelDServer: (NSString*) userTel callback:(void (^)(id)) callback;

// Запрос к серверу для регистрации нового пользователя в системе
- (void)addNewUserServer: (NSArray*) userInfo callback:(void (^)(id)) callback;

// Запрос к серверу для получения информации о пользователе по его u_id
- (void)getUserInfoAtUIdDServer: (int) userId callback:(void (^)(id)) callback;

// Скачивание данных всех "Спецпредложений" с сервера и запись их в модель данных
- (void)getAllMSODataServer:(void (^)(id)) callback;

// Запрос к серверу для Активации(выдачи) электронной карты
- (void)activateCardServer:(int) cardId userId: (int) userId callback:(void (^)(NSArray*)) callback;

// Запрос к серверу для Активации(выдачи) электронной карты
- (void)deActivateCardServer:(int) cardId userId: (int) userId callback:(void (^)(id)) callback;

// Скачивание новостей "Партнера" с сервера
- (void)getPartnerNewsServer: (int) partnerId callback:(void (^)(id)) callback;

- (void)getDataAtCardURL:(void (^)(id)) callback;

// Запрос к серверу для получения всех категории партнеров
- (void)getCategoryPartnersDServer:(void (^)(id)) callback;

// Запрос к серверу для Активации(выдачи) специального предложения
- (void)activateActionServer:(int) actionId userId: (int) userId callback:(void (^)(id)) callback;

// Запрос к серверу для получения ближайших к пользователю спец предложении
- (void)getLocActionUserDServer: (int) cityId addrLong: (double) addrLong addrLat: (double) addrLat callback:(void (^)(id)) callback;

// Запрос к серверу для получения всех спец предложении пользователя
- (void)getALLActionUserDServer: (int) userId callback:(void (^)(id)) callback;

// Запрос к серверу для подтверждения номера телефона через СМС
- (void)smsAutServer:(NSString*) u_telephone confirm_code: (NSString*) confirm_code callback:(void (^)(id)) callback;

@end