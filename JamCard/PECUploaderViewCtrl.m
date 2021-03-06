//
//  PECUploaderViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/27/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//
//  Экран загрузки начальных параметров
//
//  1 Определяю местоположение пользователя устройства
//  2 Скачиваю информацию о партнерах которые находятся поблизости
//  3 На основании этих данных заполняю модели партнеров и карточек
//  4 Проверяю регистрацию пользователя
//  5 Если зарегестрирован скачиваю информацию по карточкам используя u_id
//  и дополняю модель карточек полученной информацией
//  6 Если не зарегестрирован перехожу на сделующий экран JamCard

#import "PECUploaderViewCtrl.h"
#import "PECModelDataCards.h"
#import "PECBuilderModel.h"
#import "PECViewController.h"
#import "FailCertificateDelegate.h"
#import "PECModelsData.h"
#import "PECNetworkDataCtrl.h"
#import "PECModelDataUser.h"
#import "PECBuilderCards.h"
#import "PECModelDataAction.h"
#import "PECModelSettings.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#import <CoreLocation/CoreLocation.h>

@interface PECUploaderViewCtrl ()

@end

@implementation PECUploaderViewCtrl
{
    NSData *responseData;
    NSData *responseDataPartner;
    
    // Ready at request to navigation controller
    bool readyDataCards;
    bool readyDataPartners;
    bool readyLocation;
    bool readyDataUser;
    bool readyDataCategory;
    bool trigLocationManager;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    int numberCityLocation;
    
    bool autorizationUser;
    PECModelDataUser *modelUser;
    PECModelSettings *settingsUser;
}

// Ошибки вызванные определением геолокации пользователя
- (void)locationManager:(CLLocationManager*)aManager didFailWithError:(NSError*)anError
{
    NSString *message;
    NSLog(@"locationManager ERROR");
    
    int loc = 0;
    
    switch([anError code])
    {
        case kCLErrorLocationUnknown: // location is currently unknown, but CL will keep trying
        {
            message = @"Ваш город не найден";
            NSLog(@"Ваш город не найден");
            break;
        }
            
        case kCLErrorDenied: // CL access has been denied (eg, user declined location use)
        {
            message = @"Некоторый функционал приложения будет отключен";
            NSLog(@"Некоторый функционал приложения будет отключен");
            break;
        }
            
        case kCLErrorNetwork: // general, network-related error
            NSLog(@"Ошибка сети");
            message = @"Ошибка сети";
            break;
            
        //default:
    }
    
    // Обновляю пользовательские настройки
    [PECBuilderModel uploadModelDataSettings:-1
                                   idCountry:0
                                         lat:0.0f
                                      longit:0.0f
                                  locationEn:0
                                     autoriz:-1
                                  uploadData:0x7];
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    
    [self cellAlertMsg:message];
    
    readyLocation = true;
    [self controllerLoadInfo];

    

    /*
    // Заполняю модель карточек и партнеров
    [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                          autorizationUser:[PECModelsData getModelSettings].autoriz
                                        numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                  addrLong:[PECModelsData getModelSettings].longit
                                                   addrLat:[PECModelsData getModelSettings].lat
                                                  callback:^(id sender){
                                                      
                                                      [locationManager stopUpdatingLocation];
                                                      locationManager.delegate = nil;
                                                      locationManager = nil;
                                                      
                                                      [self cellAlertMsg:message];
                                                      
                                                      readyLocation = true;
                                                      [self controllerLoadInfo];
                                                  }];
     */
}


// Определяю местоположение пользователя
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //placemark.country
    // Если определили местоположение пользователя
    if(!trigLocationManager)
    {
        [self cellAlertMsg:@"Определяю Ваше местоположение"];
        NSLog(@"locationManager");
        
        trigLocationManager = true;
        
        CLLocation *currentLocation = newLocation;
        
        if (currentLocation != nil)
        {
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
            {
                if (error == nil && [placemarks count] > 0)
                {
                    placemark = [placemarks lastObject];  NSLog(@"placemark %@", placemark.locality);
                    
                    [self cellAlertMsg:placemark.locality];

                    // Такой город присутствует или нет в списке
                    // Обновляю пользовательские настройки
                    [PECBuilderModel uploadModelDataSettings:-1
                                                   idCountry: [PECBuilderModel numCityFromItName:placemark.locality]//[self numCityFromName:placemark.administrativeArea]
                                                         lat:currentLocation.coordinate.latitude
                                                      longit:currentLocation.coordinate.longitude
                                                  locationEn:1
                                                     autoriz:-1
                                                  uploadData:0x7];
                    
                    [locationManager stopUpdatingLocation];
                    locationManager.delegate = nil;
                    locationManager = nil;
                    
                    readyLocation = true;
                    [self controllerLoadInfo];

                    
                    
                    /*
                    // Заполняю модель карточек и партнеров
                    [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                                          autorizationUser:[PECModelsData getModelSettings].autoriz
                                                        numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                                  addrLong:[PECModelsData getModelSettings].longit
                                                                   addrLat:[PECModelsData getModelSettings].lat
                                                                  callback:^(id sender){
                                                                      
                                                                      [locationManager stopUpdatingLocation];
                                                                      locationManager.delegate = nil;
                                                                      locationManager = nil;
                                                                      
                                                                      readyLocation = true;
                                                                      [self controllerLoadInfo];
                                                                  }];
                     */

                } else{
                    // Произошла ошибка при поиске города
                    NSLog(@"%@", error.debugDescription);
                }
            }];
        }
    }
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    
}

// Вызываю когда закончил скачивать какую либо информацию с сервера
- (void)controllerLoadInfo
{
    
    if(readyDataPartners && readyDataCategory)
    {
        // Дополнительные данные связанные с геолокацией и авторизацией
        if(readyLocation)
            [self numberTelInBDServer];
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // Управление геолокацией
                [self locationManagerCtrl];
            });
        }
        
    }
    
}

// Скачиваю все необходимые данные с сервера
- (void)uploadDataFromServer
{
    // Данные не скачаны с сервера
    readyLocation = false;
    readyDataPartners = false;
    readyDataCards = true;
    readyDataUser = true;
    readyDataCategory = true;
    
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    
    // Скачиваю информацию про всех партнеров
    [netCtrl getPartnerDataServer:@"" callback:^void(int param)
    {
        readyDataPartners = param;
        [self controllerLoadInfo];
    }];
    
    /*
    // Скачиваю информацию по всем категориям партнеров
    [netCtrl getCategoryPartnersDServer:^void(int param)
    {
        readyDataCategory = param;
        [self controllerLoadInfo];
    }];
     */
}


// Управление геолокацией
- (void)locationManagerCtrl
{
    // Определяю местоположение пользователя Город в котором нахожусь
    trigLocationManager = false;
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hidden Navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        [self cellAlertMsg:@"Нет связи с интернет"];
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                               target:self
                                                             selector:@selector(animationTick)
                                                             userInfo:nil
                                                              repeats:YES];
    } else {
        // Скачиваю настройки приложения
        [self getSettingsUser];
        
        // Скачиваю все необходимые данные с сервера
        [self uploadDataFromServer];
        
    }        

}

// Определение наличия связи с интернет
- (BOOL)notInternetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        [self cellAlertMsg:@"Нет связи с интернет"];
        return true;
    }
    return false;
}

-(void)animationTick
{
    // Если отсутствует интернет игнорируем действие
    if([self notInternetConnection]) return;

    if([self.animationTimer isValid])
            [self.animationTimer invalidate];
    
    // Скачиваю настройки приложения
    [self getSettingsUser];
    
    // Скачиваю все необходимые данные с сервера
    [self uploadDataFromServer];
}

// Save Data
- (void)saveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:responseData forKey:@"cards_data"];
    [defaults synchronize];
}

// Запрос для проверки существования номера в базе данных
- (void) numberTelInBDServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *UserTel = [defaults objectForKey:@"user_tel"];
    
    // Сценарий 1 Данные по партнерам скачаны но пользователь не авторитизирован
    
    if(UserTel==NULL)
    {
        [PECBuilderModel uploadModelDataSettings:-1
                                       idCountry:-1
                                             lat:-1
                                          longit:-1
                                      locationEn:-1
                                         autoriz:false
                                      uploadData:0x7];
        
        // Заполняю модель карточек и партнеров
        [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                              autorizationUser:[PECModelsData getModelSettings].autoriz
                                            numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                      addrLong:[PECModelsData getModelSettings].longit
                                                       addrLat:[PECModelsData getModelSettings].lat
                                                      callback:^(id sender){
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              // Перехожу на следующий экран
                                                              [self reqNavController];
                                                          });
                                                          
                                                          
                                                      }];

        
        
    }else{
    
        // Сценарий 2 Данные по партнерам скачаны пользователь авторитизирован
        
        bool authorization = UserTel!= NULL;
        
        // Делаю запрос для проверки существования номера в базе данных
        PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc]init];
        [netCtrl getUserInfoAtTelDServer:UserTel callback:^(id sender){
            
            //if([PECModelsData getModelUser].count)
            //{
                [PECBuilderModel uploadModelDataSettings:-1
                                               idCountry:-1
                                                     lat:-1
                                                  longit:-1
                                              locationEn:-1
                                                 autoriz:authorization
                                              uploadData:0x7];
                
                // Заполняю модель карточек и партнеров
                [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                                      autorizationUser:[PECModelsData getModelSettings].autoriz
                                                    numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                              addrLong:[PECModelsData getModelSettings].longit
                                                               addrLat:[PECModelsData getModelSettings].lat
                                                              callback:^(id sender){
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      // Перехожу на следующий экран
                                                                      [self reqNavController];
                                                                  });

        
                                                              }];
            /*}else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Перехожу на следующий экран
                    [self reqNavController];
                });
            }*/
        }];
    }
}

// ~ СИСТЕМНЫЕ ОБЩИЕ


// Скачиваю настройки приложения
- (void)getSettingsUser
{
    // Обновляю пользовательские настройки
    [PECBuilderModel uploadModelDataSettings:2
                                   idCountry:-1
                                         lat:-1
                                      longit:-1
                                  locationEn:-1
                                     autoriz:-1
                                  uploadData:0x7];
    
    /*
     // Определяю авторизован ли пользователь
     modelUser = nil;
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     modelUser = [defaults objectForKey:@"user_data"];
     
     autorizationUser = modelUser!=nil;
     
     if(autorizationUser)
     {
     NSMutableArray *arrModelUser = [[NSMutableArray alloc]initWithObjects:modelUser, nil];
     [PECModelsData setModelUser:arrModelUser];
     modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
     }*/
    
}

// Сообщения
-(void)cellAlertMsg:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
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
    });
}

- (void)reqNavController
{
    PECViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"viewStoryID"];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
    [self presentViewController:navController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Скрываю статус бар
- (BOOL)prefersStatusBarHidden { return YES; }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
