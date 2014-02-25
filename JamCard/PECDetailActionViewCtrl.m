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

#import "ZXingObjC.h"

@interface PECDetailActionViewCtrl ()

@end

@implementation PECDetailActionViewCtrl
{
    // Контейнеры для хранения фреймов акции
    
    // Заголовок акции
    UILabel *titleAction;
    
    UILabel *descAction;
    
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!---------");
//    /*
    [self initElementsAutorizController];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        //scrollViewAction.frame = (CGRect){scrollViewAction.frame.origin, CGSizeMake(320, 446)};
        scrollViewAction.contentSize = CGSizeMake(320, 590);
        
        containerCode.frame = CGRectOffset( containerCode.frame, 0.0f, -90.0f);
        
        
        //contCardViewBarCode.frame = CGRectOffset( contCardViewBarCode.frame, 0.0f, -90.0f);
        //contCardViewQRCode.frame = CGRectOffset( contCardViewQRCode.frame, 0.0f, -90.0f);
        
    }
    
    
    // Получаю данные выбранной акции
    for(PECModelDataAction *modelData in [PECModelsData getModelAction])
        if(modelData.idAction == [self selectedAction])
            currentModelDataAction = modelData;
    
    // Узнаю к какому партнеру пренадлежим акция
    titleAction.text = [PECBuilderModel getModelParnterAtId:currentModelDataAction.partnerIdAction].namePartrner;;
    descAction.text = currentModelDataAction.textAction;
    imgAction.image = [PECBuilderCards createImageViewFromObj:currentModelDataAction keyData:@"logoDataAction" keyUrl:@"logoAction"];
    discountAction.text = [NSString stringWithFormat:@"Скидка %d%%",currentModelDataAction.discountAction];
    //addressAction.text = currentModelDataAction.
    
    // Получаю id пользователя зарегестрированного в системе
    modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
    if(modelUser.usMail!=nil)
        idUser = modelUser.idUser;
    
    // Определяю какой сценарий сцены выполнять (активирована или нет)
    [self scenaInitAction];
  //  */
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
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc] init];
    
    NSLog(@"act action");
    
    // Запрос к серверу для Активации(выдачи) специального предложения
    [netCtrl activateActionServer:currentModelDataAction.idAction userId:idUser callback:^(id sender)
     {
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self scenaInitAction];
         });
     }];
}

- (void)ZXingCode:(BOOL)typeCode imgView: (UIImageView*)imgView
{
    imgView.image = [UIImage imageNamed:@"card_default.jpg"];
    
    if([currentModelDataAction.cardNumberAction length]==7)
    {
        [imgView setHidden:false];
        
        NSString *parseNumberCard = [NSString stringWithFormat:@"%@00000",currentModelDataAction.cardNumberAction];
        int checksum = [self getCheckSum:parseNumberCard];
        parseNumberCard = [NSString stringWithFormat:@"%@%i",parseNumberCard,checksum];
        NSError* error = nil;
        
        ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
        
        ZXBitMatrix* result;
        
        if(typeCode){
            result = [writer encode:parseNumberCard
                             format:kBarcodeFormatEan13
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
    }else{
        //[imgView setHidden:true];
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
    
    float k = 1.0f, y = 420.0f;
    if(!barCodeBig)
    {
        [whiteContainer setAlpha:0.0];
        [whiteContainer setHidden:false];
        k=2; y = 130.0f;
    }else{
        [whiteContainer setHidden:true];
        k=0.5; y = 420.0f;
    }
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGRect contFrame = contCardViewBarCode.frame;
                         [contCardViewBarCode setFrame:CGRectMake(20, y, contFrame.size.width*k, contFrame.size.height*k)];
                         [whiteContainer setAlpha:0.8];
                     }
                     completion:^(BOOL finished){
                         barCodeBig = !barCodeBig;
                     }];
    
}

- (IBAction)bViewQRCodeEvent:(id)sender
{
    if(barCodeBig)[self bViewBarCodeEvent:nil];
    
    float k = 1.0f, y = 420.0f, x = 220.0f;
    if(!qrCodeBig)
    {
        [whiteContainer setAlpha:0.0];
        [whiteContainer setHidden:false];
        k=2; y = 130.0f; x = 90.0f;
    }else{
        [whiteContainer setHidden:true];
        k=0.5; y = 420.0f; x = 220.0f;
    }
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGRect contFrame = contCardViewQRCode.frame;
                         [contCardViewQRCode setFrame:CGRectMake(x, y, contFrame.size.width*k, contFrame.size.height*k)];
                         [whiteContainer setAlpha:0.8];
                     }
                     completion:^(BOOL finished){
                         qrCodeBig = !qrCodeBig;
                     }];
    
}


// ~ ИНИЦИАЛИЗАЦИЯ

// Инициализация элементов экрана
-(void) initElementsAutorizController
{
    // Контейнеры для хранения фреймов
    containerCode = (UIView*)[self.view viewWithTag:108];

    descAction = (UILabel*)[self.view viewWithTag:100];
    
    imgAction = (UIImageView*)[self.view viewWithTag:101];
    //Adds a shadow to sampleView
    CALayer *layerAct = imgAction.layer;
    layerAct.cornerRadius = 5;
    layerAct.masksToBounds = YES;
    
    discountAction = (UILabel*)[self.view viewWithTag:102];
    titleAction = (UILabel*)[self.view viewWithTag:103];
    addressAction = (UILabel*)[self.view viewWithTag:104];
    
    butAddress = (UIButton*)[self.view viewWithTag:118];
    [butAddress addTarget:self action:@selector(butAddressActionEvent:) forControlEvents:UIControlEventTouchDown];
    
    
    butActAct = (UIButton*)[self.view viewWithTag:130];
    [butActAct addTarget:self action:@selector(bActEvent:) forControlEvents:UIControlEventTouchDown];
    
    scrollViewAction = (UIScrollView*)[self.view viewWithTag:601];
    
    imgCardViewBarCode = (UIImageView*)[self.view viewWithTag:110];
    contCardViewBarCode = (UIControl*)[self.view viewWithTag:111];
    [contCardViewBarCode addTarget:self action:@selector(bViewBarCodeEvent:) forControlEvents:UIControlEventTouchDown];
    
    
    //Adds a shadow to sampleView
    CALayer *layerBarCode = contCardViewBarCode.layer;
    layerBarCode.cornerRadius = 5;
    layerBarCode.masksToBounds = YES;
    
    imgCardViewQRCode = (UIImageView*)[self.view viewWithTag:120];
    contCardViewQRCode = (UIControl*)[self.view viewWithTag:121];
    [contCardViewQRCode addTarget:self action:@selector(bViewQRCodeEvent:) forControlEvents:UIControlEventTouchDown];
    
    //Adds a shadow to sampleView
    CALayer *layerQRCode = contCardViewQRCode.layer;
    layerQRCode.cornerRadius = 5;
    layerQRCode.masksToBounds = YES;
    
    whiteContainer = (UIControl*)[self.view viewWithTag:400];

}

// Кнопочка Адрес
- (IBAction)butAddressActionEvent:(UIButton *)sender
{
    NSLog(@"address");
    PECAddressPartnerViewCtrl *addressController = [self.storyboard instantiateViewControllerWithIdentifier:@"addressPartenrController"];
    addressController.idCurrentPartner = currentModelDataAction.idAction;
    addressController.selectedType = 1;
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
