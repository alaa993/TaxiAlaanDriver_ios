//
//  SummaryTableViewCell.h
//  Provider
//
//  Created by iCOMPUTERS on 21/06/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"

@interface SummaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UICountingLabel *countLbl;
@property (weak, nonatomic) IBOutlet UIView *inner;
@property (weak, nonatomic) IBOutlet UIImageView *imageLbl;
@property (weak, nonatomic) IBOutlet UILabel *dollarLbl;


@end
