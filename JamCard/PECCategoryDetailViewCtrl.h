//
//  PECCategoryDetailViewCtrl.h
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECCategoryDetailViewCtrl : UIViewController

// Текущая модель данных
@property int selectedCategory;

// Кнопка Назад
- (IBAction)butBack:(UIButton *)sender;

@end
