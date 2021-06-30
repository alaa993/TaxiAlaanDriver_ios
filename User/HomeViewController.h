//
//  HomeViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuView.h"
#import "LoadingViewClass.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "AppDelegate.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class AppDelegate;
@class LoadingViewClass;
@import GoogleMaps;

@interface HomeViewController : UIViewController<LeftMenuViewprotocol, UIGestureRecognizerDelegate, GMSMapViewDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate>
{
    AppDelegate *appDelegate;
    LeftMenuView *leftMenuViewClass;
    UIView *waitingBGView;
    LoadingViewClass *loading;
    UIView *backgroundView, *popUpView;
    BOOL gotLocation, locationMapped, moveNextLocation, leftmenuFlag, socketConnectFlag, isSchedule;
    NSString *s_Lat, *s_Lng, *d_Lat, *d_Lng, *mobileStr, *locationString, *switchMapStr;
    int secondsLeft, hours, minutes;
    NSString *dS_Lat, *dS_Lng, *dD_Lat, *dD_Lng, *scheduleStr, *globalStatus, *accountStatus;
    NSDictionary *params;
    
}
@property (weak, nonatomic) IBOutlet UILabel *awaittingApproveLbl;

@property(nonatomic, strong) NSTimer *timerForReqProgress;
@property(nonatomic, strong) NSTimer *timerForReqStatus;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSTimer *soundTimer;

@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property(strong,nonatomic)IBOutlet GMSMarker*marker;
@property (strong, nonatomic) IBOutlet GMSMapView *mkap;
@property(nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *menuImgBtn;

@property (weak, nonatomic) IBOutlet UIView *notifyView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddress;
@property (weak, nonatomic) IBOutlet UIImageView *rateUserImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *rateViewView;
@property (weak, nonatomic) IBOutlet UIView *invoiceView;
@property (weak, nonatomic) IBOutlet UIView *commonRateView;

@property (weak, nonatomic) IBOutlet UIScrollView *rateScrollView;

@property (weak, nonatomic) IBOutlet UITextField *commentsText;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (strong, nonatomic) IBOutlet HCSStarRatingView *rating;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *rating_user;

@property (weak, nonatomic) IBOutlet UIButton *navigationBtn;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationBtn;

@property (weak, nonatomic) IBOutlet UIView *gifView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImage;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

/////Invoice
@property (weak, nonatomic) IBOutlet UILabel *labelTravel;
@property (weak, nonatomic) IBOutlet UILabel *labelValueTravel;

@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
@property (weak, nonatomic) IBOutlet UILabel *labelValueDiscount;

@property (weak, nonatomic) IBOutlet UILabel *labelTotal;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLbl;




@property (weak, nonatomic) IBOutlet UILabel *rateNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPayment;




/// SKU Img
@property (weak, nonatomic) IBOutlet UIImageView *arrivedImg;
@property (weak, nonatomic) IBOutlet UIImageView *pickupImg;
@property (weak, nonatomic) IBOutlet UIImageView *finishedImg;
@property (weak, nonatomic) IBOutlet UIView *SKUView;

//Schedule
@property (weak, nonatomic) IBOutlet UILabel *scheduleLbl;
@property (weak, nonatomic) IBOutlet UIButton *sosBtn;
@property (weak, nonatomic) IBOutlet UIImageView *offlineImg;

// call
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIImageView *viberImage;
@property (weak, nonatomic) IBOutlet UIImageView *whatsappImage;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIButton *tempButton;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


@end
