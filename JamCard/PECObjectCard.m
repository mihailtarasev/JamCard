//
//  PECObjectCard.m
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECObjectCard.h"
#import "PECBuilderCards.h"

@implementation PECObjectCard


/* 
 Card subview at:
 
 - Background Image
 - Plus Image
 - Up Button on Click
*/
-(UIView*)inWithParamImageCard:(UIImage*) imageCard
                  cardImagesFrame: (CGRect) cardImagesFrame
                    tagFromObject: (int) tagFromObject
                       uiViewCntr: (UIViewController*) uiViewCntr
                    activationCard:(int)activationCard
                        distanceGeo:(double)diastanceGeo
                                obj:(NSObject*)obj
{
    // Settings
    if(activationCard==2)activationCard = 0;
    UIView * containerCards = [[UIView alloc]initWithFrame:cardImagesFrame];
    
    // Image Card
    CGRect cardImagesCont = CGRectMake( 0, 0, cardImagesFrame.size.width, cardImagesFrame.size.height);
    UIImageView *imgCard = [[UIImageView alloc]initWithFrame:cardImagesCont];
    imgCard.image = [UIImage imageNamed:@"card_default.jpg"];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[PECBuilderCards createImageViewFromObj:obj keyData:@"dataImgCard" keyUrl:@"urlImgCard"]];
    imgCard.image = img.image;
    
    [containerCards addSubview:imgCard];
        
    // Navigations Panel
    CGRect cardNavPanel;
    cardNavPanel = CGRectMake( 0, cardImagesFrame.size.height-20, cardImagesFrame.size.width, 20);
    
    int offsizeGeo = 20;

    if(diastanceGeo!=0)
    {
        UIView *uiCardNavPanel = [[UIView alloc]initWithFrame:cardNavPanel];
        [uiCardNavPanel setBackgroundColor:[UIColor whiteColor]];
        [uiCardNavPanel setAlpha:0.8f];
        [uiCardNavPanel setTag: 3];
        [containerCards addSubview:uiCardNavPanel];
    
        // Geo Image
        CGRect cardDistanceGeo = CGRectMake( cardNavPanel.size.width-53, cardNavPanel.size.height-16, 9, 11);
        UIImageView *imgGeo = [[UIImageView alloc]initWithFrame:cardDistanceGeo];
        imgGeo.image = [UIImage imageNamed:@"geo"];
        [uiCardNavPanel addSubview:imgGeo];
        
        // TextView Distance
        CGRect cardDistance = CGRectMake( cardNavPanel.size.width-40, cardNavPanel.size.height-15, 45, 10);
        UILabel *lbCardDistance = [[UILabel alloc]initWithFrame:cardDistance];
        [lbCardDistance setFont:[UIFont fontWithName:@"Helvetica-Light" size:9]];
        [lbCardDistance setText:[NSString stringWithFormat:@"%.1f км",diastanceGeo]];
        [lbCardDistance setTag: 4];
        [uiCardNavPanel addSubview:lbCardDistance];
        
        offsizeGeo = 17;
    }
    
    // Image Plus
    CGRect cardImagesPlus = CGRectMake( 7, cardImagesFrame.size.height-offsizeGeo, 15, 15);
    
    UIImageView *imgCardPlus = [[UIImageView alloc]initWithFrame:cardImagesPlus];
    imgCardPlus.image = [UIImage imageNamed:@"plus_card"];
    [imgCardPlus setTag: 2];

    [containerCards addSubview:imgCardPlus];
    
    if(activationCard)
    {
        [imgCardPlus setHidden:true];
    }else{
        [imgCardPlus setHidden:false];
    }

    
    // Button Card Up Image
    UIButton *button = [[UIButton alloc] initWithFrame: cardImagesCont];
    [button setTitle: @"" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button setTag: tagFromObject];
    
    [button setExclusiveTouch:YES];
    
    [button addTarget: uiViewCntr
               action: @selector(buttonCardClicked:)
     forControlEvents: UIControlEventTouchDown];
    
    [containerCards addSubview:button];
    
    //Adds a shadow to sampleView
    CALayer *layer = containerCards.layer;
    layer.cornerRadius = 5;//(cardImagesFrame.size.width/100.0f)*3;
    layer.masksToBounds = YES;

    return containerCards;
}


+(UIView*) addContainerRingViewController: (UIViewController *) uiViewCntr txtNumPhone:(NSString *)txtNumPhone mode:(int)mode
{
    // Подтверждение звонка по номеру телефона
    UIView *mainContVerifi = [[UIView alloc]initWithFrame:CGRectMake(0, 180, 320, 150)];
    [mainContVerifi setBackgroundColor:[UIColor whiteColor]];
    [mainContVerifi setHidden:false];
    
    // Надпись
    UILabel *txtPhone = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 320, 20)];
    [txtPhone setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    txtPhone.textAlignment = NSTextAlignmentCenter;

    if(mode==0)
        txtPhone.text = @"Набрать номер?";
    if(mode==1)
        txtPhone.text = @"Перейти на сайт?";
    
    [mainContVerifi addSubview: txtPhone];
    
    // Кнопка закрыть

    UIImageView *imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(290, 10, 15, 15)];
    imgClose.image = [UIImage imageNamed:@"close.png"];
    [mainContVerifi addSubview: imgClose];
    
    UIButton *butClose = [[UIButton alloc]initWithFrame:CGRectMake(270, 0, 50, 50)];
    //[butClose setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [butClose setTitle: @"" forState: UIControlStateNormal];
    [butClose addTarget: uiViewCntr
                 action: @selector(bCloseEvent:)
       forControlEvents: UIControlEventTouchDown];
    [mainContVerifi addSubview: butClose];
    
    // Кнопка позвонить
    UIButton *butRing = [[UIButton alloc]initWithFrame:CGRectMake(55, 100, 209, 43)];
    [butRing setBackgroundImage:[UIImage imageNamed:@"green_button_big.png"] forState:UIControlStateNormal];
    
    if(mode==0)
        [butRing setTitle: @"Позвонить" forState: UIControlStateNormal];

    if(mode==1)
        [butRing setTitle: @"Перейти" forState: UIControlStateNormal];
    
    
    butRing.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];

    if(mode==0)
        [butRing addTarget: uiViewCntr
                    action: @selector(bRingEvent:)
          forControlEvents: UIControlEventTouchDown];
    
    if(mode==1)
        [butRing addTarget: uiViewCntr
                    action: @selector(bSiteEvent:)
          forControlEvents: UIControlEventTouchDown];

    
    
    [mainContVerifi addSubview: butRing];
    
    return mainContVerifi;
}


+(void) activateDeActivateCardView: (UIView*) viewCard activation: (int) activation
{

    CGRect cardNavPanel; CGRect cardDistance;
    
    for(UIView *view in [viewCard subviews])
    {
        if(!activation)
        {
            // de activation
            [[view viewWithTag:2] setHidden:false];
            cardNavPanel = CGRectMake( 0, 0, viewCard.frame.size.width, viewCard.frame.size.height);
            cardDistance = CGRectMake( viewCard.frame.size.width-40, viewCard.frame.size.height-20, 30, 10);
        }
        else{
            // activation
            [[view viewWithTag:2] setHidden:true];
            cardNavPanel = CGRectMake( 0, viewCard.frame.size.height-30, viewCard.frame.size.width, 30);
            cardDistance = CGRectMake( viewCard.frame.size.width-40, 10, 30, 10);
        }
        
       [[view viewWithTag:3] setFrame:cardNavPanel];
       [[view viewWithTag:4] setFrame:cardDistance];
        
    }

}


@end
