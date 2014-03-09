//
//  PECDetailActionViewCtrl.m
//  JamCard
//
//  Created by Admin on 11/26/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECDetailActionViewCtrl.h"
#import "PECModelDataAction.h"
#import "PECBuilderCards.h"
#import "PECBuilderModel.h"
#import "PECNetworkDataCtrl.h"
#import "PECModelsData.h"
#import "PECModelDataUser.h"
#import "PECAddressPartnerViewCtrl.h"
#import "Reachability.h"

#import "ZXingObjC.h"

@interface PECDetailActionViewCtrl ()

@end

@implementation PECDetailActionViewCtrl
{
    // Контейнеры для хранения фреймов акции
    
    // Заголовок акции
    UILabel *titleAction;
    
    //UITextView *descAction;
    
    UILabel *discountAction;
    UILabel *addressAction;
    
    // Картинка  акции
    UIImageView *imgAction;
    
    PECModelDataAction * currentModelDataAction;
    
    UIView *containerCode;
    UIScrollView *scrollViewAction;
    
    UIButton *butActAct;
    UIButton *butAddress;
    
    PECModelDataUser *modelUser;
    int idUser;
    
    UIImageView *imgCardViewBarCode;
    UIControl *contCardViewBarCode;
    
    UIImageView *imgCardViewQRCode;
    UIControl *contCardViewQRCode;
    
    bool qrCodeBig;
    bool barCodeBig;
    
    UIControl *whiteContainer;
    
    UILabel *codeBarActiveContainer;
    UILabel *limitTimeAction;
    
    
    UIView *infoContainer;
    int kCode;
    float yCoordBarCode;
    float yCoordQRCode;
    
    int acktiveCode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self initElementsAutorizController];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        scrollViewAction.contentSize = CGSizeMake(320, 590);
        containerCode.frame = CGRectOffset( containerCode.frame, 0.0f, -90.0f);
    }
    
    //yCoordBarCode = 365.0;
    
    // Получаю данные выбранной акции
    for(PECModelDataAction *modelData in [PECModelsData getModelAction])
        if(modelData.idAction == [self selectedAction])
            currentModelDataAction = modelData;
    
    // Узнаю к какому партнеру пренадлежим акция
    
    
    
    NSString *textTitle = [PECBuilderModel getModelParnterAtId:currentModelDataAction.partnerIdAction].namePartrner;
    titleAction.text = textTitle;
    [titleAction sizeToFit];
    
    int numLine = ceil(titleAction.frame.size.height/26.0f);
    kCode = numLine*14;
    
    if(numLine>1)
    {
        titleAction.numberOfLines = numLine;
        infoContainer.frame = CGRectOffset(infoContainer.frame, 0.0f, kCode);
        [titleAction setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22-numLine]];
        
        contCardViewBarCode.frame = CGRectOffset(contCardViewBarCode.frame, 0.0f, kCode);
        contCardViewQRCode.frame = CGRectOffset(contCardViewQRCode.frame, 0.0f, kCode);
    }
    
    yCoordBarCode = contCardViewBarCode.frame.origin.y;
    yCoordQRCode = contCardViewQRCode.frame.origin.y;
    
    imgAction.image = [PECBuilderCards createImageViewFromObj:currentModelDataAction keyData:@"logoDataAction" keyUrl:@"logoAction"];
    discountAction.text = [NSString stringWithFormat:@"Скидка %d%%",currentModelDataAction.discountAction];
    
    limitTimeAction.text = [NSString stringWithFormat:@"с %@ по %@",currentModelDataAction.startDateAction,currentModelDataAction.endDateAction];
    //addressAction.text = currentModelDataAction.
    
    // Получаю id пользователя зарегестрированного в системе
    modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
    if(modelUser.usMail!=nil)
        idUser = modelUser.idUser;
    
    // Определяю какой сценарий сцены выполнять (активирована или нет)
    [self scenaInitAction];
}

// Отображаю нужный сценарий
- (void)scenaInitAction
{
    if(currentModelDataAction.activationAction)
    {
        // Y 400
        [self ZXingCode:true imgView:imgCardViewBarCode];
        [self ZXingCode:false imgView:imgCardViewQRCode];

        [containerCode setHidden:true];
        [contCardViewBarCode setHidden:false];
        [contCardViewQRCode setHidden:false];
    }else{
        // Y 444
        [containerCode setHidden:false];
        
        [contCardViewBarCode setHidden:true];
        [contCardViewQRCode setHidden:true];
    }
}

// Нажимаю на кнопку активировать карточку
- (IBAction)bActEvent:(id)sender
{
    // Если отсутствует интернет игнорируем действие
    if([self notInternetConnection]) return;
    
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    // Запрос к серверу для Активации(выдачи) специального предложения
    [netCtrl activateActionServer:currentModelDataAction.idAction userId:idUser callback:^(id sender)
     {
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self scenaInitAction];
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
    [codeBarActiveContainer setText:currentModelDataAction.cardNumberAction];
    
    // Номер карточки
    NSString *parseNumberCard = currentModelDataAction.cardNumberAction;
    
    // Формат карточки (8 13 128)
    int formatCardInt = [currentModelDataAction.cardFormatAction intValue];
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
        if([currentModelDataAction.cardNumberAction length]>=formatCardInt)
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
//                         contCardViewBarCode.transform = CGAffineTransformMakeRotation(M_PI_2);
                     }
                     completion:^(BOOL finished){
                         barCodeBig = !barCodeBig;
                     }];
}

- (IBAction)bViewQRCodeEvent:(id)sender
{
    
    CGRect contFrame = contCardViewQRCode.frame;
    
    if(barCodeBig)[self bViewBarCodeEvent:nil];
    
    float k, y, x;
    if(!qrCodeBig)
    {
        [whiteContainer setAlpha:0.0];
        [whiteContainer setHidden:false];
        
        k=2; y = 130.0f; x = 90.0f; acktiveCode = 2;
    }else{
        [whiteContainer setHidden:true];
        k=0.5; y = yCoordQRCode; x = 220.0f;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
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


// ~ ИНИЦИАЛИЗАЦИЯ

// Инициализация элементов экрана
-(void) initElementsAutorizController
{
    // Контейнеры для хранения фреймов
    containerCode = (UIView*)[self.view viewWithTag:108];

    //descAction = (UITextView*)[self.view viewWithTag:100];
    
    imgAction = (UIImageView*)[self.view viewWithTag:101];
    //Adds a shadow to sampleView
    CALayer *layerAct = imgAction.layer;
    layerAct.cornerRadius = 5;
    layerAct.masksToBounds = YES;
    
    discountAction = (UILabel*)[self.view viewWithTag:102];
    titleAction = (UILabel*)[self.view viewWithTag:103];
    addressAction = (UILabel*)[self.view viewWithTag:104];
    limitTimeAction = (UILabel*)[self.view viewWithTag:105];
    
    butAddress = (UIButton*)[self.view viewWithTag:118];
    [butAddress addTarget:self action:@selector(butAddressActionEvent:) forControlEvents:UIControlEventTouchDown];
    [butAddress setExclusiveTouch:YES];
    
    
    butActAct = (UIButton*)[self.view viewWithTag:130];
    [butActAct addTarget:self action:@selector(bActEvent:) forControlEvents:UIControlEventTouchDown];
    [butActAct setExclusiveTouch:YES];
    
    scrollViewAction = (UIScrollView*)[self.view viewWithTag:601];
    
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
    
    whiteContainer = (UIControl*)[self.view viewWithTag:400];
    [whiteContainer addTarget:self action:@selector(bCloseCodeEvent:) forControlEvents:UIControlEventTouchDown];
    [whiteContainer setExclusiveTouch:YES];
    
    codeBarActiveContainer = (UILabel*)[self.view viewWithTag:306];
    
    infoContainer = (UIView*)[self.view viewWithTag:322];
    
    

}

// Кнопочка Адрес
- (IBAction)butAddressActionEvent:(UIButton *)sender
{
    NSLog(@"address");
    PECAddressPartnerViewCtrl *addressController = [self.storyboard instantiateViewControllerWithIdentifier:@"addressPartenrController"];
    addressController.idCurrentPartner = currentModelDataAction.idAction;
    addressController.selectedType = 1;

    if(currentModelDataAction.distAction != 0.0f)
        addressController.distCurrent = [NSString stringWithFormat:@"%.1f",currentModelDataAction.distAction];
    
    [self.navigationController pushViewController: addressController animated:YES];
}


// ~ СИСТЕМНЫЕ

// Кнопочка назад
- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"!!!didReceiveMemoryWarning!!!");
}

@end
