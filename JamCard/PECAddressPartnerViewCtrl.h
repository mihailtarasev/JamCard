//
//  PECAddressPartnerViewCtrl.h
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECAddressPartnerViewCtrl : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property int idCurrentPartner;
@property int selectedType; // 0 - Cards 1 - Actions


// Кнопка Назад
- (IBAction)butBack:(UIButton *)sender;

@end
