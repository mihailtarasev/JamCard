//
//  PECViewController.h
//  JamCard
//
//  Created by Admin on 11/18/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)pageChanged:(UIPageControl *)sender;
- (void)buttonCardClicked: (id)sender;

+(NSMutableArray*)getObjJSON;

@end
