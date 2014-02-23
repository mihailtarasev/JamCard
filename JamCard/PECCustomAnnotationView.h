//
//  PECCustomAnnotationView.h
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PECCustomAnnotationView : MKAnnotationView


@property (strong, nonatomic) UIImageView *calloutView;
@property (strong, nonatomic) UIView *conteinerView;
@property (strong, nonatomic) MKMapView *map;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

@end
