//
//  PECBuilderModelCard.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECBuilderModelCard : NSObject

+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSMutableArray *)getDataAtCard;
+ (NSMutableArray*)arrObjectsCards;

@end
