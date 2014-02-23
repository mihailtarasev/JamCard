//
//  PECAutorizationViewCtrl.h
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface PECAutorizationViewCtrl : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate>


// Hidden Keyboard
- (IBAction)HideKeyboard:(id)sender;
- (IBAction)HideKeyboardBg:(id)sender;

// Scroll
- (IBAction)secAuthCtrlClick:(UISegmentedControl *)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segAuthCtrl;

// Button Back
- (IBAction)butBack:(UIButton *)sender;

- (IBAction)butOne:(UIButton *)sender;
- (IBAction)butTwo:(UIButton *)sender;
- (IBAction)butThree:(UIButton *)sender;


@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end
