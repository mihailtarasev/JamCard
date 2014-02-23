//
//  PECAnnotation.m
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECAnnotation.h"

@implementation PECAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}


@end
