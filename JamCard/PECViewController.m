//
//  PECViewController.m
//  JamCard
//
//  Created by Admin on 11/18/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECViewController.h"
#import "PECDetailActionViewCtrl.h"
#import "PECDetailCardViewCtrl.h"
#import "PECBuilderModelCard.h"
#import "PECModelDataCards.h"
#import "PECAutorizationViewCtrl.h"

#import <QuartzCore/QuartzCore.h>



@interface PECViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableViewControl;
@property (strong, nonatomic) IBOutlet UIView *topViewCardsControl;

@property (strong, nonatomic) IBOutlet UIView *awesomeZG;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic) BOOL usedPageControl;
@end

static NSMutableArray *objJSON;

@implementation PECViewController{

    NSArray *tableData;
   UIView *containerCards;
   int offsetXContView;
   int cardInContainerX;
   int cardInContainerY;
   float widthDiscontCard;
   float heightDiscontCard;
   int kCrdInCt;
   int marginCards;
   int countCardsAtWidth;
   int numberOfPages;
   int tagFromObject;
   
   bool autorizationTRUE;

}

+(NSMutableArray*)getObjJSON{ return [objJSON copy];}

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self viewCustomNavigationBar];
   [self dataInitDataTableActions];
   
   // Loading data from internet
   if(!objJSON.count){
      #pragma mark - Page View Controller Loading Data Dards in objJSON
      [self getDataAtCard];
   }else{
      [self addCardsToScrollView : (NSMutableArray*) objJSON];
   }
   
   
}


// ----------------------------------------
// VIEW Navigation Bar. Changing Images Button
// ----------------------------------------
- (void)viewCustomNavigationBar
{
    // Changing Images Button Navigation Bar
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = shareItem;
    self.navigationItem.leftBarButtonItem = cameraItem;
}

// ----------------------------------------
// SHOW CARDS.
// ----------------------------------------
- (void)addCardsToScrollView : (NSMutableArray*) objJSON
{

   // SETTINGS VIEWCARD IN CONTAINER
   countCardsAtWidth = 2; // количество карт по ширине
   marginCards = 37.0f;   // отступы между картами
   //-------------------------------
   
   widthDiscontCard = (320.0f-(marginCards * (countCardsAtWidth+1.0f)))/countCardsAtWidth;
   heightDiscontCard = widthDiscontCard * 0.6f;
   int countCardsInContainer = ((240.0f-(marginCards * (countCardsAtWidth+1.0f))) / heightDiscontCard) * countCardsAtWidth;
   
   int countCards = objJSON.count;
   float countSliders = ceilf((float)countCards/ (float)countCardsInContainer);
   CGFloat widthSliderContainer =  countSliders * 320.0f;
   
   CGRect oldFrame = self.contentView.frame;
   CGRect newFrame = CGRectMake( oldFrame.origin.x, oldFrame.origin.y, widthSliderContainer, oldFrame.size.height);
   self.contentView.frame = newFrame;
   self.headerScrollView.contentSize = self.contentView.frame.size;
   self.headerPageControl.numberOfPages = (int)countSliders;
   
   offsetXContView = 0; kCrdInCt = 1; tagFromObject=0;
   
   for(NSObject *obj in objJSON){
       
      // Asynh loading images from url
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
      dispatch_async(queue, ^{
         
         UIImage *image; NSData *data; NSData *dataImgCard = [obj valueForKey:@"dataImgCard"];
         if(dataImgCard != NULL){
            // Data Exist CREATE CARDS
            data = dataImgCard;
         }else{
            // Loading Images From URL. CREATE CARDS
            NSURL *url = [NSURL URLWithString: [obj valueForKey:@"urlImgCard"]];
            data = [NSData dataWithContentsOfURL:url];
            [obj setValue:data forKey:@"dataImgCard"];
         }
         
         image = [UIImage imageWithData:data];
         
         // Create and calc position new Container
         if([containerCards subviews].count%(countCardsInContainer*2) == 0 )
         {
            CGRect cardsFrame = CGRectMake( offsetXContView, 0, 320, 210 );
            containerCards = [[UIView alloc]initWithFrame:cardsFrame];
            offsetXContView +=320;
            cardInContainerX = marginCards; cardInContainerY = marginCards; kCrdInCt = 1;
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
            
            // Calc Position Cards in Container
            if(countCardsAtWidth*kCrdInCt<(([containerCards subviews].count/2)+1)){
               cardInContainerY+=(heightDiscontCard + marginCards); cardInContainerX = marginCards; kCrdInCt+=1;
            }else{
               if([containerCards subviews].count!=0)
                  cardInContainerX += (widthDiscontCard+marginCards);
            }
            
            CGRect cardImages = CGRectMake( cardInContainerX, cardInContainerY, widthDiscontCard, heightDiscontCard );
            // Image Card
            UIImageView *imgCard = [[UIImageView alloc]initWithFrame:cardImages];
            imgCard.image = image;
            imgCard.layer.cornerRadius = (widthDiscontCard/100.0f)*5;
            imgCard.layer.masksToBounds = YES;

            [containerCards addSubview:imgCard];
            
            // Button Card Up Image
            UIButton *button = [[UIButton alloc] initWithFrame: cardImages];
            [button setTitle: @"" forState: UIControlStateNormal];
            [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
            
            [button setTag: tagFromObject++];
            [button addTarget: self
                       action: @selector(buttonCardClicked:)
             
             forControlEvents: UIControlEventTouchDown];
            [containerCards addSubview:button];
            
            // Add container cards to Scroll
            [self.contentView addSubview:containerCards];
          });
       });
   }
}


- (void) buttonCardClicked: (id)sender
{
   
//   [PECDetailCardViewCtrl ]
   NSLog( @"Button clicked. %i", [sender tag]);
   
   autorizationTRUE = false;
   
   if(autorizationTRUE)
   {
      PECDetailCardViewCtrl *detailCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailCardController"];
      detailCardController.selectedCard = [sender tag];
      [self.navigationController pushViewController: detailCardController animated:YES];
   
   }else{
      
      PECAutorizationViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
      [self.navigationController pushViewController: autorizationCardController animated:YES];
      
      
   }
   
   
}


//------------------------------- USER AUTORIZATION -------------------------------------------------


- (void) autorizationUserInSys{

   


}






//------------------------------- START PARSING------------------------------------------------------

//------------------------------
// Get Data From Images
//------------------------------
   /*
-(UIImageView *) getImagesCardsFromInternetURL:(NSString*)ImageURL
{
   NSURL *url = [NSURL URLWithString: ImageURL];
   NSData *data = [NSData dataWithContentsOfURL:url];
   UIImage *image = [[UIImage alloc] initWithData:data];
   UIImageView *ImgView = [[UIImageView alloc] initWithImage:image];
   
   return ImgView;
}
    */

//------------------------------
// Parser JSON OBJECT
//------------------------------
- (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
   NSError *localError = nil;
   
   NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
   
   if (localError != nil) {
      *error = localError;
      return nil;
   }
   
   NSArray *response = [parsedObject valueForKey:@"response"];
   NSMutableArray *groups = [[NSMutableArray alloc] init];
   int incObj = 0;
   for (NSDictionary *items in response)
   {
      
      NSDictionary *resParse = items;
      
      PECModelDataCards *model = [[PECModelDataCards alloc] init];
      model.progrId = incObj++;
      
      for (NSString *key in resParse)
      {
         if ([model respondsToSelector:NSSelectorFromString(key)]) {
            [model setValue:[resParse valueForKey:key] forKey:key];
         }
      }
      [groups addObject:model];
   }
   
   //sArrObjectsCards = groups;
   
   /*
    for(NSObject *obj in sArrObjectsCards){
    NSLog(@"%@", [obj valueForKey:@"idCard"]);
    }
    */
   return groups;
}

//------------------------------
// Get Data Cards from Internet
//------------------------------
- (void)getDataAtCard
{
      NSString *urlAsString = @"http://paladin-engineering.ru/data/jamSon.php";
      
      //[NSString stringWithFormat:@"https://api.meetup.com/2/groups?lat=%f&lon=%f&page=%d&key=%@", coordinate.latitude, coordinate.longitude, PAGE_COUNT, API_KEY];
      
      NSURL *url = [[NSURL alloc] initWithString:urlAsString];
      NSLog(@"%@", urlAsString);
      
      [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         
         if (error) {
            //          [self.delegate fetchingGroupsFailedWithError:error];
         } else {
            NSError *nError;
            objJSON = [self groupsFromJSON:data error:&nError];
            [self addCardsToScrollView : (NSMutableArray*) objJSON];
         }
         
      }];
}

//------------------------------- END PARSING-----------------------------------------------------------


// Init Disain

- (IBAction)pageChanged:(UIPageControl *)sender {
    
    CGFloat headerViewWidth = self.headerScrollView.frame.size.width;
    CGRect frame = self.headerScrollView.frame;
    frame.origin = CGPointMake(headerViewWidth*sender.currentPage, 0);
    self.usedPageControl = YES;
    [self.headerScrollView scrollRectToVisible:frame animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self darkerTheBackground:scrollView.contentOffset.x];
}

- (void)darkerTheBackground:(CGFloat)xOffSet{
    if (xOffSet != 0) {
        CGFloat pageWidth = self.headerScrollView.frame.size.width;
        if (!self.usedPageControl) {
            int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
            self.headerPageControl.currentPage = page;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        self.usedPageControl = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.headerScrollView) {
        self.usedPageControl = NO;
    }
}


// ----------------------------------------
// DATA. Init Base Data table
// ----------------------------------------
- (void)dataInitDataTableActions
{
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}


// ----------------------------------------
// SHOW DATA TABLE.
// ----------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DetailActionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ZG.png"];

    return cell;
    
}


// Send data to Page "Detail Action"
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showActionDetail"]) {
        NSIndexPath *indexPath = [self.tableViewControl indexPathForSelectedRow];
        PECDetailActionViewCtrl *destViewController = segue.destinationViewController;
        //destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
    }
}


// ----------------------------------------
// ALL.
// ----------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
