//
//  PECAboutPartnerViewCtrl.m
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECAboutPartnerViewCtrl.h"
#import "PECModelsData.h"
#import "PECModelPoints.h"
#import "PECBuilderModel.h"
#import "PECObjectCard.h"

@interface PECAboutPartnerViewCtrl ()


@property (retain, nonatomic) IBOutlet UILabel *titlePartners;
@property (retain, nonatomic) IBOutlet UILabel *descPartners;
@property (retain, nonatomic) IBOutlet UILabel *mailPartners;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumberPartners;
@property (retain, nonatomic) IBOutlet UILabel *sitePartners;

@end

@implementation PECAboutPartnerViewCtrl
{
    PECModelPartner *currentModelPartner;
    UIButton *butTel;
    UIButton *butSite;
    
    UIView *mainContVerifi;
    UIView *mainContVerifiSite;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Получаю данные партнера карточки
    for(PECModelPartner *modelData in [PECModelsData getModelPartners])
        if(modelData.idPartner == [self idCurrentPartner])
            currentModelPartner = modelData;
    
    
    // Подтверждение звонка по номеру телефона
    mainContVerifi = [PECObjectCard addContainerRingViewController:self txtNumPhone:@"" mode:0];
    [self.view addSubview:mainContVerifi];
    [mainContVerifi setAlpha:0.0];

    // Подтверждение перехода на сайт
    mainContVerifiSite = [PECObjectCard addContainerRingViewController:self txtNumPhone:@"" mode:1];
    [self.view addSubview:mainContVerifiSite];
    [mainContVerifiSite setAlpha:0.0];
    
    _sitePartners.text = currentModelPartner.mp_site;
    
    _titlePartners.text = currentModelPartner.namePartrner;
    _descPartners.text = currentModelPartner.descPartrner;
    [_descPartners sizeToFit];
    
    _mailPartners.text = currentModelPartner.emailPartrner;
    
    // Нахожу информацию о карточке находящейся по определенному адресу
    NSArray *arrPointsOnMap = [PECBuilderModel parserJSONPoints:[PECModelsData getModelPartners] error:nil];
    for(PECModelPoints *points in arrPointsOnMap)
    {
        if(points.addressIdPartrner==3)//currentModelDataCard.idAddressCard
        {
            _phoneNumberPartners.text = points.addressTeleph1Partner;
        }
    }
    
    butTel = (UIButton*)[self.view viewWithTag:210];
    [butTel addTarget:self action:@selector(bTelEvent:) forControlEvents:UIControlEventTouchDown];

    butSite = (UIButton*)[self.view viewWithTag:211];
    [butSite addTarget:self action:@selector(bSiteShowEvent:) forControlEvents:UIControlEventTouchDown];

}

- (IBAction)bTelEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifi showHide:true Select:0];
}

- (IBAction)bCloseEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifi showHide:false Select:0];
    [self animationHideShowUIView:mainContVerifiSite showHide:false Select:0];
}

- (IBAction)bRingEvent:(id)sender
{
    NSString *callNumber = [NSString stringWithFormat:@"tel://%@", _phoneNumberPartners.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
}

- (IBAction)bSiteShowEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifiSite showHide:true Select:0];
}

- (IBAction)bSiteEvent:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_sitePartners.text]];
    
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

// ~ СИСТЕМНЫЕ

// Кнопочка назад
- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

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


@end
