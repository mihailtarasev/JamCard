//
//  PECMapViewCtrl.m
//  JamCard
//
//  Created by Admin on 12/27/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//
//  ~ MAPKIT

#import "PECMapViewCtrl.h"
#import "PECAnnotation.h"
#import "PECBuilderModel.h"
#import "PECModelsData.h"
#import "PECModelPoints.h"
#import "PECModelPartner.h"
#import "PECDetailCardViewCtrl.h"
#import "PECAutorizationViewCtrl.h"


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PECMapViewCtrl ()<CLLocationManagerDelegate>

// Filter Map
@property (strong, nonatomic) IBOutlet UIView *mapCardContainer;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PECMapViewCtrl


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self PAGE_MAPCARDS_CONTROL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

// Инициализация странички с картой
- (void)PAGE_MAPCARDS_CONTROL
{
    // Настройка mapkit
    //[_mapView setShowsUserLocation:YES];
    //[_mapView setDelegate:self];
    // Начальная координата
    // [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(59.94397,30.107048), MKCoordinateSpanMake(0.4,0.4))];
    
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
        });
    }
    
    [self setupMapForLocatoion:newLocation];
}


- (void)setupMapForLocatoion:(CLLocation *)newLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
