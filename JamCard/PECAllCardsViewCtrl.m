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

@interface PECAllCardsViewCtrl ()<UISearchBarDelegate>
{
    UIView *searchContainer;
    
    UIButton *searchButton;
    bool searchTrig;
    UISearchBar *serachBar;
    UIImageView *searchButtonImg;

}

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
    
    // Контейнер для хранения поиска
    searchContainer = (UIView*)[self.view viewWithTag:222];

    searchButton = (UIButton*)[self.view viewWithTag:223];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    serachBar = (UISearchBar*)[self.view viewWithTag:224];
    serachBar.delegate =self;
    
    searchButtonImg = (UIImageView*)[self.view viewWithTag:225];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        spisokContainer.frame = CGRectOffset( spisokContainer.frame, 0.0f, -88.0f);
        searchContainer.frame = CGRectOffset( spisokContainer.frame, 0.0f, -30.0f);
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // update view!
    for (UIViewController *childViewController in [self childViewControllers])
    {
        if ([childViewController isKindOfClass:[PECSpisokViewCtrl class]])
        {
            PECSpisokViewCtrl *installViewController = (PECSpisokViewCtrl *)childViewController;
            installViewController.searchText = [searchBar text];
            [installViewController viewWillAppear:NO];
            break;
        }
    }
}

- (void) searchButtonClick: (id)sender
{
    if(!searchTrig){
        [self animatedChangePositionMenuY:-220.0f alpha:1.0f];
    }
    else{
        [self animatedChangePositionMenuY:220.0f alpha:0.0f];
        [self.view endEditing:true];
    }
}

// ANIMATION MENU
- (void)animatedChangePositionMenuY :(float) posY alpha:(float)alpha
{
    CGRect endFrame = searchContainer.frame;
    CGRect endFrameTemp = CGRectOffset(endFrame, 0, posY);
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationTransitionNone
                     animations:^{
                         searchContainer.frame = endFrameTemp;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if(!searchTrig){
                             [serachBar becomeFirstResponder];
                             [searchButtonImg setImage:[UIImage imageNamed:@"find_close.png"]];
                         }
                         else{
                             
                             [searchButtonImg setImage:[UIImage imageNamed:@"find.png"]];
                         }
                         
                         searchTrig = !searchTrig;
                         ;}];
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

- (void) viewWillAppear: (BOOL)animated
{
//    if(!searchTrig)
//        [self animatedChangePositionMenuY:220.0f alpha:1.0f];

    [super viewWillAppear:NO];
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
