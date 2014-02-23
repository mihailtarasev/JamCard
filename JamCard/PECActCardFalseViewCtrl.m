//
//  PECActCardFalseViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECActCardFalseViewCtrl.h"
#import "PECDetailCardViewCtrl.h"
#import "PECModelDataCards.h"
#import "PECBuilderCards.h"

@interface PECActCardFalseViewCtrl ()

// Заголовок карточки
@property (strong, nonatomic) IBOutlet UILabel *titleCard;

// Картинка карточки
@property (strong, nonatomic) IBOutlet UIImageView *imgCard;

// Телефон фирмы
@property (strong, nonatomic) IBOutlet UILabel *numTelephoneCompany;

// Время работы Фирмы
@property (strong, nonatomic) IBOutlet UILabel *timeWorkCompany;

// Описание карточки
@property (strong, nonatomic) IBOutlet UILabel *descCard;

// Адрес Фирмы
@property (strong, nonatomic) IBOutlet UILabel *addressCompany;

// Данные Модели карточки

@end

@implementation PECActCardFalseViewCtrl
{
    PECModelDataCards * currentModelDataCard;
}

// Инициализация объекта карточки
- (void)initWithParams:(PECModelDataCards*)object
{
    currentModelDataCard = object;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _titleCard.text = currentModelDataCard.descCard;
    _imgCard.image = [PECBuilderCards createImageViewFromObj:currentModelDataCard];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
