//
//  PECBuilderModelCard.m
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECBuilderModelCard.h"
#import "PECModelDataCards.h"

@implementation PECBuilderModelCard

static NSMutableArray* sArrObjectsCards;

// Static Data from Cards
+(NSMutableArray*)arrObjectsCards{ return [sArrObjectsCards copy];}

//------------------------------
// Get Data From Images
//------------------------------
+(UIImage*) getImagesCardsFromInternetURL:(NSString*)ImageURL
{
    NSURL *url = [NSURL URLWithString: ImageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}

//------------------------------
// Parser JSON OBJECT
//------------------------------
+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSArray *response = [parsedObject valueForKey:@"response"];
    NSMutableArray *groups = [[NSMutableArray alloc] init];

    for (NSDictionary *items in response)
    {
        
        NSDictionary *resParse = items;
        
        PECModelDataCards *model = [[PECModelDataCards alloc] init];
        
        for (NSString *key in resParse)
        {
            if ([model respondsToSelector:NSSelectorFromString(key)]) {
                [model setValue:[resParse valueForKey:key] forKey:key];
            }
        }
        [groups addObject:model];
    }
    
    sArrObjectsCards = groups;
    
/*    
    for(NSObject *obj in sArrObjectsCards){
        NSLog(@"%@", [obj valueForKey:@"idCard"]);
    }
*/
    return groups;
}

//------------------------------
// Get Data Cards from Internet
//------------------------------
+ (NSMutableArray *)getDataAtCard
{
    
    NSMutableArray * objJSON;
    
    NSString *urlAsString = @"http://paladin-engineering.ru/data/jamSon.php";
    
    //[NSString stringWithFormat:@"https://api.meetup.com/2/groups?lat=%f&lon=%f&page=%d&key=%@", coordinate.latitude, coordinate.longitude, PAGE_COUNT, API_KEY];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
//          [self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSError *nError;
            [self groupsFromJSON:data error:&nError];
        }
        
    }];
    
    return objJSON;
    
}



@end
