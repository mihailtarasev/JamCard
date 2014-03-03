//
//  PECBuilderModelCard.m
//  JamCard
//
//  Created by Admin on 11/28/13.  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECBuilderModel.h"
#import "PECModelDataCards.h"
#import "PECMainModel.h"
#import "PECModelPartner.h"
#import "PECModelPoints.h"
#import "PECModelDataUser.h"
#import "PECModelPartnerByLoc.h"
#import "PECModelsData.h"
#import "PECModelDataAction.h"
#import "PECBuilderCards.h"
#import "PECNetworkDataCtrl.h"
#import "PECModelNews.h"
#import "PECModelPartner.h"
#import "PECModelCategoty.h"

@implementation PECBuilderModel

static NSMutableArray* sArrObjectsCards;

// Static Data from Cards
+(NSMutableArray*)arrObjectsCards{ return [sArrObjectsCards copy];}

// Parser JSON OBJECT

// Общий для всех запросов парсинг ошибок и данных
+ (NSArray*)getArrayFromJsonDataServer:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [[NSArray alloc]init];
    
    if(objectNotation==nil){NSLog(@"Warning: objectNotation == nil"); return data;}
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    // Если не возврощает блок данных инициируем плохой запрос и разбираем ошибки
    if(parsedObject.count<=2)
    {
        NSString *errorCode = [parsedObject valueForKey:@"error_code"];
        NSString *errorMsg = [parsedObject valueForKey:@"error_msg"];
        NSLog(@"errorCode:%@ errorMsg:%@",errorCode,errorMsg);
        
        //data = [parsedObject valueForKey:@"error_code"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if([errorCode isEqualToString:@"6"])
                    [self cellAlertMsg:@"Такой телефонный номер уже существует"];
                
                if([errorCode isEqualToString:@"7"])
                    [self cellAlertMsg:@"Эл почта с таким именем уже существует"];

                if([errorCode isEqualToString:@"9"])
                    [self cellAlertMsg:@"Нет свободных карточек"];

                
                if([errorCode isEqualToString:@"10"])
                    [self cellAlertMsg:@"Карточка уже активирована"];
                
                if([errorCode isEqualToString:@"13"])
                    [self cellAlertMsg:@"Нет свободных спецпредложений"];
                
                if([errorCode isEqualToString:@"15"])
                    [self cellAlertMsg:@"Срок действия специального предложения истек"];
                
                if([errorCode isEqualToString:@"21"])
                    [self cellAlertMsg:@"Неверно введена электронная почта"];

            });
        });
        
        return nil;
    }else

    if (localError != nil)
    {
        *error = localError;
        NSLog(@"localError %@", localError);
        return false;
    }else
        data = [parsedObject valueForKey:@"data"];
    
    return data;
}

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
                        afterDelay:2.0f];
    [autoAlertView show];
}

// Парсер модель пользователей
+ (NSMutableArray *)parserJSONUsers:(NSData *)objectNotation userTel: (NSString*)userTel error:(NSError **)error
{
    NSArray *data = [[NSArray alloc]initWithObjects:[self getArrayFromJsonDataServer:objectNotation error:error], nil];
    
    if([data[0] count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelDataUser *resParse   = [[PECModelDataUser alloc]init];
        
        resParse.idUser     = [items[@"u_id"] integerValue];
        resParse.usName     = items[@"u_name"];
        resParse.usFamily   = items[@"u_family"];
        resParse.usDate     = items[@"u_birthday"];
        resParse.usMail     = items[@"u_email"];
        
        resParse.usTelephone = userTel;
        resParse.usSex      = items[@"u_sex"];
        resParse.usScore    = items[@"u_score"];
        resParse.usPromo    = items[@"u_promo"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер наличия номера телефона в базе данных
+ (int)parserNumTelInDB:(NSData *)objectNotation error:(NSError **)error
{
    BOOL isUniq = false;
    BOOL smsEn = false;
    NSArray *data = [[NSArray alloc]initWithObjects:[self getArrayFromJsonDataServer:objectNotation error:error], nil];
    
    if([data[0] count]==0) return true;
    
    for (NSDictionary *items in data)
    {
        isUniq = [items[@"is_uniq"] boolValue];
        smsEn = [items[@"sms_confirmation"] boolValue];
    }
    
    int res = smsEn;
    
    //if(isUniq) return 0; // такой телефон есть в базе выдаем ошибку
    //if(smsEn) return 2;  // такого телефона нет в базе и включена смс проверка
    
    return res; // такого телефона нет в базе и отключена смс проверка
}

// Парсер получения u_id при регистрации нового пользователя
+ (long)parserAddUserU_ID:(NSData *)objectNotation error:(NSError **)error
{
    long userId = 0;
    NSArray *data = [[NSArray alloc]initWithObjects:[self getArrayFromJsonDataServer:objectNotation error:error], nil];
    
    if(data==nil) return 0;
    if([data count]==0) return 0;
    
    for (NSDictionary *items in data)
        userId = [items[@"u_id"] longValue];
    
    return userId;
}

// Парсер модель карточек
+ (NSMutableArray *)parserJSONCards:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [[NSArray alloc]initWithObjects:[self getArrayFromJsonDataServer:objectNotation error:error], nil];
    
    if([data count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelDataCards *resParse   = [[PECModelDataCards alloc]init];
        resParse.idCard             = [items[@"mp_id"] integerValue];
        resParse.numberCard         = items[@"mc_number"];
        resParse.formatCard         = items[@"mc_format"];
        resParse.discountCard       = [items[@"mc_discount"] doubleValue];
        resParse.statusCard         = [items[@"mc_status"] integerValue];
        resParse.activationDateCards  = items[@"mc_activation_date"];
        resParse.descCard        = items[@"mc_description"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер модель карточек заполненная информацией от партнеров
+ (NSMutableArray *)parsJSONCardPartnerInfo:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];//[[NSArray alloc]initWithObjects:, nil];
    
    //NSLog(@"[items integerValue] %i",[items[@"mp_type_id"] integerValue]);
    
    NSMutableArray *ObjCards = [PECModelsData getModelCard];
    
    if(data==nil)
        return ObjCards;
    
    //if([data count]==0)
    //    return ObjCards;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (PECModelDataCards *obj in ObjCards)
    {
        PECModelDataCards *resParse   = [[PECModelDataCards alloc]init];
        
        // Берем предыдущую информацию
        resParse = obj; resParse.statusCard = 0;
        
        // Нахожу в массиве уже существующих карточек нужную карточку
        // и обновляю ее информацию в соответствии с найденным совпадением в массиве карточек
        //bool searchCard = false;
        for (NSDictionary *items in data)
        {
            int idCard = [items[@"mp_id"] integerValue];
            
            if(idCard == obj.idCard)
            {
                // Карточка найдена
                //searchCard = true;
                
                // Старая информация
                //resParse.idCard         = obj.idCard;
                //resParse.urlImgCard     = obj.urlImgCard;
                //resParse.distanceCard   = obj.distanceCard;
                //resParse.nameCard       = obj.nameCard;
                
                //resParse.nameCompany    = obj.nameCompany;
                
                //resParse.nameCompany    = obj.nameCompany;
                
                // Новая Информация
                //resParse.typeIdCard         = [items[@"mp_type_id"] integerValue];
                
                
                resParse.numberCard         = items[@"mc_number"];
                resParse.formatCard         = items[@"mc_format"];
                resParse.discountCard       = [items[@"mc_discount"] doubleValue];
                resParse.statusCard         = [items[@"mc_status"] integerValue];
                
                resParse.activationDateCards  = items[@"mc_activation_date"];
                resParse.descCard           = items[@"mc_description"];
                continue;
            }
        }
        // Если карточка не найдена у пользователя берем предыдущую информацию
        //if(!searchCard)resParse = obj;
        
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер модель спецпредложений
+ (NSMutableArray *)parserJSONActionsFromUserId:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];
    
    NSMutableArray *ObjActions = [PECModelsData getModelAction];
    
    if([data count]==0)
        return ObjActions;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (PECModelDataAction *obj in ObjActions)
    {
        PECModelDataAction *resParse   = [[PECModelDataAction alloc]init];
        
        // Берем предыдущую информацию
        resParse = obj;
        
        // Нахожу в массиве уже существующих акции нужную акцию
        // и обновляю ее информацию в соответствии с найденным совпадением в массиве акции
        for (NSDictionary *items in data)
        {
            int idAction = [items[@"mso_id"] integerValue];
            if(idAction == obj.idAction)
            {
                // Акция найдена
                resParse.activationAction = true;
                continue;
            }
        }
    
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер модель спецпредложений из пользовательского id
+ (NSMutableArray *)parserJSONActions:(NSData *)objectNotation error:(NSError **)error
{
    
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];
    
    if([data count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelDataAction *resParse   = [[PECModelDataAction alloc]init];
        
        resParse.idAction           = [items[@"mso_id"] integerValue];
        resParse.textAction         = items[@"mso_text"];
        resParse.typeAction         = items[@"mso_type"];
        resParse.cardNumberAction   = items[@"mso_card_number"];
        resParse.cardFormatAction   = items[@"mso_card_format"];
        resParse.rankAction         = [items[@"mso_rank"] integerValue];
        resParse.logoAction         = items[@"mso_logo"];
        resParse.startDateAction    = items[@"mso_start_date"];
        resParse.endDateAction      = items[@"mso_end_date"];
        resParse.discountAction     = [items[@"mso_discount"] integerValue];
        resParse.partnerIdAction    = [items[@"mp_id"] integerValue];
        resParse.arrPoints          = items[@"addresses"];
        resParse.distAction         = [items[@"address_distance"] integerValue];
        
        //NSLog(@"address_distance %i",[items[@"address_distance"] integerValue]);
        
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер модель партнеров
+ (NSMutableArray *)parserJSONPartners:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];
    
    if([data count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];

    for (NSDictionary *items in data)
    {
        PECModelPartner *resParse   = [[PECModelPartner alloc]init];
        resParse.idPartner          = [items[@"mp_id"] integerValue];
        resParse.namePartrner       = items[@"mp_name"];
        resParse.nickNamePartrner   = items[@"mp_nickname"];
        resParse.openingHoursPartrner = items[@"mp_opening_hours"];
        resParse.descPartrner = items[@"mp_description"];
        resParse.descShortPartrner  = items[@"mp_description_short"];
        resParse.emailPartrner      = items[@"mp_email"];
        resParse.licensePartrner    = items[@"mp_license"];
        resParse.typeIdPartrner     = [items[@"mp_type_id"] integerValue];
        resParse.typeNamePartrner   = items[@"mp_type_name"];
        resParse.logoCardPartrner   = items[@"mp_card_logo"];
        resParse.logoPartrner       = items[@"mp_logo"];
        resParse.arrPoints  = items[@"addresses"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}

// Парсер модель объектов ближайших к пользователю партнеров
+ (NSMutableArray *)parserJSONPartnersByLoc:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];//[[NSArray alloc]initWithObjects:[self getArrayFromJsonDataServer:objectNotation error:error], nil];
    
    if([data[0] count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelPartnerByLoc *resParse   = [[PECModelPartnerByLoc alloc]init];
        
        resParse.idPartner              = [items[@"mp_id"] integerValue];
        resParse.namePartrner           = items[@"mp_name"];
        resParse.descPartrner           = items[@"mp_description"];
        resParse.descShortPartrner      = items[@"mp_description_short"];
        resParse.openingHoursPartrner   = items[@"mp_opening_hours"];
        resParse.addrLongPartrner       = items[@"address_longitude"];
        resParse.addrLatPartrner        = items[@"address_latitude"];
        resParse.addrDistPartrner       = [items[@"address_distance"] integerValue];
        resParse.logoPartrner           = items[@"mp_logo"];
        resParse.logoCardPartrner       = items[@"mp_card_logo"];
        
        
        [groups addObject:resParse];
    }
    
    return groups;
}


// Парсер модель объектов НОВОСТЕЙ партнеров
+ (NSMutableArray *)parserJSONPartnersNews:(NSData *)objectNotation error:(NSError **)error
{

    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];
    if(data==nil) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelNews *resParse   = [[PECModelNews alloc]init];
        
        resParse.idNews             = [items[@"news_id"] integerValue];
        resParse.newsText           = items[@"news_text"];
        resParse.newsTitle          = items[@"news_header"];
        resParse.newsDate           = items[@"news_date"];
        
        [groups addObject:resParse];
    }

    return groups;
}


// Если пользователь не авторизован и переходит на первый экран карточек
// Собираем из данных о ближайших партнерах массив карточек в порядке убывания от клиента
+ (NSMutableArray *)parsPartnerLocByCard:(NSArray *)objectNotation error:(NSError **)error
{
    
    [self parserJSONTypePartnerLoc];
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc]init];
    
    for (PECModelPartnerByLoc *items in objectNotation)
    {
        PECModelDataCards *resParse   = [[PECModelDataCards alloc]init];
        
        resParse.idCard         = items.idPartner;
        resParse.nameCard       = items.namePartrner;
        resParse.urlImgCard     = items.logoCardPartrner;
        resParse.distanceCard   = items.addrDistPartrner;
        resParse.statusCard     = 0;
        resParse.descCard       = items.descPartrner;
        resParse.typeIdCard     = items.typeIdPartrner;
        resParse.typeNameCard   = items.typeNamePartrner;
        
        [groups addObject:resParse];
        
        // Change model Category
        PECModelCategoty *resCategory   = [[PECModelCategoty alloc]init];
        resCategory.idCategory           = items.typeIdPartrner;
        resCategory.nameCategory         = items.typeNamePartrner;
        NSString *keyDic = [NSString stringWithFormat:@"%d", resCategory.idCategory];
        if([categoryDic valueForKey:keyDic]==nil)
            [categoryDic setValue:resCategory forKey:keyDic];

    }
    
    NSMutableArray *arrCategory = [[NSMutableArray alloc] initWithArray:[categoryDic allValues]];
    [PECModelsData setModelCategory:arrCategory];
    
    return groups;
}


// Заполняю локальную модель партнеров на основе модели о всех партнерах
+ (void)parserJSONTypePartnerLoc
{
    NSMutableArray *arrPartnerLoc = [[NSMutableArray alloc]initWithArray:[PECModelsData getModelPartnersByLoc]];
    NSArray *arrPartner = [[NSArray alloc]initWithArray:[PECModelsData getModelPartners]];
    
    for(PECModelPartner *partner in arrPartner)
    {
        for (PECModelPartnerByLoc *partnerLoc in arrPartnerLoc)
        {
            if(partner.idPartner == partnerLoc.idPartner)
            {
                partnerLoc.typeIdPartrner = partner.typeIdPartrner;
                partnerLoc.typeNamePartrner = partner.typeNamePartrner;
            }
        }
    }
    [PECModelsData setModelPartnersByLoc:arrPartnerLoc];
}

// Собираем из данных о всех партнерах массив карточек
+ (NSMutableArray *)parsPartnerAllByCard:(NSArray *)objectNotation error:(NSError **)error
{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc]init];
    
    for (PECModelPartner *items in objectNotation)
    {
        PECModelDataCards *resParse   = [[PECModelDataCards alloc]init];
        
        resParse.idCard = items.idPartner;
        resParse.nameCard = items.namePartrner;
        resParse.urlImgCard = items.logoCardPartrner;
        resParse.statusCard = 0;
        resParse.descCard = items.descPartrner;
        resParse.typeIdCard = items.typeIdPartrner;
        resParse.typeNameCard = items.typeNamePartrner;
        
        [groups addObject:resParse];
        
        // Change model Category
        PECModelCategoty *resCategory   = [[PECModelCategoty alloc]init];
        resCategory.idCategory           = items.typeIdPartrner;
        resCategory.nameCategory         = items.typeNamePartrner;
        NSString *keyDic = [NSString stringWithFormat:@"%d", resCategory.idCategory];
        if([categoryDic valueForKey:keyDic]==nil)
            [categoryDic setValue:resCategory forKey:keyDic];

    }
    
    NSMutableArray *arrCategory = [[NSMutableArray alloc] initWithArray:[categoryDic allValues]];
    [PECModelsData setModelCategory:arrCategory];
    
    return groups;
}


// Парсер модель объектов партнеров
+ (NSMutableArray *)parserJSONPoints:(NSArray *)objectNotation error:(NSError **)error
{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for(PECModelPartner *partner in objectNotation)
    {
        NSArray *data = partner.arrPoints;
        for(NSDictionary *points in data)
        {
            PECModelPoints *resParse = [[PECModelPoints alloc]init];
            resParse.modelPartner = partner;
            
            resParse.addressIdPartrner      = [points[@"address_id"] integerValue];
            resParse.addressTextPartrner    = points[@"address_text"];
            resParse.addressAreaPartrner    = points[@"address_area"];
            resParse.addressMetroPartrner   = points[@"address_metro"];
            resParse.addressCityIdPartrner  = points[@"address_city_id"];
            resParse.addressCityNamePartrner = points[@"address_city_name"];
            // resParse.address = items[@"address_country_id"];
            // resParse. = items[@"address_country_name"];
            resParse.addressLatPartrner     = points[@"address_latitude"];
            resParse.addressLongPartrner    = points[@"address_longitude"];
            resParse.addressopenHoursPartrner = points[@"address_opening_hours"];
            resParse.addressTeleph1Partner  = points[@"address_telephone_one"];
            resParse.addressTeleph2Partner  = points[@"address_telephone_second"];
            resParse.addressTeleph3Partner  = points[@"address_telephone_third"];
            
            [groups addObject:resParse];
        }
    }
    
    return groups;
}

// Парсер модель объектов категории партнеров
+ (NSMutableArray *)parserJSONCategory:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];
    
    if([data count]==0) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelCategoty *resParse   = [[PECModelCategoty alloc]init];
        
        resParse.idCategory           = [items[@"mp_type_id"] integerValue];
        resParse.nameCategory         = items[@"mp_type_name"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}

// ???Сортировка массива
+(NSDictionary*)sortArrayAtLiters: (NSMutableArray*) arrayObjects nameKey:(NSString*) nameKey mode:(bool)mode
{
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *values= [[NSMutableArray alloc]init];

    for(PECModelDataCards *obj in arrayObjects)
    {
        NSString *valueKey = obj.nameCard;
        
        //if(mode) valueKey = [valueKey substringToIndex:1];
        
        [values addObject:obj];
        [keys addObject:[NSString stringWithFormat:@"%@",valueKey]];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];

    return  dict;
}

// Парсер любого объекта независимо от ключа в json
+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error objectModel: (NSString*)modelObject
{
    NSError *localError = nil;
    
    if(objectNotation==nil){return nil;}
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSArray *response = [parsedObject valueForKey:@"response"];
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    int incObj = 1000;
    for (NSDictionary *items in response)
    {
        
        NSDictionary *resParse = items;
        
        PECMainModel *model = [[NSClassFromString(modelObject) alloc] init];
        
        for (NSString *key in resParse)
        {
            if ([model respondsToSelector:NSSelectorFromString(key)])
            {
                [model setValue:[resParse valueForKey:key] forKey:key];
                
                // NSLog(@"%@ %@", key, [resParse valueForKey:key]);
            }
        }
        
        [groups addObject:model];
        
        model.progrId = incObj++;
    }
    
    return groups;
}

// Обновление пользовательских данных
+ (void)uploadModelDataSettings:(int) countCardInView
                      idCountry:(int) idCountry
                            lat: (double) lat
                         longit: (double) longit
                     locationEn: (int) locationEn
                        autoriz:(int) autoriz
                     uploadData:(int) uploadData
{
    PECModelSettings *settingsUser = [[PECModelSettings alloc]init];

    if([PECModelsData getModelSettings]!=nil)
        settingsUser = [PECModelsData getModelSettings];
    
    if(countCardInView!=-1)
        settingsUser.countCardInView = countCardInView;

    if(idCountry!=-1)
        settingsUser.idCountry = idCountry;
    
    if(lat!=-1)
        settingsUser.lat = lat;
    if(longit!=-1)
        settingsUser.longit = longit;
    if(locationEn!=-1)
        settingsUser.locationEn = locationEn;
    if(autoriz!=-1)
        settingsUser.autoriz = autoriz;
    
    if(uploadData!=-1)
        settingsUser.uploadData = uploadData;
    
   // NSLog(@"!!!!!idCountry %i",idCountry);
    
    [PECModelsData setModelSettings:settingsUser];
}

// Идентифицирую номер в зависимости от названия города
+ (int)numCityFromItName:(NSString*)nameCity
{
    int number = 0;
    if([nameCity isEqual:@"St. Petersburg"]) number = 1;
    if([nameCity isEqual:@"Moscow"]) number = 2;
    
    if([nameCity isEqual:@"Санкт-Петербург"]) number = 1;
    if([nameCity isEqual:@"Москва"]) number = 2;
    
    return number;
}


// Заполняю модель карточек информацией на основании информации о партнерах и информацией о карточках зарегестрированного пользователя
+ (void) createModelDataCardFromDataPartnerLoc: (BOOL)localication
                               autorizationUser:(BOOL)autorizationUser
                             numberCityLocation:(int)numberCityLocation
                                       addrLong:(double)addrLong
                                        addrLat:(double)addrLat
                                       callback:(void (^)(id)) callback
{

    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    
    if(localication && numberCityLocation!=0){
        // Если определение локации включено
        
        // Заполняю модель ближайших акции

        // Скачиваю информацию по ближайшим к пользователю спецпредложениям
        [netCtrl getLocActionUserDServer:numberCityLocation addrLong:addrLong addrLat:addrLat callback:^(id sender){

            // Скачиваю информацию по ближайшим к пользователю партнерам
            [netCtrl getPartnerByLocDataServer:numberCityLocation
                                      addrLong:addrLong
                                       addrLat:addrLat
                                      callback:^(id sender)
             {
                 // Заполняю модель карточек информацией на основании информации о ближайших партнерах
                 [PECModelsData setModelCard:[PECBuilderModel parsPartnerLocByCard:[PECModelsData getModelPartnersByLoc] error:nil]];
                 
                 // Определяю авторизоvан пользователь и скачиваю информацию по его карточкам и акциям
                 [PECBuilderModel getDataAutUser:autorizationUser callback:^(id sender){ callback(self); }];
             }];
            
        }];

    }else
    {
        // Если определение локации отключено

        // Скачиваю информацию по всем спецпредложениям
        [netCtrl getAllMSODataServer:^(id sender){

            // Скачиваю информацию про всех партнеров
            [netCtrl getPartnerDataServer:@"" callback:^void(int param){
                
                // Заполняю модель карточек информацией на основании информации о всех партнерах
                [PECModelsData setModelCard:[PECBuilderModel parsPartnerAllByCard:[PECModelsData getModelPartners] error:nil]];
                
                // Определяю авторизоvан пользователь и скачиваю информацию по его карточкам и акциям
                [PECBuilderModel getDataAutUser:autorizationUser callback:^(id sender){
                    callback(self);
                }];
            }];

            
        }];

    }

}


// Продолжение функции createModelDataCardFromDataPartnerLoc
+ (void)getDataAutUser:(BOOL)autorization callback:(void (^)(id)) callback
{
    // Если пользователь авторизован скачиваю и добавляю к информации о карточках заполненной информацией от партнеров
    // информацией о карточках зарегестрированного пользователя
    if(autorization)
    {
        PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
        
        // Скачиваю и заполняю информацию о карточках по u_id
        PECModelDataUser *modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
        [netCtrl getCardUserDataServer: modelUser.idUser callback:^(id sender)
         {
             // Скачиваю информацию по всем спецпредложениям
             [netCtrl getALLActionUserDServer:modelUser.idUser callback:^(id sender){ callback(self); }];
         }];
        
    }else{
        callback(self);
    }

}


// Получить модель партнера по его id
+(PECModelPartner*)getModelParnterAtId: (int) idPartner
{
    PECModelPartner *partnerFromId=nil;
    for(PECModelPartner *partner in [PECModelsData getModelPartners] )
    {
        if(partner.idPartner == idPartner){
            partnerFromId = partner;
            return partnerFromId;
        }
    }
    return partnerFromId;
}

// Добавление экрана загрузки данных с сервера
+(void)addViewLoadingData:(UIView*) superView
{
    UIView *uploadViewContainer = [[UIView alloc]initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, 700.0f )];
    [uploadViewContainer setBackgroundColor:[UIColor clearColor]];
    
    UIView *uploadView = [[UIView alloc]initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, 700.0f )];
    [uploadView setBackgroundColor:[UIColor whiteColor]];
    [uploadView setAlpha:0.6f];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( 152.0f, 206.0f, 20.0f, 20.0f )];
    //0 149 219
    [indicator setBackgroundColor:[UIColor clearColor]];
    [indicator setColor:[UIColor colorWithRed:0 green:0.22f blue:0.34 alpha:1]];
    
    [indicator startAnimating];
    
    [uploadViewContainer addSubview:uploadView];
    [uploadViewContainer addSubview:indicator];
    
    //UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
    
    [superView addSubview:uploadViewContainer];

}


//------------------------------
// Get Data From Images
//------------------------------
/*
 +(UIImage*) getImagesCardsFromInternetURL:(NSString*)ImageURL
 {
 NSURL *url = [NSURL URLWithString: ImageURL];
 NSData *data = [NSData dataWithContentsOfURL:url];
 UIImage *image = [[UIImage alloc] initWithData:data];
 return image;
 }*/


@end
