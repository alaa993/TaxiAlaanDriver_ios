//
//  EarningsViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 11/04/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"
#import "AppDelegate.h"

@class AppDelegate;

@interface EarningsViewController : UIViewController
{
    AppDelegate *appDelegate;
    NSMutableArray *timeArray, *distanceArray, *amountArray;
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *circularProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *totalEarnigsValues;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UILabel *HeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *TimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *TargetLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalEarningLbl;

@end
