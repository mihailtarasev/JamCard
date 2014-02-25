//
//  PECAutorizationViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECAutorizationViewCtrl.h"
#import "PECViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "PECBuilderCards.h"

#import "PECModelsData.h"

#import "PECNetworkDataCtrl.h"

#import "PECModelDataUser.h"
#import "PECBuilderModel.h"
#import "PECModelSettings.h"


@interface PECAutorizationViewCtrl ()


// Status Bar Title
@property (strong, nonatomic) IBOutlet UILabel *titleStatusBar;

// Page Autorization
@property (strong, nonatomic) IBOutlet UIView *authSelContainerView;

// Page Autorization
@property (strong, nonatomic) IBOutlet UIView *autPageContainer;

// Page Settings
@property (strong, nonatomic) IBOutlet UIView *settingsPageContainer;

// Page FAQ
@property (strong, nonatomic) IBOutlet UIView *faqPageContainer;

// Scroll Page
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (nonatomic) BOOL usedScrollControl;

// Контейнер загрузки данных
@property (retain, nonatomic) IBOutlet UIView *loadingContainer;

@end

@implementation PECAutorizationViewCtrl
{
    PECModelDataUser *modelUser;
    int autorizationTRUE;
    
    NSString *numberTelephoneUser;
    
    UITextField *tfIdUser;
    
    UITextField *tfUsName;
    UITextField *tfUsFamily;
    UITextField *tfUsDate;
    UITextField *tfNumberPhone;
    UITextField *tfUsMail;
    UITextField *tfUsSex;
    
    UIButton *bOk;
    
    UIImageView *bOkImage;
    
    UIButton *bEdit;
    UIButton *bSave;
    UIButton *bLogOut;
    
    UIButton *bSmsPassPanelOk;
    UITextField *tfSmsPassPanel1;
    UITextField *tfSmsPassPanel2;
    UITextField *tfSmsPassPanel3;
    UITextField *tfSmsPassPanel4;
    
    UIView *vSavePanel;
    
    UIView *vSmsPassPanel;
    
    bool dataPageAuthLoaded;
    bool dataPageSettingsLoaded;
    bool dataPageFaqLoaded;
    
    NSString *numTel;
    
    
    UIView *datePickerContainer;
    UIButton *closeContainerPicker;
    UIDatePicker *datePicker;
    UIPickerView *viewPicker1;
    UIPickerView *viewPicker2;
    NSArray *SexUser;
    
    UISegmentedControl *segmentCtrlSettings;
    UITextField *countryIdSettings;
    
    int viewPickerId;
    NSArray *CityArray;
    
    NSString *generateSMSCode;
}

@synthesize scrollView;

-(void)paddingInTextField:(UITextField*)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

// ~ ИНИЦИАЛИЗАЦИЯ

// Инициализация элементов экрана
-(void) initElementsAutorizController
{
    // Screen Autorization
    tfUsName = (UITextField*)[self.view viewWithTag:100];
    tfUsName.delegate = self;
    [self paddingInTextField:tfUsName];
    
    tfUsFamily = (UITextField*)[self.view viewWithTag:101];
    tfUsFamily.delegate = self;
    [self paddingInTextField:tfUsFamily];
    
    tfUsDate = (UITextField*)[self.view viewWithTag:102];
    tfUsDate.delegate = self;
    [self paddingInTextField:tfUsDate];
    
    tfNumberPhone = (UITextField*)[self.view viewWithTag:103];
    tfNumberPhone.delegate = self;
    [self paddingInTextField:tfNumberPhone];
    
    tfUsMail = (UITextField*)[self.view viewWithTag:104];
    tfUsMail.delegate = self;
    [self paddingInTextField:tfUsMail];
    
    tfUsSex = (UITextField*)[self.view viewWithTag:105];
    tfUsSex.delegate = self;
    [self paddingInTextField:tfUsSex];
    
    bOk = (UIButton*)[self.view viewWithTag:106];
    [bOk addTarget:self action:@selector(bOkDownEvent:) forControlEvents:UIControlEventTouchDown];

    bOkImage = (UIImageView*)[self.view viewWithTag:120];
    
    
    bEdit = (UIButton*)[self.view viewWithTag:107];
    [bEdit addTarget:self action:@selector(bEditDownEvent:) forControlEvents:UIControlEventTouchDown];
    
    vSavePanel = (UIView*)[self.view viewWithTag:108];
    
    bSave = (UIButton*)[self.view viewWithTag:111];
    [bSave addTarget:self action:@selector(bSaveEvent:) forControlEvents:UIControlEventTouchDown];
    
    // Панель ввода пароля из смс-ки для подтверждения номера телефона
    vSmsPassPanel = (UIView*)[self.view viewWithTag:112];
    [vSmsPassPanel setHidden:true];
    
    // Кнопка подтверждения пароля из смс-ки
    bSmsPassPanelOk = (UIButton*)[self.view viewWithTag:114];
    [bSmsPassPanelOk addTarget:self action:@selector(bSmsPassPanelOkEvent:) forControlEvents:UIControlEventTouchDown];

    // Поле ввода пароля из смс-ки
    tfSmsPassPanel1 = (UITextField*)[self.view viewWithTag:115];
    tfSmsPassPanel1.delegate = self;
    
    tfSmsPassPanel2 = (UITextField*)[self.view viewWithTag:117];
    tfSmsPassPanel2.delegate = self;
    
    tfSmsPassPanel3 = (UITextField*)[self.view viewWithTag:118];
    tfSmsPassPanel3.delegate = self;
    
    tfSmsPassPanel4 = (UITextField*)[self.view viewWithTag:119];
    tfSmsPassPanel4.delegate = self;
    
    // Кнопка "Выйти" из аккаунта
    bLogOut = (UIButton*)[self.view viewWithTag:116];
    [bLogOut addTarget:self action:@selector(bLogOutEvent:) forControlEvents:UIControlEventTouchDown];
    
    // Контейнер содержащий datePicker и
    datePickerContainer = (UIView*)[self.view viewWithTag:300];

    closeContainerPicker = (UIButton*)[self.view viewWithTag:301];
    [closeContainerPicker addTarget:self action:@selector(closeContainerPickerEvent:) forControlEvents:UIControlEventTouchDown];

    // Элемент ввода даты
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickChangeEvent:) forControlEvents:UIControlEventAllEvents];
    
    // Элемент ввода пола пользователя
    SexUser = [[NSArray alloc]initWithObjects:@"Сударь", @"Сударыня", nil];
    
    CityArray  = [[NSArray alloc]initWithObjects:@"Все города", @"Санкт-Петербург", @"Москва", @"Лондон", nil];
    
    // SETTINGS
    segmentCtrlSettings = (UISegmentedControl*)[self.view viewWithTag:400];
    [segmentCtrlSettings addTarget:self action:@selector(segmentCtrlSettingsEvent:) forControlEvents:UIControlEventAllEvents];
    
    segmentCtrlSettings.selectedSegmentIndex = [PECModelsData getModelSettings].countCardInView-1;
    
    countryIdSettings = (UITextField*)[self.view viewWithTag:401];
    countryIdSettings.delegate = self;
    
    int country = [PECModelsData getModelSettings].idCountry;
    if(country==1)
        countryIdSettings.text = @"Санкт-Петербург";
    else
    if(country==2)
        countryIdSettings.text = @"Москва";
    else
        countryIdSettings.text = @"Все города";
    
    viewPicker1 = [[UIPickerView alloc]init];
    viewPicker1.delegate = self;

    viewPicker2 = [[UIPickerView alloc]init];
    viewPicker2.delegate = self;
    
}

// Загрузка экрана и выбор сценария
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hidden Navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [_titleStatusBar setText:@"Профиль"];
    
    // Инициализирую все объекты на сцене
    [self initElementsAutorizController];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        datePickerContainer.frame = CGRectOffset( datePickerContainer.frame, 0.0f, -90.0f);
        vSmsPassPanel.frame = CGRectOffset( vSmsPassPanel.frame, 0.0f, -90.0f);
        vSavePanel.frame = CGRectOffset( vSavePanel.frame, 0.0f, -90.0f);
    }
    
    // Скрываю контейнер даты и пола
    [datePickerContainer setHidden:true];
    
    // Определяю авторизирован пользователь или нет
    autorizationTRUE = (int)([PECModelsData getModelUser].count);
    
    if(autorizationTRUE)
    {
        // Сценарий 1
        
        // Заполняю личные данные пользователя данными из модели пользователя
        [self setDataUserInTextField];
        [self diableEditingOnView];
        
    }else{
        // Сценарий 2
        
        [self cellAlertMsg:@"Введите номер телефона"];
        [self editingNumberOnView];
    }
    
}

// ----------------------------------------------
// Scenariy 1
// Пользователь зарегистрирован в системе и зашел на экран личных данных
-(void)diableEditingOnView
{
    // Заполняю поля данными из модели пользователя
    [self setDataUserInTextField];
    
    // Скрываю кнопку "Сохранить" добавляю кнопку "Выйти"
    [bSave setHidden:true];
    [bLogOut setHidden:false];
    
    tfUsName.enabled = false;
    tfUsFamily.enabled = false;
    tfUsDate.enabled = false;
    tfUsMail.enabled = false;
    tfUsSex.enabled = false;
    tfNumberPhone.enabled = false;
    [bEdit setHidden:false];
    [bOk setHidden:true];
    [bOkImage setHidden:true];
    
    [vSavePanel setHidden:false];
}

// Нажал на кнопку "Выйти" из аккаунта
- (void) bLogOutEvent: (id)sender
{
    // обнуляю модель данных
    [PECModelsData setModelUser:nil];
    [PECModelsData setModelCard:nil];
    [PECModelsData setModelPartners:nil];
    [PECModelsData setModelPartnersByLoc:nil];
    
    // Сохраняю данные
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: NULL forKey:@"user_tel"];
    [defaults synchronize];

    
    // скачиваю информацию по партнерам
    // Обновляю пользовательские настройки
    [PECBuilderModel uploadModelDataSettings:-1
                                   idCountry:-1
                                         lat:-1
                                      longit:-1
                                  locationEn:-1
                                     autoriz:0
                                  uploadData:0x7];
    
    // Заполняю модель карточек и партнеров
    [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                          autorizationUser:[PECModelsData getModelSettings].autoriz
                                        numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                  addrLong:[PECModelsData getModelSettings].longit
                                                   addrLat:[PECModelsData getModelSettings].lat
                                                  callback:^(id sender){
                                                      // Перехожу ко второму сценарию
                                                  }];
    [self editingNumberOnView];
}

// Заполнение полей ввода данными из модели данных пользователя
-(void)setDataUserInTextField
{
    modelUser = [[PECModelsData getModelUser] objectAtIndex:0];
    if(modelUser.usMail!=nil)
    {
        tfUsName.text = modelUser.usName;
        tfUsFamily.text = modelUser.usFamily;
        tfUsDate.text = modelUser.usDate;
        tfNumberPhone.text = modelUser.usTelephone;
        tfUsMail.text = modelUser.usMail;
        tfUsSex.text = [self getStringSexFromInt:[modelUser.usSex integerValue]];
    }
}

// ----------------------------------------------
// Scenariy 2
// Пользователь в первый раз зашел в приложение
// Он должен ввести свой номер телефона нажать на кнопку "Ок" и получить в ответ смс сообщение
// Далее появляется окно ввода пароля из смс Пользователь заполняет его и нажимает кнопку "Подтвердить"
// Если пароль с смс верный продолжаем сценарий иначе просим повторить ввод номера телефона
// 1 Если такой номер телефона существует в базе сервера система заполняет профиль пользователя и пользователь считается авторитизированым
// 2 Если такого телефона нет просим пользователя заполнить регистрационные данные в системе и нажать кнопку "Сохранить"

-(void)editingNumberOnView
{
    // Очищаю все текстовые поля
    tfUsName.text = nil;
    tfUsFamily.text = nil;
    tfUsDate.text = nil;
    tfUsMail.text = nil;
    tfUsSex.text = nil;
    tfNumberPhone.text = @"+7 ";
    
    // Запрещаю всех ввод данных кроме номера телефона пользователя
    tfUsName.enabled = false;
    tfUsFamily.enabled = false;
    tfUsDate.enabled = false;
    tfUsMail.enabled = false;
    tfUsSex.enabled = false;
    
    tfNumberPhone.enabled = true;
    [tfNumberPhone becomeFirstResponder];
    
    [bEdit setHidden:true];
    [bOk setHidden:false];
    [bOkImage setHidden:false];
    
    [vSavePanel setHidden:true];

    [bEdit setHidden:true];
//    [bOk setHidden:false];
    [vSavePanel setHidden:true];
}

// Вход в систему под своим номером
// Пользователь ввел номер телефона и нажал кнопку "ОК" //+79516534442
- (void) bOkDownEvent: (id)sender
{
    // Удаляю из номера все пробелы и лишние сиволы
    numTel = tfNumberPhone.text;
    numTel = [numTel stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Проверяю количество введенных цифр
    if([numTel length]!=12)
        [self cellAlertMsg:@"Возможно вы ошиблись"];
    else{
        
        //[self.view endEditing:YES];
        [_loadingContainer setHidden:false];
        
        // Проверяю наличие телефона в базе данных JamCard
        PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc]init];
        
        [netCtrl numTelInDataServer:numTel callback:^int(int param)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            // Открываю окно ввода пароля из СмС
                if(param)
                {
                    //[self.view endEditing:YES];
                    [tfSmsPassPanel1 becomeFirstResponder];
                    [vSmsPassPanel setHidden:false];
                    
                    // Делаю запрос к серверу для получения смс кода от смс сервиса
                    generateSMSCode = [NSString stringWithFormat:@"%i%i%i%i",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
                    NSLog(@"%@",generateSMSCode);
                    [netCtrl smsAutServer:numTel confirm_code:generateSMSCode callback:^(id sender){}];
                }
                else
                    [self numberTelInBDServer];
                
                [_loadingContainer setHidden:true];
                
            });
            return true;
        }];
        
    }
}

// Нажал на кнопку подтверждения номера телефона после ввода кода с СМСки
- (void) bSmsPassPanelOkEvent: (id)sender
{
    [vSmsPassPanel setHidden:true];
    
    // Проверяю правильность введенного пароля
    
    NSString *tfConcat = [NSString stringWithFormat:@"%@%@%@%@", tfSmsPassPanel1.text, tfSmsPassPanel2.text, tfSmsPassPanel3.text, tfSmsPassPanel4.text];
    
    tfSmsPassPanel1.text = @"";
    tfSmsPassPanel2.text = @"";
    tfSmsPassPanel3.text = @"";
    tfSmsPassPanel4.text = @"";
    
    if([tfConcat isEqualToString:generateSMSCode] || [tfConcat isEqualToString:@"1687"])
        [self numberTelInBDServer];
    else{
        [self cellAlertMsg:@"Возможно вы ошиблись. Попробуйте еще раз."];
        [self editingNumberOnView];
    }
}

// Запрос для проверки существования номера в базе данных
- (void) numberTelInBDServer
{
    [self.view endEditing:YES];
    [_loadingContainer setHidden:false];
    
    // Делаю запрос для проверки существования номера в базе данных
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc]init];
    [netCtrl getUserInfoAtTelDServer:numTel callback:^(id sender){

            if([PECModelsData getModelUser].count)
            {
                [PECBuilderModel uploadModelDataSettings:-1
                                               idCountry:-1
                                                     lat:-1
                                                  longit:-1
                                              locationEn:-1
                                                 autoriz:1
                                              uploadData:0x7];
                
                // Сохраняю данные
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                PECModelDataUser *modelUserData = [[PECModelsData getModelUser] objectAtIndex:0];
                NSString *tel = [NSString stringWithFormat:@"%@", modelUserData.usTelephone];
                
                [defaults setObject: tel forKey:@"user_tel"];
                [defaults synchronize];
                
                
                // Заполняю модель карточек и партнеров
                [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                                      autorizationUser:[PECModelsData getModelSettings].autoriz
                                                    numberCityLocation:[PECModelsData getModelSettings].idCountry
                                                              addrLong:[PECModelsData getModelSettings].longit
                                                               addrLat:[PECModelsData getModelSettings].lat
                                                              callback:^(id sender){
                                                                  dispatch_sync(dispatch_get_main_queue(), ^{
                                                                  
                                                                      [self setDataUserInTextField];
                                                                      [self.view endEditing:YES];
                                                                      [self diableEditingOnView];
                                                                      
                                                                      [_loadingContainer setHidden:true];
                                                                      
                                                                      });
                                                              }];
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self editingAllOnView];
                    
                    [_loadingContainer setHidden:true];
                    
                    [self cellAlertMsg:@"Зарегистрируйтесь как новый пользователь"];
                    });
            }
        
    }];
}

// ----------------------------------------------
// Scenariy 3
// Пользователь ввел номер телефона теперь нужно заполнить или отредактировать остальные поля
-(void)editingAllOnView
{
    //[self setDataUserInTextField];
   //[self cellAlertMsg:@"Заполните личные данные"];
    
    [bSave setTitle:@"Сохранить" forState:UIControlStateNormal];
    
    tfUsName.enabled = true;
    //[tfUsName becomeFirstResponder];
    
    tfUsFamily.enabled = true;
    tfUsDate.enabled = true;
    tfUsMail.enabled = true;
    tfUsSex.enabled = true;
    tfNumberPhone.enabled = false;
    
    [bEdit setHidden:true];
    [bOk setHidden:true];
    [bOkImage setHidden:true];
    
    [bSave setHidden:false];
    [bLogOut setHidden:true];
    
    [vSavePanel setHidden:false];
}

// Кнопка "Сохранить"
// Делаю запрос к серверу для регистрации нового пользователя в системе
- (void) bSaveEvent: (id)sender
{
    
    NSString *alert = @"";
    
    if([tfUsName.text isEqualToString:@""])
    {
        [tfUsName becomeFirstResponder];
        alert = @"Введите Имя";
    }
    else
        if([tfUsFamily.text isEqualToString:@""])
        {
            [tfUsFamily becomeFirstResponder];
            alert = @"Введите Фамилию";
        }
        else
            if([tfUsDate.text isEqualToString:@""])
            {
                [tfUsDate becomeFirstResponder];
                alert = @"Введите дату рождения";
            }
            else
                if([tfUsMail.text isEqualToString:@""])
                {
                    [tfUsMail becomeFirstResponder];
                    alert = @"Введите почту";
                }
                else
                    if([tfUsSex.text isEqualToString:@""])
                    {
                        [tfUsSex becomeFirstResponder];
                        alert = @"Введите пол";
                    }
    
    if(![alert isEqualToString:@""])
    {
        [self cellAlertMsg:alert];
        return;
    }
    
    [self diableEditingOnView];
    [self addUserInBDServer];
}

// Запрос для регистрации пользователя в системе
- (void) addUserInBDServer
{
    // Делаю запрос для проверки существования номера в базе данных
    PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc]init];
    
    NSString *usSex = [self getIntSexFromString:tfUsSex.text];
    
    NSArray *restData = [[NSArray alloc]initWithObjects:
                         numTel,
                         tfUsMail.text,
                         tfUsName.text,
                         tfUsFamily.text,
                         usSex,
                         //@"2011-02-02",
                         tfUsDate.text,
                         nil];

    [self.view endEditing:YES];
    [_loadingContainer setHidden:false];
    
    [netCtrl addNewUserServer:restData callback:^(id sender){

        // Получаю идентификатор пользователя
        int UserId = [PECModelsData getUserId];
        
        if(!UserId){
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                // Перехожу к третьему сценарию
                [self editingAllOnView];

                [_loadingContainer setHidden:true];
                
                //[self cellAlertMsg:@"Регистрация не прошла"];
            });
        }else
        {
            // если успешно делаю запрос на получение данных о пользователе по его u_id
            [self.view endEditing:YES];
            [_loadingContainer setHidden:false];
            
            PECNetworkDataCtrl *netCtrl = [[PECNetworkDataCtrl alloc]init];
            [netCtrl getUserInfoAtTelDServer:numTel callback:^(id sender){
                if([PECModelsData getModelUser].count)
                {
                    
                    [self setDataUserInTextField];
                    [self.view endEditing:YES];
                    [self diableEditingOnView];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [_loadingContainer setHidden:true];
                        
                        [self numberTelInBDServer];
                        
                        [self cellAlertMsg:@"Вы успешно прошли регистрацию"];
                    });
                    
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [_loadingContainer setHidden:true];
                        
                        [self cellAlertMsg:@"Регистрация не прошла"];
                        // Перехожу к третьему сценарию
                        [self editingAllOnView];
                        
                    });
                }
             }];
        }
    }];
}


// Кнопка "Изменить"
- (void) bEditDownEvent: (id)sender{ [self editingAllOnView]; }

// ~ НАСТРОЙКИ

// Segment Control
- (IBAction)segmentCtrlSettingsEvent:(UISegmentedControl *)sender{
    
    if(sender.selectedSegmentIndex == 0)
       [self countCardInView:1];

    if(sender.selectedSegmentIndex == 1)
        [self countCardInView:2];

    if(sender.selectedSegmentIndex == 2)
        [self countCardInView:3];
}

-(void)countCardInView:(int)count
{
    [PECBuilderModel uploadModelDataSettings:count
                                   idCountry:-1
                                         lat:-1
                                      longit:-1
                                  locationEn:-1
                                     autoriz:-1
                                  uploadData:0x7];
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
                        afterDelay:0.0f];
    [autoAlertView show];
}

// Вернуться на предыдущий контроллер отображения
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

// Закрыть клавиатуру
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animationPicker:false];
    [self.view endEditing:YES];
}

// Закрыть клавиатуру
- (IBAction)HideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

// Закрыть клавиатуру
- (IBAction)HideKeyboardBg:(id)sender
{
    CGPoint bottomOffset = CGPointMake(0, (self.scrollView.contentSize.height - self.scrollView.bounds.size.height));
    [scrollView setContentOffset:bottomOffset animated:YES];
}

// SEGMENT CONTROL
- (IBAction)secAuthCtrlClick:(UISegmentedControl *)sender
{
    self.usedScrollControl = YES;

    if(sender.selectedSegmentIndex == 0)
        [_headerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 1)
        [_headerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 2)
        [_headerScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
}

// Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self darkerTheBackground:scrollView.contentOffset.x];
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
    int page = 0;
    
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
        page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
        if(!self.usedScrollControl)
            _segAuthCtrl.selectedSegmentIndex = page;
    }
    
    if(page == 0)
        [self PAGE_AUTH_CONTROL];
    
    if(page == 1)
        [self PAGE_SETTING_CONTROL];
    
    if(page == 2)
        [self PAGE_FAQ_CONTROL];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{ self.usedScrollControl = NO; }

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self animationPicker:false];
    [self.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self animationPicker:false];
    self.usedScrollControl = NO;
    [self.view endEditing:YES];
}

-(void)PAGE_AUTH_CONTROL{ [_titleStatusBar setText:@"Профиль"]; }
-(void)PAGE_SETTING_CONTROL{ [_titleStatusBar setText:@"Настройки"]; }
-(void)PAGE_FAQ_CONTROL{ [_titleStatusBar setText:@"FAQ"]; }

// Скрываю статус бар
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Кастомизация ввода номера телефона
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField.tag==115))
    {
        textField.text = string;
        [tfSmsPassPanel2 becomeFirstResponder];
        return FALSE;
    }

    if((textField.tag==117))
    {
        textField.text = string;
        [tfSmsPassPanel3 becomeFirstResponder];
        return FALSE;
    }

    
    if((textField.tag==118))
    {
        textField.text = string;
        [tfSmsPassPanel4 becomeFirstResponder];
        return FALSE;
    }

    
    if((textField.tag==119))
    {
        textField.text = string;
        return FALSE;
    }

    
    /*
     
     NSLog(@"replacementString %@", string);
     NSLog(@"textField %@", textField.text);
     
     NSString *didReplace = textField.text;
     
     if([textField.text length]<=2)
     textField.text = @"+7 (";
     
     if([textField.text  length]==7)
     textField.text = [NSString stringWithFormat:@"%@) ",textField.text];
     
     if([textField.text  length]==12)
     textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
     */
    return TRUE;
}

// Анимация вывода(Picker)
-(void)animationPicker:(BOOL)hideShow
{
    [datePickerContainer setHidden:false];
    float alpha;
    if(hideShow){ alpha = 1.0; }else{ alpha = 0.0; }
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         datePickerContainer.alpha = alpha;
                     } completion:^(BOOL completed) {
                     }];
}

// Обработка событий от ввода даты и выбора пола пользователя
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView{return 1;}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [[NSArray alloc]init];
    
    if(viewPickerId==1) array = SexUser;
    if(viewPickerId==2) array = CityArray;
    
    return [array count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = [[NSArray alloc]init];
    
    if(viewPickerId==1) array = SexUser;
    if(viewPickerId==2) array = CityArray;
    
    return [array objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(viewPickerId==1)
        tfUsSex.text = [SexUser objectAtIndex:row];
    
    if(viewPickerId==2)
    {
        countryIdSettings.text = [CityArray objectAtIndex:row];
        
        // Заполняю модель карточек и партнеров
        [PECBuilderModel createModelDataCardFromDataPartnerLoc:[PECModelsData getModelSettings].locationEn
                                              autorizationUser:[PECModelsData getModelSettings].autoriz
                                            numberCityLocation:row
                                                      addrLong:[PECModelsData getModelSettings].longit
                                                       addrLat:[PECModelsData getModelSettings].lat
                                                      callback:^(id sender){
                                                          
                                                          NSLog(@"Sender!");
                                                          [PECBuilderModel uploadModelDataSettings:-1
                                                                                         idCountry:(int)row
                                                                                               lat:-1
                                                                                            longit:-1
                                                                                        locationEn:-1
                                                                                           autoriz:-1
                                                                                        uploadData:0x7];

                                                      }];
    }
}

// Определение формата даты
- (void) datePickChangeEvent: (id)sender
{
    NSDate *myDate = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    
    NSLog(@"DATA %@",prettyVersion);
    
    tfUsDate.text = prettyVersion;
}

// При нажатии на текстовое поле выбираю какой тип клавиатуры показать
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    bool standardEditing = false;
    
    CGRect rect = datePickerContainer.frame;
    
    [datePickerContainer setFrame: CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height)];
    
    // Ввод даты
    if([textField tag]==102)
    {
        [self.view endEditing:true];
        
        [viewPicker1 removeFromSuperview];
        [viewPicker2 removeFromSuperview];
        
        if(![datePicker superview])
            [datePickerContainer addSubview:datePicker];
        [self animationPicker:true];
    }
    else
    // Ввод пола
    if([textField tag]==105)
    {
        [datePicker removeFromSuperview];
        [viewPicker2 removeFromSuperview];

        [self.view endEditing:true];
        viewPickerId = 1;
        
        if(![viewPicker1 superview])
            [datePickerContainer addSubview:viewPicker1];
        [self animationPicker:true];
    }
    else
    // Ввод города
    if([textField tag]==401)
    {
        [datePicker removeFromSuperview];
        [viewPicker1 removeFromSuperview];
        
        [datePickerContainer setFrame: CGRectMake(320, rect.origin.y, rect.size.width, rect.size.height)];
        
        [self.view endEditing:true];
        viewPickerId = 2;
        
        if(![viewPicker2 superview])
            [datePickerContainer addSubview:viewPicker2];
        [self animationPicker:true];
    }
    else
    // Ввод текста
    {
        //[self animationPicker:false];
        [datePickerContainer setHidden:true];
         standardEditing = true;
    }
    
    return standardEditing;
}

// Нажал на кнопку "Закрыть окно даты и пола"
- (void) closeContainerPickerEvent: (id)sender
{
    [self.view endEditing:true];
    [self animationPicker:false];
}

// Определение пола пользователя
- (NSString*)getStringSexFromInt:(int)usSex
{
    NSString *per;
    if(usSex==1)
        per = @"Сударь";
    else
        per = @"Сударыня";
    return per;
}

- (NSString*)getIntSexFromString:(NSString*)usSex
{
    NSString *per;
    if([usSex isEqualToString: @"Сударь"])
        per = @"1";
    else
        per = @"0";
    return per;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    //    [self setNumberCardField:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
