//
//  PECDetailCardViewCtrl.m
//  JamCard
//
//  Created by Admin on 11/26/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECDetailCardViewCtrl.h"
#import "PECViewController.h"
#import "PECModelDataCards.h"


@interface PECDetailCardViewCtrl ()

@end

@implementation PECDetailCardViewCtrl{
    NSMutableArray *objJSON;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    objJSON = [PECViewController getObjJSON];
    
    for(PECModelDataCards *modelData in objJSON)
    {
        
        if(modelData.progrId == [self selectedCard]){
            
            // IMAGE
            UIImage *image = [UIImage imageWithData:modelData.dataImgCard];
            UIImageView* imgCard = (UIImageView*)[self.view viewWithTag:102];
            imgCard.image = image;
            imgCard.layer.cornerRadius = (187/100.0f)*5;
            imgCard.layer.masksToBounds = YES;
            
            // NumberCard
            UILabel* NumberCard = (UILabel*)[self.view viewWithTag:100];
            NumberCard.text = modelData.numberCard;

            // DESCRIPTION
            UILabel* descCard = (UILabel*)[self.view viewWithTag:101];
            descCard.text = modelData.descCard;

            NSLog(@"GOOD! %i", (int)[self selectedCard]);
        }
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
