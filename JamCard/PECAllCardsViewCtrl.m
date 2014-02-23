//
//  PECAllCardsViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECAllCardsViewCtrl.h"
#import "PECBuilderCards.h"
#import "PECModelDataCards.h"
#import "PECViewController.h"
#import "PECAutorizationViewCtrl.h"
#import "PECMyCardsViewCtrl.h"
#import "PECSpisokViewCtrl.h"
#import "PECMapViewCtrl.h"
//#import "PEC"

@interface PECAllCardsViewCtrl ()

// Page All Cards
@property (strong, nonatomic) IBOutlet UISegmentedControl *secondSegmentCtrl;

@property (retain, nonatomic) IBOutlet UIView *spskContainerView;
@property (retain, nonatomic) IBOutlet UIView *mapContainerView;
@property (retain, nonatomic) IBOutlet UIView *catContainerView;

@end

@implementation PECAllCardsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *spisokContainer = (UIView*)[self.view viewWithTag:300];
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        spisokContainer.frame = CGRectOffset( spisokContainer.frame, 0.0f, -88.0f);
    }
}

- (IBAction)secSegmentCtrlClick:(UISegmentedControl *)sender
{
    if(_secondSegmentCtrl.selectedSegmentIndex == 0)
    {
        [self animationHideShowUIView:_mapContainerView showHide:0 Select:100];
        [self animationHideShowUIView:_catContainerView showHide:0 Select:100];
        [_spskContainerView setHidden:false];
        [self animationHideShowUIView:_spskContainerView showHide:1 Select:101];
    }
    
    if(_secondSegmentCtrl.selectedSegmentIndex == 1)
    {
        [self animationHideShowUIView:_spskContainerView showHide:0 Select:100];
        [self animationHideShowUIView:_mapContainerView showHide:0 Select:100];
        [_catContainerView setHidden:false];
        [self animationHideShowUIView:_catContainerView showHide:1 Select:102];
    }
    
    if(_secondSegmentCtrl.selectedSegmentIndex == 2)
    {
        [self animationHideShowUIView:_catContainerView showHide:0 Select:100];
        [self animationHideShowUIView:_spskContainerView showHide:0 Select:100];
        [_mapContainerView setHidden:false];
        [self animationHideShowUIView:_mapContainerView showHide:1 Select:103];
    }
}

// Анимация с эффектом Hide и Show
-(void)animationHideShowUIView: (UIView*) curUIView showHide: (BOOL) showHide Select:(int)SelectPage
{
     float alpha;
     if(showHide){ alpha = 1.0; }else{ alpha = 0.0; }
    
     [UIView animateWithDuration:0.3
                           delay:0.0
                         options:UIViewAnimationCurveEaseOut
                      animations:^{
                          curUIView.alpha = showHide;
                      } completion:^(BOOL completed) {
                      }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
