//
//  PECAddressPartnerViewCtrl.m
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECAddressPartnerViewCtrl.h"
#import "PECAddressTableCell.h"
#import "PECModelPoints.h"
#import "PECModelsData.h"
#import "PECBuilderModel.h"
#import "PECModelDataAction.h"

@interface PECAddressPartnerViewCtrl ()

@end

@implementation PECAddressPartnerViewCtrl
{
    // Table
    NSArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if(_selectedType==0)
    {
        for(PECModelPartner *partner in [PECModelsData getModelPartners])
        {
            if(partner.idPartner==_idCurrentPartner)
            {
                NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:partner, nil];
                tableData = [PECBuilderModel parserJSONPoints:arr error:nil];
            }
        }
    
    }else{
    
        for(PECModelDataAction *actions in [PECModelsData getModelAction])
        {
            if(actions.idAction==_idCurrentPartner)
            {
                NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:actions, nil];
                tableData = [PECBuilderModel parserJSONPoints:arr error:nil];
            }
        }

    }
}

// ~ ОБРАБОТКА ТАБЛИЦЫ

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

// Количество строк в секци
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRowsInSec = [tableData count];
    
    return numRowsInSec;
}

// Добавление в таблицу
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PECAddressTableCell *cell = (PECAddressTableCell *)[tableView dequeueReusableCellWithIdentifier: @"AddressTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECAddressTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Обработка таблицы
    PECModelPoints *addressesPartner = [[PECModelPoints alloc] init];
    addressesPartner = [tableData objectAtIndex:indexPath.row];
    
    
    cell.addressCellAddressPartner.text = addressesPartner.addressTextPartrner;
    cell.metroCellAddressPartner.text = addressesPartner.addressMetroPartrner;
    
    return cell;
}

// Высота строки в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 50;}


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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
