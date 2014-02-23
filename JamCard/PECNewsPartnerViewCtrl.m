//
//  PECNewsPartnerViewCtrl.m
//  JamCard
//
//  Created by Admin on 1/7/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECNewsPartnerViewCtrl.h"
#import "PECNewsTableCell.h"
#import "PECModelsData.h"
#import "PECModelNews.h"

@interface PECNewsPartnerViewCtrl ()

@end

@implementation PECNewsPartnerViewCtrl
{
    // Table
    NSArray *tableData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tableData = [PECModelsData getModelNewsPartner];
}

// ~ ОБРАБОТКА ТАБЛИЦЫ

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numSecIntable=1;
    
    return numSecIntable;
}

// Заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName =@"";
    return sectionName;//[self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

// Количество строк в секци
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRowsInSec = [tableData count];
    
    return numRowsInSec;
}

// Добавление Акции в таблицу
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PECNewsTableCell *cell = (PECNewsTableCell *)[tableView dequeueReusableCellWithIdentifier: @"NewsTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECNewsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Обработка таблицы Акции
    PECModelNews *news = [[PECModelNews alloc] init];
    news = [tableData objectAtIndex:indexPath.row];
    
    cell.titleTbCellNewsPartner.text = news.newsTitle;//@"Заголовок Новостей";
    cell.textTbCellNewsPartner.text = news.newsText;
    cell.dateTbCellNewsPartner.text = news.newsDate;
    
    return cell;
}

// Высота строки Акции в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 180;}

// ~ СИСТЕМНЫЕ

// Кнопочка назад
- (IBAction)butBack:(UIButton *)sender
{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.15;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    
    [[self navigationController] popViewControllerAnimated:NO];
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
