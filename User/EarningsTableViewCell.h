//
//  EarningsTableViewCell.h
//  Provider
//
//  Created by iCOMPUTERS on 12/04/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarningsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIView *inner;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@end
