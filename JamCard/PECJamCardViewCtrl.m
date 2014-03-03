//
//  PECJamCardViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/27/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//
//  Контейнер карточек
//  Первая страничка после загрузки данных с сервера

#import "PECJamCardViewCtrl.h"
#import "PECBuilderCards.h"
#import "PECModelDataCards.h"
#import "PECBuilderModel.h"
#import "PECDetailCardViewCtrl.h"
#import "PECModelDataUser.h"
#import "PECAutorizationViewCtrl.h"
#import "PECTableActionCell.h"
#import "PECDetailActionViewCtrl.h"
#import "PECModelsData.h"
#import "PECModelDataAction.h"
#import "PECModelSettings.h"

@interface PECJamCardViewCtrl ()

@property (nonatomic) BOOL usedPageControl;

// Main Page Jam Cards
@property (strong, nonatomic) IBOutlet UIView *selectContainerView;
@property (strong, nonatomic) IBOutlet UIView *jamCardContainer;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *mainContainerCards;


@property (strong, nonatomic) IBOutlet UITableView *tableViewControl;
@property (strong, nonatomic) IBOutlet UIView *topViewCardsControl;


@end

@implementation PECJamCardViewCtrl
{
    // Main
    PECBuilderCards *builderCrds;
    bool autorizationTRUE;
    
    // Table
    NSArray *tableData;
}

// Обновление данных
- (BOOL)uploadDataSettings
{
    PECModelSettings *settings = [[PECModelSettings alloc]init];
    if([PECModelsData getModelSettings]!=nil)
        settings = [PECModelsData getModelSettings];
    
    int maskBit = settings.uploadData;
    maskBit = maskBit & 0xE;
    settings.uploadData = maskBit;
    
    [PECModelsData setModelSettings:settings];
    
    if(maskBit!=0)
        maskBit = ((maskBit >> 0)&1);
    
    return settings.uploadData!=0;
}

- (void) viewWillAppear: (BOOL)animated
{
    // Если обновилась информация
    if ([self uploadDataSettings])
        [self viewDidLoad];
    
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    
    // Scroll Cards
    [self PAGE_MAIN_CONTROL];
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        _tableViewControl.frame = (CGRect){_tableViewControl.frame.origin, CGSizeMake(320, 380)};
    }
    
    // Table Action
    [self dataInitDataTableActions];
    
    [_tableViewControl reloadData];
    
    [super viewDidLoad];
}


// Главная страница
- (void)PAGE_MAIN_CONTROL
{
    //dataPageMainLoaded = true;
    //dataPageAllCardsLoaded = false;
    
    builderCrds = [[PECBuilderCards alloc] init];
    
    // Loading data from internet
    // if(![PECModelDataCards getObjJSON].count){
    // #pragma mark - Page View Controller Loading Data Dards in objJSON
    //  [self getDataAtCardURL:[PECModelDataCards URL_CARD_GET_ALL] PARAMS:@"#"];
    //}else{

    // update
    for(UIView *view in [_contentView subviews])
        [view removeFromSuperview];
    
        [builderCrds addCardsToScrollView:[PECModelsData getModelCard] contentView:_contentView headerScrollView:_headerScrollView headerPageControl:_headerPageControl uiViewCntr:self dinamicContent:false];
    
        autorizationTRUE = ([PECModelsData getModelUser].count);
    //}
}

// autorization and details cards
- (void)buttonCardClicked: (id)sender
{
    if(autorizationTRUE)
    {
        PECDetailCardViewCtrl *detailCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailCardController"];
        detailCardController.selectedCard = [sender tag];
        [self.navigationController pushViewController: detailCardController animated:YES];
    }else
    {
        PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
        [self.navigationController pushViewController: autorizationCardController animated:YES];
    }
}

// ~ СКРОЛЛ

- (IBAction)pageChanged:(UIPageControl *)sender
{
    CGFloat headerViewWidth = _headerScrollView.frame.size.width;
    CGRect frame = _headerScrollView.frame;
    frame.origin = CGPointMake(headerViewWidth*sender.currentPage, 0);
    self.usedPageControl = YES;
    [_headerScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self darkerTheBackground:scrollView.contentOffset.x];
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
        if (!self.usedPageControl) {
            int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
            _headerPageControl.currentPage = page;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView)
        self.usedPageControl = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView)
        self.usedPageControl = NO;
}

// ~ ОБРАБОТКА ТАБЛИЦЫ

- (void)dataInitDataTableActions{ tableData = [PECModelsData getModelAction]; }
// Количество секции в таблице
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{ return 1;}
// Заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return @"";}
// Количество строк в секци
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [tableData count]; }
// Высота строки Акции в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)return 235.0f;
    return 74.0f;
}

// Добавление Акции в таблицу
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PECTableActionCell *cell = (PECTableActionCell *)[tableView dequeueReusableCellWithIdentifier: @"ActionTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECActionTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.row==0)
    {
        UITableViewCell *cellMain = [[UITableViewCell alloc]init];
        [cellMain setBackgroundColor:[UIColor clearColor]];
        [cellMain addSubview:_mainContainerCards];
        
        return cellMain;
    }
    
    // Обработка таблицы Акции
    PECModelDataAction *actions = [[PECModelDataAction alloc] init];
    actions = [tableData objectAtIndex:indexPath.row];
    cell.nameLabelTableCell.text = actions.textAction;
    
    if(actions.distAction!=0)
    {
        cell.distanceLabelTableCell.text = [NSString stringWithFormat:@"%i м",actions.distAction];
        [cell.distanceLabelTableCell setHidden:false];
        [cell.imagDistTableCell setHidden:false];
        [cell.imagNoDistTableCell setHidden:true];
    }else
    {
        [cell.distanceLabelTableCell setHidden:true];
        [cell.imagDistTableCell setHidden:true];
        [cell.imagNoDistTableCell setHidden:false];
    }
  
    
    //if(indexPath.row < 4)
    //    cell.imageViewTableCell.image = [PECBuilderCards createImageViewFromObj:actions keyData:@"logoDataAction" keyUrl:@"logoAction"];
    //else{
        
        cell.imageViewTableCell.image = [UIImage imageNamed:@"card_default.jpg"];
        
        // Asynh loading images from url
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            PECModelDataAction *threadAction = actions;
            UIImageView *img = [[UIImageView alloc]initWithImage:[PECBuilderCards createImageViewFromObj:threadAction keyData:@"logoDataAction" keyUrl:@"logoAction"]];
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               cell.imageViewTableCell.image = img.image;
            });
        });
        
    //}
    
    //Adds a shadow to sampleView
    CALayer *layer = cell.maskTableCell.layer;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    
    
    [cell.buttonClickTableCell setTag:actions.idAction];
    [cell.buttonClickTableCell addTarget:self action:@selector(buttonClickTableCell:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

// ?Обработка нажатия на Акции в таблице
- (void) buttonClickTableCell: (id)sender
{
    if(autorizationTRUE)
    {
        PECDetailActionViewCtrl *detailActionController = [self.storyboard instantiateViewControllerWithIdentifier:@"showActionDetail"];
        detailActionController.selectedAction = [sender tag];
        [self.navigationController pushViewController: detailActionController animated:YES];
    }else
    {
        PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
        [self.navigationController pushViewController: autorizationCardController animated:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
