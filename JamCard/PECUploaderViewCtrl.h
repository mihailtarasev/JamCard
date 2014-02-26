//
//  PECUploaderViewCtrl.h
//  JamCard
//
//  Created by Admin on 12/27/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PECUploaderViewCtrl : UIViewController <CLLocationManagerDelegate>

@property(retain, nonatomic) NSTimer *animationTimer;

@end
