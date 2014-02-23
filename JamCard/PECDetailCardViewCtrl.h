//
//  PECDetailCardViewCtrl.h
//  JamCard
//
//  Created by Admin on 11/26/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECModelDataCards.h"

@interface PECDetailCardViewCtrl : UIViewController

// Текущая модель данных
@property int selectedCard;

// Кнопка активировать карточку/деАктивировать карточку
- (IBAction)buttonActivateClicked:(id)sender;

// Кнопка Назад
- (IBAction)butBack:(UIButton *)sender;

// Кнопка Новости
- (IBAction)butNews:(UIButton *)sender;

// Кнопка Адрес
- (IBAction)butAddressEvent:(UIButton *)sender;

@end
