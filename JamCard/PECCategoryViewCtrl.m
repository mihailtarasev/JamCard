//
//  PECCategoryViewCtrl.m
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECCategoryViewCtrl.h"
#import "PECCategoryTableCell.h"
#import "PECCategoryDetailViewCtrl.h"
#import "PECModelsData.h"
#import "PECModelCategoty.h"
#import "PECAutorizationViewCtrl.h"

@interface PECCategoryViewCtrl ()
{
    NSArray *tableData;
    bool autorizationTRUE;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewCategorySpisok;

@end

@implementation PECCategoryViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tableData = [PECModelsData getModelCategory];
    
    autorizationTRUE = ([PECModelsData getModelUser].count);
    
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        _tableViewCategorySpisok.frame = (CGRect){_tableViewCategorySpisok.frame.origin, CGSizeMake(320, 330)};
    }
    
}

// ~ ОБРАБОТКА ТАБЛИЦЫ

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{ return 1; }
// Заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{ return @""; }
// Количество строк в секци
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return [tableData count]; }
// Высота строки в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 50;}
// Добавление в таблицу
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PECCategoryTableCell *cell = (PECCategoryTableCell *)[tableView dequeueReusableCellWithIdentifier: @"CategoryTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECCategoryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Обработка таблицы
    PECModelCategoty *category = [[PECModelCategoty alloc] init];
    category = [tableData objectAtIndex:indexPath.row];
    
    cell.typeCellCategoryPartner.text = category.nameCategory;
    [cell.buttonClickCategoryTableCell setTag:category.idCategory];
    [cell.buttonClickCategoryTableCell addTarget:self action:@selector(buttonClickCategoryTableCell:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void) buttonClickCategoryTableCell: (id)sender
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.15;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    
    autorizationTRUE = true;
    
    if(autorizationTRUE)
    {
        PECCategoryDetailViewCtrl *detailCategoryController = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryDetailStoryID"];
        detailCategoryController.selectedCategory = [sender tag];
        [self.navigationController pushViewController: detailCategoryController animated:NO];
    }else
    {
        PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
        [self.navigationController pushViewController: autorizationCardController animated:NO];
    }
}

// ~ СИСТЕМНЫЕ

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
