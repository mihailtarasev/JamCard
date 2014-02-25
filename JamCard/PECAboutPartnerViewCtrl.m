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

@interface PECAboutPartnerViewCtrl ()


@property (retain, nonatomic) IBOutlet UILabel *titlePartners;
@property (retain, nonatomic) IBOutlet UILabel *descPartners;
@property (retain, nonatomic) IBOutlet UILabel *mailPartners;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumberPartners;

@end

@implementation PECAboutPartnerViewCtrl
{
    PECModelPartner *currentModelPartner;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Получаю данные партнера карточки
    for(PECModelPartner *modelData in [PECModelsData getModelPartners])
        if(modelData.idPartner == [self idCurrentPartner])
            currentModelPartner = modelData;
    
    
    _titlePartners.text = currentModelPartner.namePartrner;
    _descPartners.text = currentModelPartner.descPartrner;
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
