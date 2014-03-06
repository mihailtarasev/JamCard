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

#import "PECAnnotation.h"
#import "PECBuilderModel.h"
#import "PECModelsData.h"
#import "PECModelPoints.h"
#import "PECModelPartner.h"
#import "PECDetailCardViewCtrl.h"
#import "PECAutorizationViewCtrl.h"
#import "PECObjectCard.h"


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PECAddressPartnerViewCtrl ()

// Filter Map
@property (strong, nonatomic) IBOutlet UIView *mapCardContainer;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PECAddressPartnerViewCtrl
{
    // Table
    NSArray *tableData;
    UIView *mainContVerifi;
    NSMutableDictionary *arrPhoneObj;
    NSString *phoneNumAck ;
    
}

// Инициализация странички с картой
- (void)PAGE_MAPCARDS_CONTROL
{
    // Настройка mapkit
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
    
    // Начальная координата
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(59.94397,30.107048), MKCoordinateSpanMake(0.4,0.4))];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    NSArray *arrPointsOnMap = [PECBuilderModel parserJSONPoints:[PECModelsData getModelPartners] error:nil];
    
    for(PECModelPoints *points in arrPointsOnMap)
    {
        
        // Добавляю точки на карту
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for(PECModelPoints *addressesPartner in tableData)
            {
                if(addressesPartner.addressIdPartrner == points.addressIdPartrner)
                {
                    double latit = [points.addressLatPartrner doubleValue];
                    double longit = [points.addressLongPartrner doubleValue];
                    
                    PECModelPartner *parner = [[PECModelPartner alloc]init];
                    parner = (PECModelPartner*)(points.modelPartner);
                    NSString *shortDesc = parner.namePartrner;
                    
                    PECAnnotation *ann = [[PECAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(latit, longit)];
                    ann.title = shortDesc;
                    ann.idAnnotation = parner.idPartner;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_mapView addAnnotation:ann];
                    });
                    
                    continue;
                    
                }
            }
        });
    }
    
    [self setupMapForLocatoion:newLocation];
}


- (void)setupMapForLocatoion:(CLLocation *)newLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}


// Добавляю на карту метку с лицом пользователя
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    NSLog(@"viewForAnnotation");
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if(annotation == mapView.userLocation)
        return nil;
    
    if ([annotation isKindOfClass:[PECAnnotation class]])
    {
        
        MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationView"];
        
        if (!pinView)
        {
            
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"];
            
            UIButton *btnViewVenue = [UIButton buttonWithType:UIButtonTypeInfoLight];
            
            pinView.rightCalloutAccessoryView=btnViewVenue;
            pinView.enabled = YES;
            pinView.canShowCallout = YES;
            pinView.multipleTouchEnabled = NO;
            
            pinView.image = [UIImage imageNamed:@"marker"];
            
            [pinView setCanShowCallout:YES];
            [pinView setDraggable:YES];
            
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    return nil;
}

// Обрабатываю событие нажатия на балун
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PECAnnotation *ann = [[PECAnnotation alloc]init];
    ann = view.annotation;
    
    bool autorizationTRUE = ([PECModelsData getModelUser].count);
    if(autorizationTRUE)
    {
        NSLog(@"calloutAccessoryControlTapped %d", ann.idAnnotation);
        PECDetailCardViewCtrl *detailCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailCardController"];
        detailCardController.selectedCard = ann.idAnnotation;
        [self.navigationController pushViewController: detailCardController animated:YES];
    }else
    {
        PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
        [self.navigationController pushViewController: autorizationCardController animated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    // Подтверждение звонка по номеру телефона
    mainContVerifi = [PECObjectCard addContainerRingViewController:self txtNumPhone:@""];
    [self.view addSubview:mainContVerifi];
    [mainContVerifi setAlpha:0.0];

    
    arrPhoneObj = [[NSMutableDictionary alloc]init];
    
    
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
    
    [self PAGE_MAPCARDS_CONTROL];
    
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
    
    cell.phoneTextCellAddressPartner.text = addressesPartner.addressTeleph1Partner;

    [cell.phoneCellAddressPartner setTag:indexPath.row];
    [cell.phoneCellAddressPartner addTarget:self action:@selector(buttonClickTableCell:) forControlEvents:UIControlEventTouchDown];
    
    [arrPhoneObj setValue:addressesPartner.addressTeleph1Partner forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    
    return cell;
}

- (IBAction) buttonClickTableCell: (UIButton*)sender
{
    phoneNumAck = [arrPhoneObj valueForKey:[NSString stringWithFormat:@"%d", sender.tag]];
    [self animationHideShowUIView:mainContVerifi showHide:true Select:0];
}

- (IBAction)bCloseEvent:(id)sender
{
    [self animationHideShowUIView:mainContVerifi showHide:false Select:0];
}

- (IBAction)bRingEvent:(id)sender
{
    NSString *callNumber = [NSString stringWithFormat:@"tel://%@", phoneNumAck];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
}

// Высота строки в таблице
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 70;}


// ~ СИСТЕМНЫЕ

// Кнопочка назад
- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
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
