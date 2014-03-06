//
//  PECAddressTableCell.h
//  JamCard
//
//  Created by Admin on 1/17/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECAddressTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *addressCellAddressPartner;
@property (nonatomic, weak) IBOutlet UILabel *metroCellAddressPartner;

@property (nonatomic, weak) IBOutlet UILabel *distanceCellAddressPartner;
@property (nonatomic, weak) IBOutlet UIButton *phoneCellAddressPartner;
@property (nonatomic, weak) IBOutlet UILabel *phoneTextCellAddressPartner;

@end
