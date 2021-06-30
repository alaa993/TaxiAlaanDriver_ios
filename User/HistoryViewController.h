//
//  HistoryViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@class AppDelegate;
@interface HistoryViewController : UIViewController
{
    NSString *app_Name, *mobileStr;
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *pickLb;
@property (weak, nonatomic) IBOutlet UILabel *dropLb;
@property (weak, nonatomic) IBOutlet UILabel *paymentLb;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *cashLb;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *commentsLb;
@property (weak, nonatomic) IBOutlet UILabel *bookingIdLbl;


@property (weak, nonatomic) IBOutlet UIImageView *mapImg;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@property (weak, nonatomic) IBOutlet UIView *commentsView;

@property (strong, nonatomic) IBOutlet HCSStarRatingView *rating;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *rating_user;

@property (weak, nonatomic) NSString *historyHintStr, *request_idStr;
@property (weak, nonatomic) IBOutlet UIButton *CallPhone;

@end
