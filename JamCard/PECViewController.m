//
//  PECViewController.m
//  JamCard
//
//  Created by Admin on 11/18/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//
// Контроллер отвечает только за вывод контейнеров и за навигаци между ними
// Содержит контейнеры
// JamCards
// AllCards
// MyCards

#import "PECViewController.h"
#import "PECAutorizationViewCtrl.h"
#import "PECMyCardsViewCtrl.h"
#import "PECJamCardViewCtrl.h"
#import "PECSpisokViewCtrl.h"
#import "PECModelsData.h"
#import "PECAllCardsViewCtrl.h"
#import "PECBuilderModel.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface PECViewController ()

// Status Bar Title
@property (strong, nonatomic) IBOutlet UILabel *titleStatusBar;

// Scroll Page
@property (strong, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentControl;
@property (nonatomic) BOOL usedScrollControl;

// Container
@property (strong, nonatomic) IBOutlet UIView *containerMain;
@property (strong, nonatomic) IBOutlet UIView *containerJamcard;
@property (strong, nonatomic) IBOutlet UIView *containerAllcard;
@property (strong, nonatomic) IBOutlet UIView *containerMycard;

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;

@property (strong, nonatomic) IBOutlet UIControl *containerTips;

@end

@implementation PECViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Hidden Navigation bar
   [[self navigationController] setNavigationBarHidden:YES animated:YES];
   [_titleStatusBar setText:@"JamCard"];
   
   // Scroll and segmentControl
   _usedScrollControl = NO;
   
   // 3.5 inch screen
   if ([UIScreen mainScreen].bounds.size.height<568)
   {
      NSLog(@"3.4");
      _bgImage.image = [UIImage imageNamed:@"bg_3inch"];
      [_bgImage setAlpha:0.7f];
   }
   
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   int startupTips = [defaults integerForKey:@"startupTips"];
   if(!startupTips)
      [_containerTips setHidden:false];
   
   [defaults setInteger:1 forKey:@"startupTips"];

   [defaults synchronize];
   [_containerTips addTarget:self action:@selector(bTipsEvent:) forControlEvents:UIControlEventTouchDown];

}


- (IBAction)bTipsEvent:(id)sender
{
   [UIView animateWithDuration:0.3
                         delay:0.0
                       options:UIViewAnimationCurveEaseOut
                    animations:^{
                       _containerTips.alpha = 0.0f;
                    } completion:^(BOOL completed) {
                       [_containerTips setHidden:true];
                    }];

}


-(void) updateJamCardsDate
{
   // Если обновилась информация
   if ([self uploadDataSettings:0])
   {
      [self dataSettingsUploaded:0];
      
      NSLog(@"updateJamCardsDate");
      
      for (UIViewController *childViewController in [self childViewControllers])
      {
         if ([childViewController isKindOfClass:[PECJamCardViewCtrl class]])
         {
            PECJamCardViewCtrl *installViewController = (PECJamCardViewCtrl *)childViewController;
            
            [installViewController viewDidLoad];
            break;
         }
      }
   }

}

-(void) updateAllCardsDate
{
   
   // Если обновилась информация
   if ([self uploadDataSettings:1])
   {
      NSLog(@"updateAllCardsDate");
     [self dataSettingsUploaded:1];
      
      [self updateMyCardsDate];
      
      // update view!
      for (UIViewController *childViewController in [self childViewControllers])
      {
         if ([childViewController isKindOfClass:[PECAllCardsViewCtrl class]])
         {
            PECAllCardsViewCtrl *installViewController = (PECAllCardsViewCtrl *)childViewController;
            //[installViewController loadView];
            break;
         }
      }
   }
}

-(void) updateMyCardsDate
{
   // Если обновилась информация
   if ([self uploadDataSettings:2])
   {
      [self dataSettingsUploaded:2];
      NSLog(@"updateMyCardsDate");
      
      // update view!
      for (UIViewController *childViewController in [self childViewControllers])
      {
         if ([childViewController isKindOfClass:[PECMyCardsViewCtrl class]])
         {
            PECMyCardsViewCtrl *installViewController = (PECMyCardsViewCtrl *)childViewController;
            [installViewController viewDidLoad];
            break;
         }
      }
   }
}


- (void) dataSettingsUploaded:(int)bit
{
   PECModelSettings *settings = [[PECModelSettings alloc]init];
   if([PECModelsData getModelSettings]!=nil)
      settings = [PECModelsData getModelSettings];

   int maskBit = settings.uploadData;
   
   if(bit==0) maskBit = maskBit & 0xE;
   if(bit==1)
      maskBit = maskBit & 0xD;
   if(bit==2) maskBit = maskBit & 0x3;
   
   settings.uploadData = maskBit;
   
   [PECModelsData setModelSettings:settings];
}

// Обновление данных
- (BOOL)uploadDataSettings:(int)bit
{
   PECModelSettings *settings = [[PECModelSettings alloc]init];
   if([PECModelsData getModelSettings]!=nil)
      settings = [PECModelsData getModelSettings];
   
   int maskBit = settings.uploadData;
   maskBit = ((maskBit >> bit)&1);
   
   return maskBit;
}


// Segment Control
- (IBAction)segmentCtrlClick:(UISegmentedControl *)sender{
   
   _usedScrollControl = YES;
   
   [self.view endEditing:true];
   
   // JamCard карточки
   if(sender.selectedSegmentIndex == 0)
      [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];

   // Все карточки
   if(sender.selectedSegmentIndex == 1)
   {
      UIView *parent = _containerAllcard;
      [_containerAllcard removeFromSuperview];
      _containerAllcard = nil;
      [_containerMain addSubview:parent];
      [_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
   }

   // Мои карточки
   if(sender.selectedSegmentIndex == 2)
      [_scrollContainer setContentOffset:CGPointMake(640, 0) animated:YES];

}


// Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   //if(!_usedScrollControl)
      [self darkerTheBackground:scrollView.contentOffset.x];
   
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
   int page = 0;
   
   /*   if (xOffSet != 0) {
      CGFloat pageWidth = _scrollContainer.frame.size.width;
      int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
      _headerSegmentControl.selectedSegmentIndex = page;
   }*/
   
   if (xOffSet != 0) {
      CGFloat pageWidth = _scrollContainer.frame.size.width;
      page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
      if(!self.usedScrollControl)
         _headerSegmentControl.selectedSegmentIndex = page;
   }
   
   if(xOffSet == 0)
   {
      [self updateJamCardsDate];
      [_titleStatusBar setText:@"JamCard"];
   }
   
   if(xOffSet == 320)
   {
      [self updateAllCardsDate];
      [_titleStatusBar setText:@"Все карты"];
   }
   
   if(xOffSet == 640)
   {
      [self updateMyCardsDate];
      [_titleStatusBar setText:@"Мои карты"];
   }
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{ _usedScrollControl = NO; }
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{ _usedScrollControl = NO; [self.view endEditing:YES]; }
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{ [self.view endEditing:YES];}


// ~ ШАПОЧКА
// Нажал на значек JamCard слева
- (IBAction)updateJamCard:(UIButton *)sender
{
//   UIView *parent = self.view.superview;
//   [self.view removeFromSuperview];
//   self.view = nil;
//   [parent addSubview:parent.subviews];
   
   //PECViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"viewStoryID"];
   //UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
   //[self presentViewController:navController animated:YES completion:nil];
//   [self dismissModalViewControllerAnimated:YES];
}

// Нажал на значек авторизации справа "не используется"
- (void) buttonRightClicked: (id)sender
{
   PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
   [self.navigationController pushViewController: autorizationCardController animated:YES];
}


// ~ СИСТЕМНЫЕ ОБЩИЕ
// Вызов сообщения
-(void)cellAlertMsg:(NSString*)msg{
   UIAlertView *autoAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:nil];
   
   autoAlertView.transform = CGAffineTransformMake(1.0f, 0.5f, 0.0f, 1.0f, 0.0f, 0.0f);
   [autoAlertView performSelector:@selector(dismissWithClickedButtonIndex:animated:)
                       withObject:nil
                       afterDelay:1.0f];
   [autoAlertView show];
}

// Анимация сдвиг право-лево
-(void)animationCompleted
{
   [UIView  beginAnimations: @"Showinfo"context: nil];
   [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
   [UIView setAnimationDuration:0.75];
   [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
   [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

/*
 CATransition* transition = [CATransition animation];
 transition.duration = 0.15;
 transition.type = kCATransitionFade;
 transition.subtype = kCATransitionFromTop;
 [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

 */


@end
