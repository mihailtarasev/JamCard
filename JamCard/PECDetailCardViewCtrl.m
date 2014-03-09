//
//  PECDetailCardViewCtrl.m
//  JamCard
//
//  Created by Admin on 11/26/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECDetailCardViewCtrl.h"
#import "PECBuilderCards.h"
#import "PECModelsData.h"
#import "PECBuilderModel.h"
#import "PECModelPoints.h"
#import "PECNetworkDataCtrl.h"
#import "PECModelDataUser.h"
#import "PECNewsPartnerViewCtrl.h"
#import "PECAddressPartnerViewCtrl.h"
#import "PECAboutPartnerViewCtrl.h"
#import "Reachability.h"
#import "PECObjectCard.h"

#import "ZXingObjC.h"

@interface PECDetailCardViewCtrl ()

// Контейнеры для хранения фреймов авторизации
@property (retain, nonatomic) IBOutlet UIView *activationContainer;

// Контейнеры для хранения фреймов деавторизации
@property (retain, nonatomic) IBOutlet UIView *deActivationContainer;


// Контейнер загрузки данных
@property (retain, nonatomic) IBOutlet UIView *loadingContainer;

@end

@implementation PECDetailCardViewCtrl
{
    // Контейнеры для хранения фреймов авторизации
 
    // Заголовок карточки
    UILabel *cActTitleCard;
    // Картинка карточки
    UIImageView *cActImgCard;
    // Кнопка деактивировать карточку
    UIButton *butDeAct;
    UILabel *cActNumberCard;
    UIImageView *imgCardViewBarCode;
    UIImageView *imgCardViewQRCode;
    UILabel *cActDiscountActionCard;
    
    UIButton *butNews;
    UIButton *butAddress;
    
    UIControl *contCardViewBarCode;
    UIControl *contCardViewQRCode;

    // Контейнеры для хранения фреймов деавторизации

    // Заголовок карточки
    UILabel *cDeActTitleCard;
    // Картинка карточки
    UIImageView *cDeActImgCard;
    // Адрес Фирмы
    UILabel *cDeActAddressCompany;
    // Телефон фирмы
    UILabel *cDeActNumTelephoneCompany;
    // Время работы Фирмы
    UILabel *cDeActTimeWorkCompany;
    // Описание карточки
    UILabel *cDeActDescCard;
    UILabel *cDeActDiscountActionCard;
    
    UIButton *butAddress2;
    UIButton *butAboutPartners;
    
    UIButton *butTel;
    
    // Кнопка активировать карточку
    UIButton *butActAct;
    
    // Системные
    NSMutableArray *objJSON;
    UILabel* NumberCard;
    UILabel* nameCard;
    UIImageView* imgCard;
    UIImageView* imgCardActivate;
    
    PECModelDataCards * currentModelDataCard;
    PECModelPartner *currentModelPartner;
    
    int idUser;
    BOOL autorizationUser;
    
    UIViewController *viewCtrlAct;
    UIViewController *viewCtrlDeAct;
    
    UIView *containerAck;
    UIView *containerDeAck;
    
    UIScrollView *scrollViewActivated;
    UIScrollView *scrollViewDeActivated;

    UIView *activateContainer;
    UIView *deActivateContainer;
    
    UIControl *whiteContainer;
    
    bool barCodeBig;
    bool qrCodeBig;
    
    UILabel *codeBarActiveContainer;
    
    UIView *mainContVerifi;

    UIView *infoContainer;
    UIView *infoContainerAck;
    int kCode;
    
    float yCoordBarCode;
    float yCoordQRCode;
    
    int acktiveCode;
}

// ~ ИНИЦИАЛИЗАЦИЯ

// Инициализация элементов экрана
-(void) initElementsController
{
    // Контейнеры для хранения фреймов авторизации
    cActTitleCard = (UILabel*)[self.view viewWithTag:100];
    cActImgCard = (UIImageView*)[self.view viewWithTag:101];
    //Adds a shadow to sampleView
    CALayer *layerAct = cActImgCard.layer;
    layerAct.cornerRadius = 5;
    layerAct.masksToBounds = YES;
    
    
    butActAct = (UIButton*)[self.view viewWithTag:102];
    [butActAct addTarget:self action:@selector(bActEvent:) forControlEvents:UIControlEventTouchDown];
    [butActAct setExclusiveTouch:YES];
    
    cActNumberCard = (UILabel*)[self.view viewWithTag:103];
    
    butNews = (UIButton*)[self.view viewWithTag:105];
    [butNews addTarget:self action:@selector(butNews:) forControlEvents:UIControlEventTouchDown];
    [butNews setExclusiveTouch:YES];

    cActDiscountActionCard = (UILabel*)[self.view viewWithTag:106];
    
    // Контейнеры для хранения фреймов деавторизации
    cDeActTitleCard = (UILabel*)[self.view viewWithTag:200];

    cDeActImgCard = (UIImageView*)[self.view viewWithTag:201];
    CALayer *layerDeAct = cDeActImgCard.layer;
    layerDeAct.cornerRadius = 5;
    layerDeAct.masksToBounds = YES;
    
    cDeActNumTelephoneCompany = (UILabel*)[self.view viewWithTag:202];
    
    butTel = (UIButton*)[self.view viewWithTag:210];
    [butTel addTarget:self action:@selector(bTelEvent:) forControlEvents:UIControlEventTouchDown];
    [butTel setExclusiveTouch:YES];
    
    
    cDeActAddressCompany = (UILabel*)[self.view viewWithTag:203];
    cDeActTimeWorkCompany = (UILabel*)[self.view viewWithTag:204];

    //cDeActDescCard = (UILabel*)[self.view viewWithTag:205];
    //[cDeActDescCard sizeToFit];
    
    butDeAct = (UIButton*)[self.view viewWithTag:206];
    [butDeAct addTarget:self action:@selector(bDeActEvent:) forControlEvents:UIControlEventTouchDown];
    [butDeAct setExclusiveTouch:YES];

    butAboutPartners = (UIButton*)[self.view viewWithTag:209];
    [butAboutPartners addTarget:self action:@selector(bAboutPartnerEvent:) forControlEvents:UIControlEventTouchDown];
    [butAboutPartners setExclusiveTouch:YES];
    
    //cDeActDiscountActionCard = (UILabel*)[self.view viewWithTag:208];
    
    butAddress2 = (UIButton*)[self.view viewWithTag:107];
    [butAddress2 addTarget:self action:@selector(butAddressEvent2:) forControlEvents:UIControlEventTouchDown];
    [butAddress2 setExclusiveTouch:YES];
    
    butAddress = (UIButton*)[self.view viewWithTag:108];
    [butAddress addTarget:self action:@selector(butAddressEvent:) forControlEvents:UIControlEventTouchDown];
    [butAddress setExclusiveTouch:YES];

    
    scrollViewActivated = (UIScrollView*)[self.view viewWithTag:600];
    scrollViewDeActivated = (UIScrollView*)[self.view viewWithTag:601];
    activateContainer = (UIView*)[self.view viewWithTag:602];
    
    deActivateContainer = (UIView*)[self.view viewWithTag:603];
    

    whiteContainer = (UIControl*)[self.view viewWithTag:400];
    [whiteContainer addTarget:self action:@selector(bCloseCodeEvent:) forControlEvents:UIControlEventTouchDown];
    [whiteContainer setExclusiveTouch:YES];
    
    
    imgCardViewBarCode = (UIImageView*)[self.view viewWithTag:110];
    contCardViewBarCode = (UIControl*)[self.view viewWithTag:111];
    [contCardViewBarCode addTarget:self action:@selector(bViewBarCodeEvent:) forControlEvents:UIControlEventTouchDown];
    [contCardViewBarCode setExclusiveTouch:YES];
    
    //Adds a shadow to sampleView
    CALayer *layerBarCode = contCardViewBarCode.layer;
    layerBarCode.cornerRadius = 5;
    layerBarCode.masksToBounds = YES;
    
    imgCardViewQRCode = (UIImageView*)[self.view viewWithTag:120];
    contCardViewQRCode = (UIControl*)[self.view viewWithTag:121];
    [contCardViewQRCode addTarget:self action:@selector(bViewQRCodeEvent:) forControlEvents:UIControlEventTouchDown];
    [contCardViewQRCode setExclusiveTouch:YES];
    
    //Adds a shadow to sampleView
    CALayer *layerQRCode = contCardViewQRCode.layer;
    layerQRCode.cornerRadius = 5;
    layerQRCode.masksToBounds = YES;
    
    codeBarActiveContainer = (UILabel*)[self.view viewWithTag:306];
    
    infoContainer = (UIView*)[self.view viewWithTag:322];
    infoContainerAck = (UIView*)[self.view viewWithTag:323];
    
}

- (IBAction)bTelEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifi showHide:true Select:0];
}

- (IBAction)bCloseEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifi showHide:false Select:0];
}

- (IBAction)bRingEvent:(id)sender
{
    NSString *callNumber = [NSString stringWithFormat:@"tel://%@", cDeActNumTelephoneCompany.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initElementsController];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        //scrollViewActivated.frame = (CGRect){scrollViewActivated.frame.origin, CGSizeMake(320, 480)};
        scrollViewActivated.contentSize = CGSizeMake(320, 600);
        
        scrollViewDeActivated.frame = (CGRect){scrollViewDeActivated.frame.origin, CGSizeMake(320, 446)};
        scrollViewDeActivated.contentSize = CGSizeMake(320, 530);
        
        activateContainer.frame = CGRectOffset( activateContainer.frame, 0.0f, -90.0f);
        deActivateContainer.frame = CGRectOffset( deActivateContainer.frame, 0.0f, -90.0f);
    }
    
    // Подтверждение звонка по номеру телефона
    mainContVerifi = [PECObjectCard addContainerRingViewController:self txtNumPhone:@"" mode:0];
    [self.view addSubview:mainContVerifi];
    [mainContVerifi setAlpha:0.0];
    
    autorizationUser = false;
    NSArray *arrModelUser = [PECModelsData getModelUser];
    if(arrModelUser.count)
    {
        PECModelDataUser *modelUser = [arrModelUser objectAtIndex:0];
        idUser = modelUser.idUser;
        autorizationUser = true;
    }else
        idUser = 0;
    
    // Получаю данные выбранной карточки
    for(PECModelDataCards *modelData in [PECModelsData getModelCard])
        if(modelData.idCard == [self selectedCard])
            currentModelDataCard = modelData;

    // Получаю данные партнера карточки
    for(PECModelPartner *modelData in [PECModelsData getModelPartners])
        if(modelData.idPartner == [self selectedCard])
            currentModelPartner = modelData;

    // Определяю статус карточки и вывожу на экран соотв форму
    int stCard = currentModelDataCard.statusCard;
    
    NSLog(@"stCard %d",stCard);
    

    if(stCard==0)
        [self showDeActivateCard];
    else
        if(stCard==1)
            [self showActivateCard];
        else{
            [self showDeActivateCard];
            NSLog(@"status card no valid %d",stCard);
        }
    
    
    yCoordBarCode = 150;
    
    NSString *textTitle = currentModelPartner.namePartrner;
    cDeActTitleCard.text = textTitle;
    [cDeActTitleCard sizeToFit];

    cActTitleCard.text = textTitle;
    [cActTitleCard sizeToFit];
    
    int numLine = ceil(cDeActTitleCard.frame.size.height/26.0f);
    kCode = numLine*14;
    
    if(numLine>1)
    {
        cDeActTitleCard.numberOfLines = numLine;
        infoContainer.frame = CGRectOffset(infoContainer.frame, 0.0f, kCode);
        [cDeActTitleCard setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22-numLine]];
        
        
        cActTitleCard.numberOfLines = numLine;
        infoContainerAck.frame = CGRectOffset(infoContainerAck.frame, 0.0f, kCode);
        [cActTitleCard setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22-numLine]];
        
        contCardViewBarCode.frame = CGRectOffset(contCardViewBarCode.frame, 0.0f, kCode);
        contCardViewQRCode.frame = CGRectOffset(contCardViewQRCode.frame, 0.0f, kCode);
        
        scrollViewActivated.contentSize = CGSizeMake(320, 600+kCode);
        scrollViewDeActivated.contentSize = CGSizeMake(320, 530+kCode);
    }
    
    yCoordBarCode = contCardViewBarCode.frame.origin.y;
    yCoordQRCode = contCardViewQRCode.frame.origin.y;

    
 }

// ~ КАРТОЧКА АКТИВИРОВАНА

- (IBAction)bViewBarCodeEvent:(id)sender
{
    if(qrCodeBig)[self bViewQRCodeEvent:nil];
    
    float k, y;
    if(!barCodeBig)
    {
        [whiteContainer setAlpha:0.0];
        [whiteContainer setHidden:false];
        k=2; y = 130.0f; acktiveCode = 1;
    }else{
        [whiteContainer setHidden:true];
        k=0.5; y = yCoordBarCode;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGRect contFrame = contCardViewBarCode.frame;
                         [contCardViewBarCode setFrame:CGRectMake(20, y, contFrame.size.width*k, contFrame.size.height*k)];
                         [whiteContainer setAlpha:0.9];
                     }
                     completion:^(BOOL finished){
                         barCodeBig = !barCodeBig;
                     }];
    
}

- (IBAction)bViewQRCodeEvent:(id)sender
{
    if(barCodeBig)[self bViewBarCodeEvent:nil];
    
    float k, y, x;
    if(!qrCodeBig)
    {
        [whiteContainer setAlpha:0.0];
        [whiteContainer setHidden:false];
        k=2; y = 130.0f; x = 90.0f; acktiveCode = 2;
    }else{
        [whiteContainer setHidden:true];
        k=0.5; y = yCoordBarCode; x = 220.0f;
    }
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGRect contFrame = contCardViewQRCode.frame;
                         [contCardViewQRCode setFrame:CGRectMake(x, y, contFrame.size.width*k, contFrame.size.height*k)];
                         [whiteContainer setAlpha:0.9];
                     }
                     completion:^(BOOL finished){
                         qrCodeBig = !qrCodeBig;
                     }];
    
}


- (IBAction)bCloseCodeEvent:(id)sender
{
    NSLog(@"Close");
    if(acktiveCode==1) [self bViewBarCodeEvent:nil];
    if(acktiveCode==2) [self bViewQRCodeEvent:nil];
    
}

// Нажимаю на кнопку деактивировать карточку
- (IBAction)bDeActEvent:(id)sender
{
    // Если отсутствует интернет игнорируем действие
    if([self notInternetConnection]) return;
    
    // Делаю запрос к серверу для деактивации карточки
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    [netCtrl deActivateCardServer:[self selectedCard] userId:idUser callback:^(id sender){
        
        [_loadingContainer setHidden:false];
        
        // Скачиваю и заполняю информацию о карточках по u_id
        PECModelDataUser *modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
        
        [netCtrl getCardUserDataServer: modelUser.idUser callback:^(id sender){
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                // Обновляю пользовательские настройки
                [PECBuilderModel uploadModelDataSettings:-1
                                               idCountry:-1
                                                     lat:-1
                                                  longit:-1
                                              locationEn:-1
                                                 autoriz:-1
                                              uploadData:0x7];
                
                [_loadingContainer setHidden:true];
                
                [self showDeActivateCard];
            });
        }];
    }];
}

// Показать элементы экрана "Активированной" карты
- (void)showActivateCard
{
    // Заполняю контент
    cActImgCard.image= [PECBuilderCards createImageViewFromObj:currentModelDataCard keyData:@"dataImgCard" keyUrl:@"urlImgCard"];
    cActTitleCard.text = currentModelPartner.namePartrner;
    cActNumberCard.text = currentModelDataCard.numberCard;
    cActDiscountActionCard.text = [NSString stringWithFormat:@"Скидка %d%%",currentModelDataCard.discountCard];
    
    [self ZXingCode:true imgView:imgCardViewBarCode];
    [self ZXingCode:false imgView:imgCardViewQRCode];

    [self animationHideShowUIView:_deActivationContainer showHide:false Select:0];
    [self animationHideShowUIView:_activationContainer showHide:true Select:0];
}


// ~ КАРТОЧКА ДЕАКТИВИРОВАНА

// Нажимаю на кнопку активировать карточку
- (IBAction)bActEvent:(id)sender
{
    // Если отсутствует интернет игнорируем действие
    if([self notInternetConnection]) return;
    
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
        
    [netCtrl activateCardServer:[self selectedCard] userId:idUser callback:^(NSArray *sender){
        
        [_loadingContainer setHidden:false];
        
        if([sender count]!=0){
            
            // Скачиваю и заполняю информацию о карточках по u_id
            PECModelDataUser *modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
            
            [netCtrl getCardUserDataServer: modelUser.idUser callback:^(id sender){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    // Обновляю пользовательские настройки
                    [PECBuilderModel uploadModelDataSettings:-1
                                                   idCountry:-1
                                                         lat:-1
                                                      longit:-1
                                                  locationEn:-1
                                                     autoriz:-1
                                                  uploadData:0x7];
                    
                    [_loadingContainer setHidden:true];
                    
                    [self showActivateCard];
                });
            }];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_loadingContainer setHidden:true];
            });
        }
    }];
}

// ~ СИСТЕМНЫЕ

// Сообщения
-(void)cellAlertMsg:(NSString*)msg
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


- (void)ZXingCode:(BOOL)typeCode imgView: (UIImageView*)imgView
{
    // Красатульки
    imgView.image = [UIImage imageNamed:@"card_default.jpg"];
    [codeBarActiveContainer setText:currentModelDataCard.numberCard];
    
    // Номер карточки
    NSString *parseNumberCard = currentModelDataCard.numberCard;
    
    // Формат карточки (8 13 128)
    int formatCardInt = [currentModelDataCard.formatCard intValue];
    ZXBarcodeFormat formatCode = kBarcodeFormatCode128;
    
    // Пустой запрос
    if([parseNumberCard isEqualToString:@""])
    {
        [imgView setHidden:false];
        return;
    }
    
    int countZero;
    
    if(formatCardInt==8)
        formatCode = kBarcodeFormatEan8;
    if(formatCardInt==13)
        formatCode = kBarcodeFormatEan13;
    
    if(formatCardInt==8 || formatCardInt==13)
    {
        // Цифр от сервера должно быть меньше чем формат
        if([currentModelDataCard.numberCard length]>=formatCardInt)
        {
            [imgView setHidden:false];
            return;
        }
        
        // Количество цифр которые нужно дополнить нулями
        countZero = (formatCardInt-1) - [parseNumberCard length];
        
        // Добавляю нули если цифр меньше 7 или 12 в зависимости от типа кодировки
        for(int i = 0; i < countZero; i++)
            parseNumberCard  = [NSString stringWithFormat:@"%@0",parseNumberCard];
        
        // Добавляю 8 или 13 цифру как контрольную сумму
        int checksum = [self getCheckSum:parseNumberCard];
        parseNumberCard = [NSString stringWithFormat:@"%@%i",parseNumberCard,checksum];
        
        [imgView setHidden:false];
    }
    
    NSError* error = nil;
    
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result;
    if(typeCode)
    {
        result = [writer encode:parseNumberCard
                         format:formatCode
                          width:500
                         height:500
                          error:&error];
        
    }else{
        result = [writer encode:parseNumberCard
                         format:kBarcodeFormatQRCode
                          width:1000
                         height:1000
                          error:&error];
    }
    
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        
        UIImage * imageRes = [UIImage imageWithCGImage:image];
        
        imgView.image=imageRes;
        
    } else {
        NSString* errorMessage = [error localizedDescription];
        //imgView.image=[UIImage imageNamed:@"card_default.jpg"];
    }
}

-(int) getCheckSum :(NSString *)s
{
    int length = s.length;
    int sum = 0;
    for (int i = length - 1; i >= 0; i -= 2) {
        int digit = (int) [s characterAtIndex:i]- (int) '0';
        if (digit < 0 || digit > 9) {
            // Throw exception
        }
        sum += digit;
    }
    sum *= 3;
    for (int i = length - 2; i >= 0; i -= 2) {
        int digit = (int) [s characterAtIndex:i] - (int) '0';
        if (digit < 0 || digit > 9) {
            // Throw exception
        }
        sum += digit;
    }
    int chkdig = 10 - sum % 10;
    if (sum%10!=0)
        chkdig = 10 - sum % 10;
    else
        chkdig = 0 ;
    
    return chkdig;
}


// Показать элементы экрана "Деактивированной" карты
- (void)showDeActivateCard
{
    // Заполняю контент
    cDeActImgCard.image = [PECBuilderCards createImageViewFromObj:currentModelDataCard keyData:@"dataImgCard" keyUrl:@"urlImgCard"];
    cDeActTitleCard.text = currentModelPartner.namePartrner;
    //cDeActDescCard.text = currentModelPartner.descPartrner;

    // Нахожу информацию о карточке находящейся по определенному адресу
    NSArray *arrPointsOnMap = [PECBuilderModel parserJSONPoints:[PECModelsData getModelPartners] error:nil];
    for(PECModelPoints *points in arrPointsOnMap)
    {
        if(points.addressIdPartrner==3)//currentModelDataCard.idAddressCard
        {
            cDeActNumTelephoneCompany.text = points.addressTeleph1Partner;
            //cDeActAddressCompany.text = points.addressTextPartrner;
            cDeActTimeWorkCompany.text = points.addressopenHoursPartrner;
        }
    }

    [self animationHideShowUIView:_activationContainer showHide:false Select:0];
    [self animationHideShowUIView:_deActivationContainer showHide:true Select:0];
}


// ~ СИСТЕМНЫЕ

// Кнопочка назад
- (IBAction)butBack:(UIButton *)sender
{
    [_loadingContainer setHidden:false];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self navigationController] popViewControllerAnimated:YES];
        });
    });

}

// Кнопочка новости
- (IBAction)butNews:(UIButton *)sender
{
    // Если отсутствует интернет игнорируем действие
    if([self notInternetConnection]) return;
    
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    [netCtrl getPartnerNewsServer:currentModelPartner.idPartner callback:^(id sender)
     {
         dispatch_sync(dispatch_get_main_queue(),
                       ^{
                           PECNewsPartnerViewCtrl *newsController = [self.storyboard instantiateViewControllerWithIdentifier:@"newsPartenrController"];
                           newsController.idCurrentPartner = currentModelPartner.idPartner;//[sender tag];
                           [self.navigationController pushViewController: newsController animated:YES];
                       });
     }];
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

// Кнопочка Адрес
- (IBAction)butAddressEvent:(UIButton *)sender
{
    
    PECAddressPartnerViewCtrl *addressController = [self.storyboard instantiateViewControllerWithIdentifier:@"addressPartenrController"];
    addressController.idCurrentPartner = currentModelPartner.idPartner;
    [self.navigationController pushViewController: addressController animated:YES];
}

// Кнопочка Адрес
- (IBAction)butAddressEvent2:(UIButton *)sender
{
    NSLog(@"address");
    PECAddressPartnerViewCtrl *addressController = [self.storyboard instantiateViewControllerWithIdentifier:@"addressPartenrController"];
    addressController.idCurrentPartner = currentModelPartner.idPartner;

    if(currentModelDataCard.distanceCard != 0.0f)
        addressController.distCurrent = [NSString stringWithFormat:@"%.1f",currentModelDataCard.distanceCard];

    [self.navigationController pushViewController: addressController animated:YES];
}

// Кнопочка О ПАРТНЕРЕ
- (IBAction)bAboutPartnerEvent:(UIButton *)sender
{
    PECAboutPartnerViewCtrl *addressController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutPartenrController"];
    addressController.idCurrentPartner = currentModelPartner.idPartner;
    [self.navigationController pushViewController: addressController animated:YES];
}


// Системные
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Анимация с эффектом Hide и Show
-(void)animationHideShowUIView: (UIView*) curUIView showHide: (BOOL) showHide Select:(int)SelectPage
{
    float alpha;
    if(showHide){ alpha = 1.0; }else{ alpha = 0.0; }
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         curUIView.alpha = showHide;
                     } completion:^(BOOL completed) {
                     }];
}

@end
