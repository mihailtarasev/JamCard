//
//  PECNewsPartnerViewCtrl.h
//  JamCard
//
//  Created by Admin on 1/7/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECNewsPartnerViewCtrl : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property int idCurrentPartner;

// Кнопка Назад
- (IBAction)butBack:(UIButton *)sender;

@end
