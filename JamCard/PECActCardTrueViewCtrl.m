//
//  PECActCardTrueViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECActCardTrueViewCtrl.h"
#import "PECModelDataCards.h"
#import "PECBuilderCards.h"

@interface PECActCardTrueViewCtrl ()



@end

@implementation PECActCardTrueViewCtrl
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

    //_titleCard.text = currentModelDataCard.descCard;
    //_imgCard.image = [PECBuilderCards createImageViewFromObj:currentModelDataCard];
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
