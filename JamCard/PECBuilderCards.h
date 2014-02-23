//
//  PECBuilderCards.h
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECBuilderCards : NSObject

- (BOOL)addCardsToScrollView : (NSMutableArray*) objJSON
                  contentView:(UIView*) contentView
             headerScrollView:(UIScrollView*) headerScrollView
            headerPageControl:(UIPageControl*) headerPageControl
                   uiViewCntr: (UIViewController*) uiViewCntr
               dinamicContent: (BOOL) dinamicContent;


+(UIImage *)createImageViewFromObj: (NSObject*) obj keyData:(NSString*)keyData keyUrl:(NSString*)keyUrl;

+(void)setObjectData: (int)objDataloc;


@end
