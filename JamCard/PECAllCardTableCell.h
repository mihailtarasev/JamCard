//
//  PECAllCardTableCell.h
//  JamCard
//
//  Created by Admin on 12/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECAllCardTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *textTbCellAllCards;
@property (nonatomic, weak) IBOutlet UILabel *titleTbCellAllCards;
@property (nonatomic, weak) IBOutlet UIImageView *imgTbCellAllCards;

@property (nonatomic, weak) IBOutlet UIView *imgViewTbCellAllCards;

@property (nonatomic, weak) IBOutlet UIButton *buttonClickTableCell;

@end
