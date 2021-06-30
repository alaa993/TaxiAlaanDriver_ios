//
//  SummaryViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 21/06/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UICountingLabel.h"

@interface SummaryViewController : UIViewController
{
    AppDelegate *appDelegate;
    NSMutableArray *countArray;
    NSDictionary *summaryResponse;
    int count;

}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
