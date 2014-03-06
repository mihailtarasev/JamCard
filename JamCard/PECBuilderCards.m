//
//  PECBuilderCards.m
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECBuilderCards.h"
#import "PECObjectCard.h"
#import "PECModelsData.h"

static int countCardsAtWidth;


@implementation PECBuilderCards
{
    int marginCards;
    
    float widthDiscontCard;
    float heightDiscontCard;
    int offsetXContView;
    int cardInContainerX;
    int cardInContainerY;
    int tagFromContent;
    
    UIView *containerCards;

}

+(void)setObjectData: (int)objDataloc{ countCardsAtWidth = objDataloc;}

// ----------------------------------------
// SHOW CARDS.
// ----------------------------------------
- (BOOL)addCardsToScrollView : (NSMutableArray*) objJSON
                  contentView:(UIView*) contentView
             headerScrollView:(UIScrollView*) headerScrollView
            headerPageControl:(UIPageControl*) headerPageControl
                   uiViewCntr: (UIViewController*) uiViewCntr
               dinamicContent: (BOOL) dinamicContent
{
    
    // SETTINGS VIEWCARD IN CONTAINER
    countCardsAtWidth = [PECModelsData getModelSettings].countCardInView; // количество карт по ширине
    
    // Минимум 2 карта
    if (!countCardsAtWidth) countCardsAtWidth=2;
    
    marginCards = 6.5f;   // отступы между картами
    //-------------------------------
    
    if(dinamicContent) countCardsAtWidth = 2;
    
    widthDiscontCard = (320.0f-(marginCards * (countCardsAtWidth+1.0f)))/countCardsAtWidth;
    heightDiscontCard = widthDiscontCard * 0.62f;
    
    // Количество карт в контейнере
    int countCardsInContainer = ((contentView.frame.size.height-(marginCards * (countCardsAtWidth+1.0f))) / heightDiscontCard) * countCardsAtWidth;
    
    // Минимум одна карта
    if (!countCardsInContainer) countCardsInContainer=1;
    
    // Всего карт от сервера
    int countCards = objJSON.count;
    // Количество экранов слайдеров
    float countSliders = ceilf((float)countCards/ (float)countCardsInContainer);
    
    // Ширина главного контейнера
    CGFloat widthSliderContainer =  countSliders * 320.0f;
    CGRect oldFrame = contentView.frame;
    CGFloat heightSliderContainer =  oldFrame.size.height;
    
    // Условие если не используется слайдер
    if(dinamicContent){
        countSliders = 1;
        widthSliderContainer = 320.0f;
        heightSliderContainer = ((float)countCards / (float)countCardsAtWidth) * ((float)heightDiscontCard + (marginCards*2));
        headerScrollView.pagingEnabled = false;
    }
    
    // Размер главного контейнера
    CGRect newFrame = CGRectMake( oldFrame.origin.x, oldFrame.origin.y, widthSliderContainer, heightSliderContainer);
    contentView.frame = newFrame;
    
    headerScrollView.contentSize = contentView.frame.size;
    headerPageControl.numberOfPages = (int)countSliders;
    
    offsetXContView = -320; tagFromContent=0;
    cardInContainerY = marginCards;
    bool existCardInContainer = false;
    
    for(NSObject *obj in objJSON)
    {
        bool ackCard = ((PECModelDataCards*)obj).statusCard==1;
        if(!ackCard && dinamicContent) continue;
        existCardInContainer = true;

        // Create and calc position new Container
        if(tagFromContent%(countCardsInContainer) == 0)
        {
            containerCards = [[UIView alloc]initWithFrame:CGRectMake( offsetXContView+=320, (heightDiscontCard*-1)-15, 320, /*heightSliderContainer*countCardsAtWidth*/ 1000.0f )];
            cardInContainerX = marginCards; cardInContainerY = marginCards;
        }
    
        // Calc Position Cards in Container
        if(tagFromContent%(countCardsAtWidth) == 0 )
        {
            cardInContainerX = marginCards;
            cardInContainerY+=(heightDiscontCard + marginCards);
        }else
            cardInContainerX += (widthDiscontCard+marginCards);
    
        // inc Object in Container
        tagFromContent++;
        CGRect cardImagesFrame = CGRectMake( cardInContainerX, cardInContainerY, widthDiscontCard, heightDiscontCard );
        PECObjectCard *objCard = [[PECObjectCard alloc]init];

        // Create Object Card
        UIView *ObjCardView = [objCard inWithParamImageCard:nil cardImagesFrame:cardImagesFrame tagFromObject:((PECModelDataCards*)obj).idCard uiViewCntr:uiViewCntr activationCard:ackCard distanceGeo:((PECModelDataCards*)obj).distanceCard obj:obj];

        if (dinamicContent)
        {
            if(ackCard)
                [containerCards addSubview:ObjCardView];
        }else
            [containerCards addSubview:ObjCardView];
        
        // Add container cards to Scroll
        [contentView addSubview:containerCards];
    }
    return existCardInContainer;
    
}

+(UIImage *)createImageViewFromObj: (NSObject*) obj keyData:(NSString*)keyData keyUrl:(NSString*)keyUrl
{
    // Create IMAGE
    NSData *data;
    NSData *dataImgCard = [obj valueForKey:keyData];
    if(dataImgCard != NULL){
        // Data Exist CREATE CARDS
        data = dataImgCard;
    }else{
        // Loading Images From URL. CREATE CARDS
        NSURL *url = [NSURL URLWithString: [obj valueForKey:keyUrl]];
        data = [NSData dataWithContentsOfURL:url];
        [obj setValue:data forKey:keyData];
    }
    UIImage *imgCard;

    //NSLog(@"keyUrl %@",[obj valueForKey:keyUrl]);
    if([UIImage imageWithData:data]==NULL)
        imgCard = [UIImage imageNamed:@"card_default.jpg"];
    else
        imgCard = [UIImage imageWithData:data];
    
    return imgCard;
}

@end
