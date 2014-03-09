//
//  PECSpisokViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/27/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECSpisokViewCtrl.h"
#import "PECDetailActionViewCtrl.h"
#import "PECBuilderModel.h"
#import "PECModelDataCards.h"
#import "PECBuilderCards.h"
#import "PECAllCardTableCell.h"
#import "PECObjectCard.h"
#import "PECCardObjEmpty.h"
#import "PECModelDataUser.h"
#import "PECDetailCardViewCtrl.h"
#import "PECAutorizationViewCtrl.h"
#import "PECModelsData.h"
#import "PECModelPartner.h"

@interface PECSpisokViewCtrl ()

@property (strong, nonatomic) IBOutlet NSDictionary *namesAllCardsFromTable;
@property (strong, nonatomic) IBOutlet NSArray *keysAllCardsFromTable;

@property (strong, nonatomic) IBOutlet UITableView *tableViewSpisok;


@end

@implementation PECSpisokViewCtrl
{
    NSMutableDictionary *arrLitKey;
    NSMutableDictionary *dictContainArrayObjects;
    NSArray *searchResults;
}


- (void) viewWillAppear: (BOOL)animated
{
    [self dataInitDataTableActions];
    
    [_tableViewSpisok reloadData];
    
    [super viewWillAppear:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 3.5 inch screen
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        _tableViewSpisok.frame = (CGRect){_tableViewSpisok.frame.origin, CGSizeMake(320, 330)};
    }
}

// ~ ОБРАБОТКА ТАБЛИЦЫ
- (void)dataInitDataTableActions
{
    // Сортирую карточки
    _namesAllCardsFromTable = [PECBuilderModel sortArrayAtLiters:[PECModelsData getModelCard] nameKey:@"" mode:true searchText:[self searchText]];
    NSArray *arrKey = [[_namesAllCardsFromTable allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    _keysAllCardsFromTable = arrKey;
    
    dictContainArrayObjects = [[NSMutableDictionary alloc]init];
    
    // Прохожу по всем ключам описывающим объекты
    for(NSString *key in _keysAllCardsFromTable)
    {
        // Беру первую букву ключа
        NSString *keyDic = [key substringToIndex:1];
        
        if([dictContainArrayObjects valueForKey:keyDic]==nil)
        {
        // Если не существует коллекции массивов объектов под таким ключем добавляю ее
            
            // Добавляю новый объект под таким ключем
            NSObject *objDic = [_namesAllCardsFromTable objectForKey:key];
            NSMutableArray *arrDic = [[NSMutableArray alloc]init];
            [arrDic addObject:objDic];
            
            [dictContainArrayObjects setObject:arrDic forKey:keyDic];
        }else
        {
        // Если коллекция массивов объектов под таким ключем существует
            // Нахожу ее и добавляю в ее массив новый объект
            NSMutableArray *arrDic =  [[NSMutableArray alloc]init];
            arrDic = [dictContainArrayObjects objectForKey:keyDic];
            [arrDic addObject:[_namesAllCardsFromTable objectForKey:key]];
        }
    }
    
}

// Количество секции в таблице
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dictContainArrayObjects count];
}

// Количество строк в секци
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Таблица всех карт
    NSArray *keys = [dictContainArrayObjects allKeys];
    id aKey = [keys objectAtIndex:section];
    NSArray *anObject = [dictContainArrayObjects objectForKey:aKey];
    
    return [anObject count];
}

// Добавление карточки в таблицу
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Забираю .nib файл
    PECAllCardTableCell *cell = (PECAllCardTableCell *)[tableView dequeueReusableCellWithIdentifier: @"ActionTaCellAllCards"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECAllCardTableCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    NSArray *keys = [dictContainArrayObjects allKeys];
    id aKey = [keys objectAtIndex:indexPath.section];
    NSArray *anObject = [dictContainArrayObjects objectForKey:aKey];
    
    // Заполненная модель карточки
    PECModelDataCards *modelCard = [[PECModelDataCards alloc] init];
    modelCard = [anObject objectAtIndex:indexPath.row];
    
    // Заголовок и описание карточки
    cell.textTbCellAllCards.text = modelCard.descCard;
    cell.titleTbCellAllCards.text = modelCard.nameCard;
    
    [cell.buttonClickTableCell setTag:modelCard.idCard];
    [cell.buttonClickTableCell addTarget:self action:@selector(buttonCardClicked:) forControlEvents:UIControlEventTouchDown];
    [cell.buttonClickTableCell setExclusiveTouch:YES];
    
    // Расчитываю размер карточки
    PECObjectCard *objCard = [[PECObjectCard alloc]init];
    CGRect cardImagesFrame = CGRectMake( 0, 0, 110, 70 );
        
    // Добавляю карточку в таблицу списка
    int ackCard = modelCard.statusCard;
    if(ackCard==2)
        ackCard = 0;
    
    UIView *ObjCardView = [objCard inWithParamImageCard:nil cardImagesFrame:cardImagesFrame tagFromObject:modelCard.idCard uiViewCntr:nil activationCard:ackCard distanceGeo:modelCard.distanceCard obj:modelCard];
    
    [cell.imgViewTbCellAllCards addSubview:ObjCardView];
    
    return cell;
}


// Заполняю секцию белым цветом
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] init];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

// Заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *keys = [dictContainArrayObjects allKeys];
    id aKey = [keys objectAtIndex:section];
    
    return aKey;
}

// Высота строки в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 78;}
/*
// ?Обработка нажатия в таблице
- (void) buttonClickTableCell: (id)sender
{
    PECDetailActionViewCtrl *detailActionController = [self.storyboard instantiateViewControllerWithIdentifier:@"showActionDetail"];
    detailActionController.selectedAction = [sender tag];
    [self.navigationController pushViewController: detailActionController animated:YES];
}*/

// Авторизация и детализация карточки
- (void)buttonCardClicked: (id)sender
{
    bool autorizationTRUE = ([PECModelsData getModelUser].count);
    
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
