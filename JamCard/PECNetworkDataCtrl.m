//
//  PECNetworkDataCtrl.m
//  JamCard
//
//  Created by Admin on 1/2/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECNetworkDataCtrl.h"
#import "PECModelsData.h"
#import "PECBuilderModel.h"

// test
static NSString const *sURL_CARD_GET_ALL = @"http://paladin-engineering.ru/data/jamSon.php";

// Тестовый путь к серверу Paladin-Engineering
static NSString const * PE_URL = @"http://server.jamcard.ru:9080/jamcardmobile/jaxrs/";

// Базовый путь к серверу Jam Card
static NSString const * JAMCARD_BASE_URL = @"http://server.jamcard.ru:9080/jamcardmobile/jaxrs/";
//test
//static NSString const * JAMCARD_BASE_URL = @"http://paladin-engineering.ru/data/jamcard/";

// Модель данных карточек
static NSString const *GET_CARD_URL = @"mobilecards/get/byuser";

// Активация(выдача) электронной карты
static NSString const *ACTIVATE_CARD_URL = @"mobilecards/activate";

// deАктивация(выдача) электронной карты
static NSString const *DEACTIVATE_CARD_URL = @"mobilecards/deactivate";

// Данные карточек по идентификатору пользователя
static NSString const * GET_DATA_CARD_U_ID_URL = @"mobilecards/get/activated/byuser";//@"mobilecards/get/byuser";

// Модель данных пользователей
static NSString const *GET_USER_DATA_TELEPHONE = @"users/get/byphone";

// Модель данных партнеров
static NSString const * GET_PARTNERS_URL = @"partners/get";

// Данные партнеров которые ближе всего к пользователю
static NSString const * GET_PARTNERS_BY_LOC_URL = @"partners/get/bylocation";

// Запрос к серверу на наличие номера в базе данных
static NSString const * NUMBER_TEL_BD_URL = @"users/chktel";

// Запрос к серверу получить информацию о пользователе по номеру телефона
static NSString const * GET_DATA_NUMBER_TEL_URL = @"users/get/byphone";

// Запрос к серверу для регистрации нового пользователя в системе
static NSString const * ADD_NEW_USER_URL = @"users/add";

// Запрос к серверу получить информацию о пользователе по u_id
static NSString const * GET_DATA_NUMBER_UID_URL = @"users/get/byid";

// Запрос к серверу получить информацию про все спецпредложения
static NSString const * GET_ALL_MSO_URL = @"mso/get";

// Запрос к серверу получить новости партера
static NSString const * GET_NEWS_PARTNER = @"news/get/bypartner";

// Запрос к серверу для получения всех категории партнеров
static NSString const * GET_CATEGORY_PARTNERS_URL = @"partners/get/types";

// Запрос к серверу для Активации(выдачи) специального предложения
static NSString const * ACTIVATE_ACTION_URL = @"mso/activate";

// Запрос к серверу для получения всех спец предложении пользователя
static NSString const * GET_ALL_ACTION_URL = @"mso/get/activated/byuser";

// Запрос к серверу для получения ближайших спец предложении пользователя
static NSString const * GET_LOC_ACTION_URL = @"mso/get/bylocation";

// Запрос к серверу для подтверждения номера телефона через СМС
static NSString const * GET_SMS_AUTH_URL = @"users/smsconfirm";


@implementation PECNetworkDataCtrl{
    NSData *responseData;
    NSError *gError;
}

// СИСТЕМНЫЕ

// Сообщения
+(void)cellAlertMsg:(NSString*)msg
{
    UIAlertView *autoAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
    
    autoAlertView.transform = CGAffineTransformMake(1.0f, 0.5f, 0.0f, 1.0f, 0.0f, 0.0f);
    [autoAlertView performSelector:@selector(dismissWithClickedButtonIndex:animated:)
                        withObject:nil
                        afterDelay:1.0f];
    [autoAlertView show];
}

// Асинхронный Get запрос к серверу
- (void)asynchronousRequestJamCard:(NSString*) url params: (NSString*) params callback:(void (^)(id)) callback
{
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc]
                                              initWithURL:[[NSURL alloc] initWithString:url]]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         responseData = data;
         callback(self);
     }];
}

// Асинхронный Post/Put запрос к серверу
- (void)asynPostReqJamCard:(NSString*)metod url: (NSURL*) url params: (NSString*) params callback:(void (^)(id)) callback
{
    NSString *post =[[NSString alloc] initWithFormat:@"%@",params];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:metod];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         gError = error;
         responseData = nil;
         responseData = data;
         
         callback(self);
     }];
}

// ПАРТНЕРЫ

// Скачивание данных всех "Партнеров" с сервера и запись их в модель данных
- (void)getPartnerDataServer: (NSString*) cityId callback:(void (^)(int)) callback
{
    NSString *params = nil;
    //if(cityId != nil)
    //    params = [NSString stringWithFormat:@"city_id=%@",cityId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_PARTNERS_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        
                        int resp = 0;
                        if(responseData!=NULL) resp = 1;
                        
                        [PECModelsData setModelPartners:[PECBuilderModel parserJSONPartners:responseData error:&nError]];
                        //[PECBuilderModel parserJSONPoints:[PECModelsData getModelPartners] error:&nError];
                        callback(resp);
                    }];
}


// Скачивание данных "Партнеров ближайших к пользователю" с сервера и запись их в модель данных
- (void)getPartnerByLocDataServer: (int) cityId addrLong: (double) addrLong addrLat: (double) addrLat callback:(void (^)(id)) callback
{
    NSString *params = nil; cityId = 1;
    NSString *addrLat2 = [NSString stringWithFormat:@"%f", addrLat];
    NSString *addrLong2 = [NSString stringWithFormat:@"%f", addrLong];
    params = [NSString stringWithFormat:@"{address_longitude:%@l,address_latitude:%@l,city_id:%i}",addrLat2, addrLong2, cityId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_PARTNERS_BY_LOC_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelPartnersByLoc:[PECBuilderModel parserJSONPartnersByLoc:responseData error:&nError]];
                        callback(self);
                    }];
}


// Скачивание новостей "Партнера" с сервера
- (void)getPartnerNewsServer: (int) partnerId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{mp_id:%d}", partnerId];
    
    //NSLog(@"partnerId %d", partnerId);
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_NEWS_PARTNER]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        
                        [PECModelsData setModelNewsPartner:[PECBuilderModel parserJSONPartnersNews:responseData error:&nError]];
                        
                        callback(self);
                    }];
}


// КАРТОЧКИ

// Скачивание данных карточек в соответствии с данными от пользователя по его u_id
- (void)getCardUserDataServer: (int) userId callback:(void (^)(id)) callback
{
    //NSLog(@"userId %d",userId);
    
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{u_id:%d}",userId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_DATA_CARD_U_ID_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelCard:[PECBuilderModel parsJSONCardPartnerInfo: responseData error:&nError]];
                        
                        //NSLog(@"!!!!!");
                        
                        callback(self);
                    }];
}

// Скачивание данных всех "Карточек" с сервера и запись их в модель данных
- (void)getCardDataServer: (NSString*) userId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    if(userId != nil)
        params = [NSString stringWithFormat:@"{u_id:%@}",userId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_CARD_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelPartners:[PECBuilderModel parserJSONPartners:responseData error:&nError]];
                        //[PECBuilderModel parserJSONPoints:[PECModelsData getModelPartners] error:&nError];
                        callback(self);
                    }];
}

// ПОЛЬЗОВАТЕЛЬ
/*
// Скачивание данных "Пользователя" с сервера и запись их в модель данных
- (void)getUserDataServer: (NSString*) params callback:(void (^)(id)) callback
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_USER_DATA_TELEPHONE]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:nil
                    callback:^(id sender){
                        NSError *nError;
                        [PECModelsData setModelUser:[PECBuilderModel parserJSONUsers:responseData error:&nError]];
                        callback(self);
                    }];
}*/

// Запрос к серверу на наличие номера в базе данных
- (void)numTelInDataServer: (NSString*) userTel callback: (int (^)(int)) callback
{
    NSString *params = nil;
    if(userTel != nil)
        params = [NSString stringWithFormat:@"{u_telephone:%@}",userTel];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, NUMBER_TEL_BD_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        int numSMSEq = [PECBuilderModel parserNumTelInDB:responseData error:&nError];
                        callback(numSMSEq);
                    }];
}

// Запрос к серверу для получения информации о пользователе по его номеру телефона
- (void)getUserInfoAtTelDServer: (NSString*) userTel callback:(void (^)(id)) callback
{
    NSString *params = nil;
    if(userTel != nil)
        params = [NSString stringWithFormat:@"{u_telephone:%@}",userTel];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_DATA_NUMBER_TEL_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelUser:[PECBuilderModel parserJSONUsers:responseData userTel: (NSString*)userTel error:&nError]];
                        callback(self);
                    }];
}
/*
// Запрос к серверу для получения информации о пользователе по его u_id
- (void)getUserInfoAtUIdDServer: (int) userId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{u_id:%d}",userId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_DATA_NUMBER_UID_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError;
                        [PECModelsData setModelUser:[PECBuilderModel parserJSONUsers:responseData error:&nError]];
                        callback(self);
                    }];
}
 */

// Запрос к серверу для регистрации нового пользователя в системе
- (void)addNewUserServer: (NSArray*) userInfo callback:(void (^)(id)) callback
{
    NSString *params = nil;
    if(userInfo != nil)
        params = [NSString stringWithFormat:@"{u_telephone:\"%@\",u_email:\"%@\",u_name:\"%@\",u_family:\"%@\",u_sex:%@,u_birthday:\"%@\"}"
                  ,userInfo[0],userInfo[1],userInfo[2],userInfo[3],userInfo[4],userInfo[5]];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, ADD_NEW_USER_URL]];
    [self asynPostReqJamCard:@"PUT"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        // return u_id
                        int userId = [PECBuilderModel parserAddUserU_ID:responseData error:&nError];
                        [PECModelsData setUserId:userId];
                        callback(self);
                    }];
}


// Запрос к серверу для Активации(выдачи) электронной карты
- (void)activateCardServer:(int) cardId userId: (int) userId callback:(void (^)(NSArray*)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{mp_id:%d,u_id:%d}",cardId, userId];
    
    //NSLog(@"params %@",params);
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, ACTIVATE_CARD_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        
                        NSError *nError = gError;
                        NSArray *data = [PECBuilderModel getArrayFromJsonDataServer:responseData error:&nError];//[[NSArray alloc]initWithObjects:, nil];
                        callback(data);
                    }];
}

// Запрос к серверу для deАктивации(выдачи) электронной карты
- (void)deActivateCardServer:(int) cardId userId: (int) userId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{mp_id:%d,u_id:%d}",cardId, userId];
    
      //  NSLog(@"params %@",params);
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, DEACTIVATE_CARD_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        callback(self);
                    }];
}

// Запрос к серверу для получения всех категории партнеров
- (void)getCategoryPartnersDServer:(void (^)(int)) callback
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_CATEGORY_PARTNERS_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:nil
                    callback:^(id sender){
                        NSError *nError = gError;
                        
                        int resp = 0;
                        if(responseData!=NULL) resp = 1;
                        
                        [PECModelsData setModelCategory:[PECBuilderModel parserJSONCategory:responseData error:&nError]];
                        callback(resp);
                    }];
}

// СПЕЦИАЛЬНЫЕ ПРЕДЛОЖЕНИЯ

// Скачивание данных всех "Спецпредложений" с сервера и запись их в модель данных
- (void)getAllMSODataServer:(void (^)(id)) callback
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_ALL_MSO_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:nil
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelAction:[PECBuilderModel parserJSONActions:responseData error:&nError]];
                        callback(self);
                    }];
}


// Запрос к серверу для получения ближайших к пользователю спец предложении
- (void)getLocActionUserDServer: (int) cityId addrLong: (double) addrLong addrLat: (double) addrLat callback:(void (^)(id)) callback
{
    NSString *params = nil; cityId = 1;
    NSString *addrLat2 = [NSString stringWithFormat:@"%f", addrLat];
    NSString *addrLong2 = [NSString stringWithFormat:@"%f", addrLong];
//    params = [NSString stringWithFormat:@"{address_longitude:%@l,address_latitude:%@l,city_id:%i}",addrLat2, addrLong2, cityId];
    params = [NSString stringWithFormat:@"{address_longitude:\"%@\",address_latitude:\"%@\",city_id:%i}",addrLat2, addrLong2, cityId];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_LOC_ACTION_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelAction:[PECBuilderModel parserJSONActions:responseData error:&nError]];
                        callback(self);
                    }];
}


// Запрос к серверу для получения всех спец предложении пользователя
- (void)getALLActionUserDServer: (int) userId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{u_id:%d}",userId];
    
    //NSLog(@"params %@",params);
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_ALL_ACTION_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        
                        [PECModelsData setModelAction:[PECBuilderModel parserJSONActionsFromUserId:responseData error:&nError]];
                        
                        callback(self);
                    }];
}


// Запрос к серверу для Активации(выдачи) специального предложения
- (void)activateActionServer:(int) actionId userId: (int) userId callback:(void (^)(id)) callback
{
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{u_id:%d,mso_id:%d}",userId, actionId];
    
    //NSLog(@"params %@",params);
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, ACTIVATE_ACTION_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        NSError *nError = gError;
                        [PECModelsData setModelAction:[PECBuilderModel parserJSONActionsFromUserId:responseData error:&nError]];
                        callback(self);
                    }];
}

// ~ SMS

// Запрос к серверу для подтверждения номера телефона через СМС
- (void)smsAutServer:(NSString*) u_telephone confirm_code: (NSString*) confirm_code callback:(void (^)(id)) callback
{
    
    NSString *params = nil;
    params = [NSString stringWithFormat:@"{u_telephone:\"%@\",confirm_code:\"%@\"}",u_telephone, confirm_code];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JAMCARD_BASE_URL, GET_SMS_AUTH_URL]];
    [self asynPostReqJamCard:@"POST"
                         url:url
                      params:params
                    callback:^(id sender){
                        //NSError *nError;
                        callback(self);
                    }];
}



// ТЕСТИРОВАНИЕ

// !Тестовая функция
// Скачивание данных всех карточек пользователя с сервера и запись их в модель данных
- (void)getDataAtCardURL:(void (^)(id)) callback
{
    NSString *urlAsString = [NSString stringWithFormat:@"%@?%@",sURL_CARD_GET_ALL, nil];
    [self asynchronousRequestJamCard:urlAsString params:nil callback:^(id sender)
     {
         //NSLog(@"responseData3 %@", responseData);
         NSError *nError = gError;
         [PECModelsData setModelCard:[PECBuilderModel groupsFromJSON:responseData error:&nError objectModel:@"PECModelDataCards"]];
         callback(self);
     }];
}



//   NSString *urlAsString = [NSString stringWithFormat:@"http://paladin-engineering.ru/data/jamSon.php?lat=%f&lon=%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];


@end
