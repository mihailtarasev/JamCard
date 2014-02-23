//
//  PECMyCardsViewCtrl.m
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECMyCardsViewCtrl.h"
#import "PECBuilderCards.h"
#import "PECModelDataCards.h"
#import "PECViewController.h"
#import "PECAutorizationViewCtrl.h"
#import "PECAllCardsViewCtrl.h"
#import "PECModelsData.h"
#import "PECDetailCardViewCtrl.h"
#import "PECModelsData.h"
#import "PECMyCardsViewCtrl.h"

@interface PECMyCardsViewCtrl ()

@property (nonatomic) BOOL usedPageControl;

// Page My Cards
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollViewMy;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControlMy;
@property (strong, nonatomic) IBOutlet UIView *contentViewMy;

@property (strong, nonatomic) IBOutlet UILabel *labelNotCard;

@end

@implementation PECMyCardsViewCtrl{

    UIScrollView* headerScrollView;
    UIPageControl* headerPageControl;
    UIView* contentView;
    bool existCard;
}

// Обновление данных
- (BOOL)uploadDataSettings
{
    PECModelSettings *settings = [[PECModelSettings alloc]init];
    if([PECModelsData getModelSettings]!=nil)
        settings = [PECModelsData getModelSettings];
    
    int maskBit = settings.uploadData;
    maskBit = maskBit & 0x3;
    settings.uploadData = maskBit;
    
    [PECModelsData setModelSettings:settings];
    
    if(maskBit!=0)
        maskBit = ((maskBit >> 0)&1);
    
    
    
    
    return settings.uploadData!=0;
}

- (void) viewWillAppear: (BOOL)animated
{
    
    
    
    // Если обновилась информация
    if ([self uploadDataSettings])
    {
        
        
        NSLog(@"upload viewWillAppear!");
        
        [self viewDidLoad];
    }
    
    [super viewWillAppear:NO];
}

/*
- (void) loadView
{
    [super loadView];

    if ([self uploadDataSettings])
    {
        
        NSLog(@"upload loadView!");
        [self viewDidLoad];
    }
}*/

- (void)viewDidLoad
{
    NSLog(@"PECMyCardsViewCtrl!");
    
    // update
    for(UIView *view in [_contentViewMy subviews])
        [view removeFromSuperview];
    
    existCard = false;
    
    PECBuilderCards *   builderCrds = [[PECBuilderCards alloc] init];
    existCard = [builderCrds addCardsToScrollView:[PECModelsData getModelCard] contentView:_contentViewMy headerScrollView:_headerScrollViewMy headerPageControl:_headerPageControlMy uiViewCntr:self dinamicContent:true];
    
    [_labelNotCard setHidden:existCard];
    
    [super viewDidLoad];
}

// autorization and details cards
- (void)buttonCardClicked: (id)sender
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.15;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    
    PECDetailCardViewCtrl *detailCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailCardController"];
    detailCardController.selectedCard = [sender tag];
    [self.navigationController pushViewController: detailCardController animated:NO];
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
