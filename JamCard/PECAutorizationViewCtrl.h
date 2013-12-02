//
//  PECAutorizationViewCtrl.h
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECAutorizationViewCtrl : UIViewController


@property (retain, nonatomic) IBOutlet UITextField *uiTextUserName;
@property (retain, nonatomic) IBOutlet UITextField *uiTextUserFamily;
@property (retain, nonatomic) IBOutlet UITextField *uiTextUserNumberTel;

- (IBAction)butClickOkAutorization:(id)sender;


@end
