//
//  HomeViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "HomeViewController.h"
#import "EmailViewController.h"
#import "WalletViewController.h"
#import "YourTripViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "ProfileViewController.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AFNHelper.h"
#import "Utilities.h"
#import "RouteViewController.h"
#import "UIImage+animatedGIF.h"
#import "EarningsViewController.h"
#import "HelpViewController.h"
#import "SummaryViewController.h"
#import "LanguageController.h"
#import "Provider-Swift.h"
#import "Colors.h"
@import GoogleMobileAds;

@interface HomeViewController ()
{
    
    CLLocation *myLocation, *CurrentLocation, *StartLocation, *NewLocaton, *OldLocation;
    GMSCameraPosition *lastCameraPosition;
    GMSMarker *endLocationMarker, *startLocationMarker,*providerMarkers;
    GMSCoordinateBounds *bounds;
    AVAudioPlayer *audioPlayer;
    NSString *travelStatus, *totalDistance;
    BOOL StartLocationTaken;
    float TotalM, TotalKM;
    BOOL statusCheckPayment;
    MqttContection *mqtt;
    NSArray *waypoints;
    NSString* flowStatus;
    NSTimeInterval  timerMoveMap;
     bool statusDestinationTripNormal;
    bool statusrDestinationSearchOrStart;
    
}
@property (nonatomic,retain)UIView*mapV;
@property (weak, nonatomic) IBOutlet GADBannerView *BannerView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"The style definition could not be loaded: %s", "sssssss");
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _rating_user.value = 0.00;
    secondsLeft = 0;
    travelStatus = @"";
    isSchedule = false;
    totalDistance = @"";
    globalStatus = @"";
    scheduleStr = @"false";
    statusCheckPayment = TRUE;
    statusDestinationTripNormal = true;
    statusrDestinationSearchOrStart = true;
    timerMoveMap = 0;
    mqtt = [[MqttContection alloc]init];
    
    NSURL *url_GIF = [[NSBundle mainBundle] URLForResource:@"driver" withExtension:@"gif"];
    _gifImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url_GIF]];
    _gifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url_GIF];
        [_gifView setHidden:YES];
    [self countdownTimer];
    [self setDesignStyles];
    
    [_offlineImg setHidden:YES];
    
    
    locationMapped = false;
    gotLocation = false;
    leftmenuFlag = true;
    moveNextLocation = false;
    
    [self currentLocation];
    
    
    [_rateScrollView setContentSize:[_rateScrollView frame].size];
    [_rateScrollView setKeyboardAvoidingEnabled:YES];
    
    _mkap = [[GMSMapView alloc]initWithFrame:_mapView.frame];
    _mkap.myLocationEnabled = YES;
    _mkap.delegate=self;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    NSError *error;
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    _mkap.mapStyle = style;
    [_mapView addSubview:_mkap];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"The style definition could not be loaded1: %s", "sssssss1");
    NSString *statusStr = [defaults valueForKey:@"status"];
    NSLog(@"The style definition could not be loaded:2 %s", "sssssss2");
    [self getStatusMethod:statusStr];
    
    [self.view bringSubviewToFront:_sosBtn];
    [_sosBtn setHidden:YES];
    
    [self getIncomingRequest];
    
    _timerForReqProgress=[NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(getIncomingRequest)
                                                        userInfo:nil
                                                         repeats:YES];
    
    [_pickupImg setImage:[UIImage imageNamed:@"pickup"]];
    [_pickupImg setHighlightedImage:[UIImage imageNamed:@"pickup-select"]];
    
    [_arrivedImg setImage:[UIImage imageNamed:@"arrived"]];
    [_arrivedImg setHighlightedImage:[UIImage imageNamed:@"arrived-select"]];
    
    [_finishedImg setImage:[UIImage imageNamed:@"finished"]];
    [_finishedImg setHighlightedImage:[UIImage imageNamed:@"finished-select"]];
    
    
    [self TapCallView];
    [self getWeather];
    [self adsGoogle];
    [mqtt connect];
    
    
}


-(void) adsGoogle{
    
    _BannerView.adUnitID = @"ca-app-pub-6606021354718512/5888672923";
    _BannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
   // request.testDevices = @[kGADSimulatorID];
    [_BannerView loadRequest:request];
    
}

-(IBAction)callBtn:(id)sender
{
    // CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185)
    //_notifyView.hidden=YES;
    [UIView animateWithDuration:0.45 animations:^{
        
        _callView.frame =  CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -100), self.view.frame.size.width,  185);
    }];
    
    [self.view bringSubviewToFront:_callView];
    
    
}

-(void)closed{
    [UIView animateWithDuration:0.45 animations:^{
        
        self->_callView.frame =  CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+100), self.view.frame.size.width,  185);
    }];
    
    
}

-(void)TapCallView{
    
    UITapGestureRecognizer *viber = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viber)];
    viber.numberOfTapsRequired = 1;
    [_viberImage setUserInteractionEnabled:YES];
    [_viberImage addGestureRecognizer:viber];
    
    
    UITapGestureRecognizer *whatsapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whatsapp)];
    whatsapp.numberOfTapsRequired = 1;
    [_whatsappImage setUserInteractionEnabled:YES];
    [_whatsappImage addGestureRecognizer:whatsapp];
    
    
    
    UITapGestureRecognizer *phone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone)];
    phone.numberOfTapsRequired = 1;
    [_phoneImage setUserInteractionEnabled:YES];
    [_phoneImage addGestureRecognizer:phone];
    
    UITapGestureRecognizer *closed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closed)];
    closed.numberOfTapsRequired = 1;
    [_closeBtn setUserInteractionEnabled:YES];
    [_closeBtn addGestureRecognizer:closed];
    
}

-(void)viber{
    
    NSString *phoneNumber = mobileStr;
    NSString * const viberScheme = @"viber://";
    NSString * const tel = @"tel";
    NSString * const chat = @"chat";
    NSString *action = @"<user selection, chat or tel>"; // this could be @"chat" or @"tel" depending on the choice of the user
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:viberScheme]]) {
        
        // viber is installed
        NSString *myString;
        if ([action isEqualToString:tel]) {
            myString = [NSString stringWithFormat:@"%@:%@", tel, phoneNumber];
        } else if ([action isEqualToString:chat]) {
            myString = [NSString stringWithFormat:@"%@:%@", chat, phoneNumber];
        }
        
        NSURL *myUrl = [NSURL URLWithString:[viberScheme stringByAppendingString:myString]];
        
        if ([[UIApplication sharedApplication] canOpenURL:myUrl]) {
            [[UIApplication sharedApplication] openURL:myUrl options:@{} completionHandler:nil];
        } else {
            // wrong parameters
        }
        
    } else {
        // viber is not installed
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:@"viber is not installed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _callView.frame =  CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+100), self.view.frame.size.width,  185);
    }];
    
}


-(void)whatsapp{
    
    NSString* newString=[NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=%@&text=%@",mobileStr,@""];
    
    NSURL *whatsappURL = [NSURL URLWithString:newString];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
        // UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:@"whatsapp is not installed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _callView.frame =  CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+100), self.view.frame.size.width,  185);
    }];
    
}

-(void)phone{
    
    if ([mobileStr isEqualToString:@""])
    {
        [CSS_Class alertviewController_title:LocalizedString(@"Alert!") MessageAlert:LocalizedString(@"User was not gave the mobile number") viewController:self okPop:NO];
    }
    else
    {
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:mobileStr]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:mobileStr]];
        
        if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
        {
            [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
        }
        else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
        {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CALL") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];    }
    }
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _callView.frame =  CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+100), self.view.frame.size.width,  185);
    }];
    
}

-(void) LocalizationUpdate{
    
    _awaittingApproveLbl.text = LocalizedString(@"Awaiting approval");
    _nameLbl.text =  LocalizedString(@"Name");
    _totalLbl.text = LocalizedString(@"Total");
    [_paymentBtn setTitle:LocalizedString(@"CONFIRM PAYMENT") forState:UIControlStateNormal];
    [_submitBtn setTitle:LocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    [_statusBtn setTitle:LocalizedString(@"TAP WHEN ARRIVED") forState:UIControlStateNormal];
    [_acceptBtn setTitle:LocalizedString(@"ACCEPT") forState:UIControlStateNormal];
    [_rejectBtn setTitle:LocalizedString(@"REJECT") forState:UIControlStateNormal];
    [_onlineBtn setTitle:LocalizedString(@"GO ONLINE") forState:UIControlStateNormal];
    _textFieldPayment.placeholder = LocalizedString(@"CASH");
    
    _labelTravel.text = LocalizedString(@"Travel costs");
    _labelDiscount.text = LocalizedString(@"Discount");
    _labelTotal.text = LocalizedString(@"Total");
    
}


-(void)audioFile
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"alert_tone" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    
    [audioPlayer stop];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [audioPlayer setVolume:3];
    [audioPlayer setNumberOfLoops:-1];
}

-(void)getStatusMethod:(NSString *)statusStr
{
    MINT_METHOD_TRACE_START
    [_onlineBtn setHidden:NO];
    [_gifView setHidden:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([statusStr isEqualToString:@"onboarding"])
    {
        [_onlineBtn setHidden:YES];
        [self offlineView];
        [_gifView setHidden:NO];
        [_offlineImg setHidden:YES];
        [_currentLocationBtn setHidden:YES];
    }
    else if ([statusStr isEqualToString:@"approved"])
    {
        NSString *activeStr = [Utilities removeNullFromString:[defaults valueForKey:@"Active"]];
        if ([activeStr isEqualToString:@"1"])
        {
            [_onlineBtn setTitle:LocalizedString(@"GO OFFLINE") forState:UIControlStateNormal];
            [self onlineView];
            [_currentLocationBtn setHidden:NO];
        }
        else
        {
            [_onlineBtn setTitle:LocalizedString(@"GO ONLINE") forState:UIControlStateNormal];
            [self offlineView];
            [_currentLocationBtn setHidden:YES];
        }
    }
    else
    {
        [_onlineBtn setHidden:YES];
        [_currentLocationBtn setHidden:YES];
        [_navigationBtn setHidden:YES];
    }
    
    leftMenuViewClass = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:self options:nil] objectAtIndex:0];
    [leftMenuViewClass setFrame:CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width - 100, self.view.frame.size.height)];
    
    leftMenuViewClass.LeftMenuViewDelegate =self;
    leftMenuViewClass.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:leftMenuViewClass];
    MINT_NONARC_METHOD_TRACE_STOP
}

-(void)currentLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = 20;
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.pausesLocationUpdatesAutomatically = false;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
}

-(void)getIncomingRequest
{
    
    NSLog(@"response...%@", appDelegate.device_UDID);
    MINT_METHOD_TRACE_START
    
    if([appDelegate internetConnected])
    {
        params =  @{@"latitude":[NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude], @"longitude":[NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath_NoLoader:INCOMING_REQUEST withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"response...%@", response);
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 
                 NSString *account_status = [response valueForKey:@"account_status"];
                 NSString *service_status = [response valueForKey:@"service_status"];
                 [defaults setObject:account_status forKey:@"status"];
                 
                 if ([account_status isEqualToString:@"onboarding"] ||[account_status isEqualToString:@"banned"])
                 {
                     [_onlineBtn setHidden:YES];
                     [self offlineView];
                     [_gifView setHidden:NO];
                     [_offlineImg setHidden:YES];
                 }
                 else if ([account_status isEqualToString:@"approved"])
                 {
                     if ([service_status isEqualToString:@"active"] || [service_status isEqualToString:@"riding"]){
                         
                         [defaults setObject:@"1" forKey:@"Active"];
                         
                         if ([accountStatus isEqualToString:account_status])
                         {
                             //
                         }else
                         {
                             accountStatus = account_status;
                             [self getStatusMethod:account_status];
                         }
                         
                         {
                             if ([response count] == 0)
                             {
                                 //Do Nothing
                             } else {
                                 d_Lng =@"";
                                 d_Lat =@"";
                                 
                                 s_Lat =@"";
                                 s_Lng =@"";
                                 
                                 NSArray *requestsArray = [response valueForKey:@"requests"];
                                 
                                 if ((requestsArray.count ==0)||[response[@"requests"] isKindOfClass:[NSNull class]])
                                 {
                                     locationMapped = false;
                                     moveNextLocation = false;
                                     GMSPolyline *polyline;
                                     polyline.map = nil;
                                     [_mkap clear];
                                     [_navigationBtn setHidden:YES];
                                     globalStatus =@"";
                                     [_sosBtn setHidden:YES];
                                     
                                     startLocationMarker.map=nil;
                                     startLocationMarker=[[GMSMarker alloc]init];
                                     
                                     endLocationMarker.map=nil;
                                     endLocationMarker=[[GMSMarker alloc]init];
                                     statusrDestinationSearchOrStart = true;
                                     statusDestinationTripNormal = true ;
                                     globalStatus = @"";
                                     totalDistance =@"";
                                     TotalM = 0;
                                     TotalKM = 0;
                                     
                                     [UIView animateWithDuration:0.45 animations:^{
                                         
                                         _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                                     }];
                                     
                                     [UIView animateWithDuration:0.45 animations:^{
                                         
                                         _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+20), self.view.frame.size.width,  300);
                                         
                                         _invoiceView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                                         _rateViewView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width+20, 0, self.view.frame.size.width, 300);
                                     }];
                                     
                                     
                                     if ([scheduleStr isEqualToString:@"true"])
                                     {
                                         scheduleStr  =@"false";
                                         isSchedule = false;
                                         
                                         YourTripViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"YourTripViewController"];
                                         wallet.navigateStr = @"Home";
                                         [self.navigationController pushViewController:wallet animated:YES];
                                     }
                                     else
                                     {
                                         //Nothing
                                     }
                                 }
                                 
                                 
                                 
                                 //////////////////////////////////////start
                                 else
                                 {
                                     
                                     NSDictionary *requestDict = [[requestsArray valueForKey:@"request"]objectAtIndex:0];
                                     NSDictionary *userDict = [requestDict valueForKey:@"user"];
                                     
                                     NSString *request_id = [[requestsArray valueForKey:@"request_id"]objectAtIndex:0];
                                     NSString *provider_id = [[requestsArray valueForKey:@"provider_id"]objectAtIndex:0];
                                     
                                     NSString *second=[NSString stringWithFormat:@"%@", [[requestsArray valueForKey:@"time_left_to_respond"]objectAtIndex:0]];
                                     secondsLeft = [second intValue];
                                     
                                     [defaults setValue:request_id forKey:@"request_id"];
                                     [defaults setValue:provider_id forKey:@"provider_id"];
                                     
                                     NSString *status = [requestDict valueForKey:@"status"];
                                     
                                     self->flowStatus = [requestDict valueForKey:@"flow"];
                                     self->waypoints = [requestDict valueForKey:@"waypoints"];
                                     
                                     d_Lat= [NSString stringWithFormat: @"%@", [requestDict valueForKey:@"d_latitude"]];
                                     d_Lng= [NSString stringWithFormat: @"%@", [requestDict valueForKey:@"d_longitude"]];
                                     
                                     s_Lat= [NSString stringWithFormat: @"%@", [requestDict valueForKey:@"s_latitude"]];
                                     s_Lng= [NSString stringWithFormat: @"%@", [requestDict valueForKey:@"s_longitude"]];
                                     
                                     
                                   
                                     
                                     //  _invoiceIdLbl.text=[NSString stringWithFormat:@"%@ - %@",LocalizedString(@"INVOICE ID"),[Utilities removeNullFromString:[requestDict valueForKey:@"booking_id"]]];
                                     
                                     if ([globalStatus isEqualToString:status])
                                     {
                                         
                                         NSLog(@"statusrDestinationSearchOrStart: %d",statusrDestinationSearchOrStart);
                                         NSLog(@"The flagWayTwo result is - %@",statusrDestinationSearchOrStart ? @"True":@"False");
                                         NSLog(@"Service in same status... Dont reload..!");
                                           [self liveNavigation:s_Lat:s_Lng:d_Lat:d_Lng];
                                         NSLog(@"statusrDestinationSearchOrStart: %d",statusrDestinationSearchOrStart);
                                         NSLog(@"The flagWayTwo result is - %@",statusrDestinationSearchOrStart ? @"True":@"False");
                                         NSLog(@"Service in same status... Dont reload..!");
                                         
                                         if ([status isEqualToString:@"SEARCHING"])
                                         {
                                             //Do Nothing
                                         }
                                         else
                                         {
                                             [audioPlayer stop];
                                         }
                                     }
                                     else
                                     {
                                         [_sosBtn setHidden:YES];
                                         
                                         globalStatus = @"";
                                         globalStatus = status;
                                         NSLog(@"statusrDestinationSearchOrStart: %d",statusrDestinationSearchOrStart);
                                         NSLog(@"The flagWayTwo result is - %@",statusrDestinationSearchOrStart ? @"True":@"False");
                                         NSLog(@"Service in same status... Dont reload..!");
                                        [self liveNavigation:s_Lat:s_Lng:d_Lat:d_Lng];
                                         
                                         int paid = [[requestDict valueForKey:@"paid"]intValue];
                                         
                                         [_timerView setHidden:YES];
                                         [_statusView setHidden:YES];
                                         [_SKUView setHidden:YES];
                                         
                                         [_pickupImg setHighlighted:NO];
                                         [_arrivedImg setHighlighted:NO];
                                         [_finishedImg setHighlighted:NO];
                                         [_callBtn setHidden:NO];
                                         
                                         NSString *scheduleString= [Utilities removeNullFromString:[requestDict valueForKey:@"schedule_at"]];
                                         
                                         if ([scheduleString isEqualToString:@""]){
                                             [_scheduleLbl setHidden:YES];
                                             isSchedule = false;
                                         }else{
                                             [_scheduleLbl setHidden:NO];
                                             [_scheduleLbl setText:[NSString stringWithFormat:@"%@-%@",LocalizedString(@"Schedule Request") ,scheduleString]];
                                             isSchedule = true;
                                         }
                
                                   
                                         _rating_user.value=[[userDict valueForKey:@"rating"]floatValue];
                                         
                                        _nameLbl.text =[NSString stringWithFormat:@"%@ %@",
                                                        [Utilities removeNullFromString: [userDict valueForKey:@"first_name"]]
                                                        ,[Utilities removeNullFromString: [userDict valueForKey:@"last_name"]]];
                                       
                                         
                                         _sourceAddress.text = [Utilities removeNullFromString: [requestDict valueForKey:@"s_address"]];
                                         _rateNameLbl.text =[NSString stringWithFormat:@"%@ %@",LocalizedString(@"Rate your trip with"),_nameLbl.text];
                                         mobileStr =[Utilities removeNullFromString: [userDict valueForKey:@"mobile"]];
                                         NSString *imageUrl =[Utilities removeNullFromString: [userDict valueForKey:@"picture"]];
                                         
                                         if (!([imageUrl isKindOfClass:[NSNull class]] || [imageUrl isEqualToString:@""]))
                                         {
                                             
                                             
                                             if ([imageUrl containsString:@"http"])
                                             {
                                                 NSURL *picURL = [NSURL URLWithString:imageUrl];
                                                 NSData *data = [NSData dataWithContentsOfURL:picURL];
                                                 UIImage *image = [UIImage imageWithData:data];
                                                 [self.userImg setImage:image];
                                                 [self.rateUserImg setImage:image];
                                             }
                                             else
                                             {
                                                 imageUrl = [NSString stringWithFormat:@"%@/storage/%@", SERVICE_URL, imageUrl];
                                                 NSURL *picURL = [NSURL URLWithString:imageUrl];
                                                 NSData *data = [NSData dataWithContentsOfURL:picURL];
                                                 UIImage *image = [UIImage imageWithData:data];
                                                 [self.userImg setImage:image];
                                                 [self.rateUserImg setImage:image];
                                             }
                                         }
                                         else
                                         {
                                             [self.userImg setImage:[UIImage imageNamed:@"user_profile"]];
                                             [self.rateUserImg setImage:[UIImage imageNamed:@"user_profile"]];
                                             
                                         }
                                         
                                         
                                         if ([status isEqualToString:@"SEARCHING"])
                                         {
                                             
                                           //  [self getPath];
                                             [_acceptBtn setTitle:LocalizedString(@"ACCEPT") forState:UIControlStateNormal];
                                             [_rejectBtn setTitle:LocalizedString(@"REJECT") forState:UIControlStateNormal];
                                             
                                             if (secondsLeft <= 0 )
                                             {
                                                 //_notifyView.hidden=YES;
                                                 [UIView animateWithDuration:0.45 animations:^{
                                                     
                                                     _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                                                 }];
                                             }
                                             else
                                             {
                                                 [self audioFile];
                                                 [UIView animateWithDuration:0.45 animations:^{
                                                     
                                                     _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
                                                     
                                                     if (!leftmenuFlag)
                                                     {
                                                         [self.view bringSubviewToFront:leftMenuViewClass];
                                                     }
                                                     else
                                                     {
                                                         [self.view bringSubviewToFront:_notifyView];
                                                     }
                                                     
                                                 }];
                                             }
                                             [_navigationBtn setHidden:YES];
                                             [_timerView setHidden:NO];
                                             [_statusView setHidden:NO];
                                             [_callBtn setHidden:YES];
                                             
                                         }
                                         else if ([status isEqualToString:@"STARTED"])
                                         {
                                             [_statusView setHidden:NO];
                                             
                                             [audioPlayer stop];
                                             
                                             [self.view bringSubviewToFront:_navigationBtn];
                                             
                                             [_navigationBtn setHidden:NO];
                                             [_SKUView setHidden:NO];
                                             
                                             [_acceptBtn setTitle:LocalizedString(@"ARRIVED") forState:UIControlStateNormal];
                                             [_rejectBtn setTitle:LocalizedString(@"CANCEL") forState:UIControlStateNormal];
                                             
                                             [_statusBtn setTitle:LocalizedString(@"ARRIVED") forState:UIControlStateNormal];
                                             
                                             
                                             
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
                                                 
                                                 if (!leftmenuFlag)
                                                 {
                                                     [self.view bringSubviewToFront:leftMenuViewClass];
                                                 }
                                                 else
                                                 {
                                                     [self.view bringSubviewToFront:_notifyView];
                                                 }
                                                 
                                             }];
                                             
                                         }
                                         else if ([status isEqualToString:@"ARRIVED"])
                                         {
                                             [_statusView setHidden:NO];
                                             
                                             [self.view bringSubviewToFront:_navigationBtn];
                                             
                                             [_navigationBtn setHidden:NO];
                                             [_SKUView setHidden:NO];
                                             
                                             [_arrivedImg setHighlighted:YES];
                                             
                                             [_acceptBtn setTitle:LocalizedString(@"PICKEDUP") forState:UIControlStateNormal];
                                             [_rejectBtn setTitle:LocalizedString(@"CANCEL") forState:UIControlStateNormal];
                                             
                                             [_statusBtn setTitle:LocalizedString(@"PICKEDUP") forState:UIControlStateNormal];
                                             
                                             if([[Utilities removeNullFromString: [requestDict valueForKey:@"d_address"]] isEqualToString:@"<null>"]) {
                                             }
                                             else {
                                                 _sourceAddress.text = [Utilities removeNullFromString: [requestDict valueForKey:@"d_address"]];
                                             }
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
                                                 
                                                 if (!leftmenuFlag)
                                                 {
                                                     [self.view bringSubviewToFront:leftMenuViewClass];
                                                 }
                                                 else
                                                 {
                                                     [self.view bringSubviewToFront:_notifyView];
                                                 }
                                             }];
                                         }
                                         else if ([status isEqualToString:@"PICKEDUP"])
                                         {
                                             
                                            // [self.view bringSubviewToFront:_sosBtn];
                                             //[_sosBtn setHidden:YES];
                                             
                                             travelStatus = @"driving";
                                             if([[Utilities removeNullFromString: [requestDict valueForKey:@"d_address"]] isEqualToString:@"<null>"]) {
                                             }
                                             else {
                                                 _sourceAddress.text = [Utilities removeNullFromString: [requestDict valueForKey:@"d_address"]];
                                             }
                                             
                                             locationMapped = false;
                                             [_SKUView setHidden:NO];
                                             [_pickupImg setHighlighted:YES];
                                             [_arrivedImg setHighlighted:YES];
                                             
                                             [self.view bringSubviewToFront:_navigationBtn];
                                             
                                             [_navigationBtn setHidden:NO];
                                             [_statusBtn setTitle:LocalizedString(@"DROPPED") forState:UIControlStateNormal];
                                             
                                            
                                             
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
                                                 
                                                 if (!leftmenuFlag)
                                                 {
                                                     [self.view bringSubviewToFront:leftMenuViewClass];
                                                 }
                                                 else
                                                 {
                                                     [self.view bringSubviewToFront:_notifyView];
                                                 }
                                                 
                                                 
                                             }];
                                         }
                                         else if ([status isEqualToString:@"DROPPED"])
                                         {
                                             travelStatus = @"stopped";
                                             
                                             [_navigationBtn setHidden:YES];
                                             [_pickupImg setHighlighted:YES];
                                             [_arrivedImg setHighlighted:YES];
                                             [_finishedImg setHighlighted:YES];
                                             
                                             [_statusBtn setTitle:LocalizedString(@"ARRIVED") forState:UIControlStateNormal];
                                             
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                                             }];
                                             
                                             if (paid == 0)
                                             {
                                                 
                                                 NSString *currency = [defaults valueForKey:@"currency"];
                                                 NSDictionary *paymentDict = [requestDict valueForKey:@"payment"];
                                                 
                                                 if ([[NSString stringWithFormat:@"%@",  [paymentDict valueForKey:@"total"]] isEqualToString:@"<null>"]) {
                                                     
                                                     // toast with a specific duration and position
                                                     [self.view makeToast:@"This is a piece of toast with a specific duration and position."
                                                                 duration:5.0
                                                                 position:CSToastPositionBottom];
                                                     
                                                     
                                                     globalStatus = @"PICKEDUP";
                                                     [self updateStatus:@"DROPPED"];
                                                     
                                                 }else {
                                                     
                                                     _totalValueLbl.text =[NSString stringWithFormat:@"%@%@", currency,  [paymentDict valueForKey:@"total"]];
                                                     
                                                     
                                                     self->_labelValueTravel.text = [NSString stringWithFormat:@"%@%@",currency,[paymentDict valueForKey:@"trip_price"]];
                                                     
                                                     
                                                     NSString *discount=[NSString stringWithFormat:@"%@",[paymentDict valueForKey:@"discount"]];
                                                     self-> _labelValueDiscount.text=[NSString stringWithFormat:@"%@%@",currency,discount];
                                                     
                                                     
                                                     [_paymentBtn setTitle:LocalizedString(@"CONFIRM PAYMENT") forState:UIControlStateNormal];
                                                     [UIView animateWithDuration:0.45 animations:^{
                                                         
                                                         _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 215), self.view.frame.size.width,  215);
                                                         
                                                         _invoiceView.frame = CGRectMake(0, 0, self.view.frame.size.width, 215);
                                                         _rateViewView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width+20, 0, self.view.frame.size.width, 300);
                                                         
                                                         if (!leftmenuFlag)
                                                         {
                                                             [self.view bringSubviewToFront:leftMenuViewClass];
                                                         }
                                                         else
                                                         {
                                                             [self.view bringSubviewToFront:_commonRateView];
                                                         }
                                                         
                                                     }];
                                                     
                                                 }
                                                 
                                                 
                                             }
                                             else
                                             {
                                                 [UIView animateWithDuration:0.45 animations:^{
                                                     
                                                     _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 300), self.view.frame.size.width,  300);
                                                     
                                                     _invoiceView.frame = CGRectMake( -self.view.frame.origin.x, 0, self.view.frame.size.width, 300);
                                                     _rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                                                     
                                                     if (!leftmenuFlag)
                                                     {
                                                         [self.view bringSubviewToFront:leftMenuViewClass];
                                                     }
                                                     else
                                                     {
                                                         [self.view bringSubviewToFront:_commonRateView];
                                                     }
                                                     
                                                 }];
                                             }
                                         }
                                         else if ([status isEqualToString:@"COMPLETED"])
                                         {
                                             [_navigationBtn setHidden:YES];
                                             
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                                             }];
                                             
                                             [UIView animateWithDuration:0.45 animations:^{
                                                 
                                                 _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 300), self.view.frame.size.width,  300);
                                                 
                                                 _invoiceView.frame = CGRectMake( -self.view.frame.origin.x, 0, self.view.frame.size.width, 300);
                                                 _rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                                                 
                                                 //                                                 _invoiceView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 290);
                                                 //                                                 _rateViewView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 250);
                                                 
                                                 if (!leftmenuFlag)
                                                 {
                                                     [self.view bringSubviewToFront:leftMenuViewClass];
                                                 }
                                                 else
                                                 {
                                                     [self.view bringSubviewToFront:_commonRateView];
                                                 }
                                                 
                                             }];
                                         }
                                        
                                         
                                     }
                                 }
                             }
                         }
                     }
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     else
                     {
                         [defaults setObject:@"0" forKey:@"Active"];
                         [self offlineView];
                         [_onlineBtn setHidden:NO];
                         [_gifView setHidden:YES];
                         [_currentLocationBtn setHidden:YES];
                     }
                 }
             }
             else
             {
                 NSLog(@"%@",error);
                 if ([strErrorCode intValue]==2)
                 {
                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                     {
                         //Refresh token
                         [self logoutMethod];
            
                     }
                     else
                     {
                         [self logoutMethod];
                     }
                 }
             }
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    MINT_NONARC_METHOD_TRACE_STOP
}


- (void)getPath
{
    MINT_METHOD_TRACE_START
    NSString *urlString;
    NSString *googleUrl = @"https://maps.googleapis.com/maps/api/directions/json";
    
    if ([d_Lat isEqualToString:@"0"]||[d_Lng isEqualToString:@"0"]||[d_Lat isEqualToString:@""]||[d_Lng isEqualToString:@""]||d_Lat == (id)[NSNull null]||d_Lng == (id)[NSNull null])
    {
        NSString *d_LatD = [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.latitude];
        NSString *d_LngD = [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude];
        
        urlString = [NSString stringWithFormat:@"%@?origin=%@,%@&destination=%@,%@&sensor=false&waypoints=%@&mode=driving&key=%@", googleUrl, s_Lat, s_Lng, d_LatD, d_LngD, @"",GOOGLE_API_KEY];
        
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@?origin=%@,%@&destination=%@,%@&sensor=false&waypoints=%@&mode=driving&key=%@", googleUrl, s_Lat, s_Lng, d_Lat, d_Lng, @"",GOOGLE_API_KEY];
        
    }
    
    NSLog(@"my driving api URL --- %@", urlString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error)
      {
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
          
          NSArray *routesArray = [json objectForKey:@"routes"];
          
          if ([routesArray count] > 0)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  GMSPolyline *polyline = nil;
                  [polyline setMap:nil];
                  NSDictionary *routeDict = [routesArray objectAtIndex:0];
                  NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                  NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                  GMSPath *path = [GMSPath pathFromEncodedPath:points];
                  polyline = [GMSPolyline polylineWithPath:path];
                  polyline.strokeWidth = 2.f;
                  polyline.strokeColor = [UIColor blackColor];
                  //polyline.map = nil;
                  // [polyline.map clear];
                  polyline.map = _mkap;
              });
          }
      }] resume];
    
    MINT_NONARC_METHOD_TRACE_STOP
}

-(void) liveNavigation :(NSString*) s_lat :(NSString *) s_lng : (NSString *) d_lat :(NSString *)d_lng {
    NSLog(@"%dasdasdsad",statusrDestinationSearchOrStart);
    
    NSLog(@"%sbrahim","ibrahim123");
    NSLog(@"%ibrahim",statusrDestinationSearchOrStart);
    NSLog(@"%@brahim",globalStatus);
    NSLog(@"%@brahim",flowStatus);
    NSLog(@"%lubrahim",(unsigned long)[waypoints count]);
    NSLog(@"%ibrahim",statusDestinationTripNormal);
    
    if (![globalStatus isEqualToString:@"STARTED"]&& ![globalStatus isEqualToString:@"SEARCHING"] && [flowStatus isEqualToString:@"OPTIONAL"] && ([waypoints count] > 0)) {
        NSLog(@"%sbrahim","ibrahim1");
        
        [ self->_mkap clear];
        GMSMutablePath *path = [GMSMutablePath path];
        for (NSObject *object in waypoints) {
            NSString *lati = [object valueForKey:@"latitude"];
            NSString *longi = [object valueForKey:@"longitude"];
            [path addCoordinate:CLLocationCoordinate2DMake(lati.doubleValue,longi.doubleValue)];
        }
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 3.f;
        polyline.strokeColor = BLUECOLOR_TEXT ;
        polyline.map = self->_mkap;
        
    }
    
    
    if (![globalStatus isEqualToString:@"STARTED"] && [flowStatus isEqualToString:@"OPTIONAL"] &&
        ![globalStatus isEqualToString:@"SEARCHING"] ) {//&& self-> statusDestinationTripNormal
        NSLog(@"%sbrahim","ibrahim2");
        statusDestinationTripNormal = false;
        //[self Destination:s_Lat :s_Lng :d_Lat :d_Lng];
        [_mkap clear];
               
               startLocationMarker.map=nil;
               startLocationMarker=[[GMSMarker alloc]init];
               
               endLocationMarker.map=nil;
               endLocationMarker=[[GMSMarker alloc]init];
        
    } else if (([globalStatus isEqualToString:@"STARTED"] ||
               [globalStatus isEqualToString:@"SEARCHING"]) &&
               statusrDestinationSearchOrStart){
        NSLog(@"%sbrahim","ibrahim3");
        
        [self Destination: [NSString stringWithFormat:@"%.8f",
                            CurrentLocation.coordinate.latitude]
                         : [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude]
                         :s_Lat
                         :s_Lng];
        statusrDestinationSearchOrStart = false;
        
    }
    
    
    timerMoveMap +=30;
    NSTimeInterval timeCurent = [[NSDate date] timeIntervalSince1970];
    
    if (timerMoveMap < timeCurent){
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude zoom:16];
        [_mkap animateWithCameraUpdate:[GMSCameraUpdate setTarget:camera.target zoom:16]];
    }
    timerMoveMap -=30;
    
    
}



- (float)angleFromCoordinate:(CLLocationCoordinate2D)first
                toCoordinate:(CLLocationCoordinate2D)second {
    
    float deltaLongitude = second.longitude - first.longitude;
    float deltaLatitude = second.latitude - first.latitude;
    float angle = (M_PI * .5f) - atan(deltaLatitude / deltaLongitude);
    
    if (deltaLongitude > 0)      return angle;
    else if (deltaLongitude < 0) return angle + M_PI;
    else if (deltaLatitude < 0)  return M_PI;
    
    return 0.0f;
}

- (void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 ) {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        NSString*str= [NSString stringWithFormat:@"%d",secondsLeft];
        _timeLbl.text=str;
    } else {
        secondsLeft = 0;
        [audioPlayer stop];
        audioPlayer=nil;
        
        //        locationMapped = false;
        //        moveNextLocation = false;
        //        GMSPolyline *polyline;
        //        polyline.map = nil;
        //        [_mkap clear];
        //        [_navigationBtn setHidden:YES];
        //
        //        startLocationMarker.map=nil;
        //        startLocationMarker=[[GMSMarker alloc]init];
        //
        //        endLocationMarker.map=nil;
        //        endLocationMarker=[[GMSMarker alloc]init];
        //
        //        totalDistance =@"";
        //        TotalM = 0;
        //        TotalKM = 0;
        //
        //        _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
    }
}

-(void)countdownTimer {
    
    secondsLeft = hours = minutes = 0;
    if([_timer isValid]) {
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

-(void)updateLocation:(NSString *)latitude :(NSString *)longitude {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *id = [defaults valueForKey:@"id"];
        
        //   NSString *data = [NSString stringWithFormat:@"{id=%@,deviceId=%@,latitude=%@,longitude=%@}",id,appDelegate.device_UDID,latitude,longitude];
        
        NSDictionary *data3  =  @{@"id":id,
                                  @"deviceId":appDelegate.device_UDID,
                                  @"latitude":latitude,@"longitude":longitude};
                                  
                              
         NSData *data = [NSJSONSerialization dataWithJSONObject:data3 options:NSJSONWritingPrettyPrinted error:nil];
                                  
           NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
            [mqtt pushMassageWithTopic:@"PROD/Provider/Location" message:jsonString];
        } else if (state == UIApplicationStateActive) {
            [mqtt pushMassageWithTopic:@"PROD/Provider/Location" message:jsonString];
        }else {
            
            [mqtt conectMqtt];
            [mqtt pushMassageWithTopic:@"PROD/Provider/Location" message:jsonString];
            
        }
        
        
        
    }
}

- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
{
    myLocation = (CLLocation *)[locations lastObject];
    //    myLocation.altitude =
    
    NSLog(@"latitude: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
    NSLog(@"longitude: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
    
    if  (myLocation.horizontalAccuracy < 40) {
        
       [self updateLocation:[NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude] :[NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]];
        
    }
    
    
    if(!gotLocation)
    {
        gotLocation = true;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                     
                                                                longitude:myLocation.coordinate.longitude
                                                                     zoom:14];
        
        [_mkap animateToCameraPosition:camera];
        [self.view bringSubviewToFront:_currentLocationBtn];
        
    }
    
    CLLocation *loc = locations.lastObject;
    
    //Distance Calc by every latlong
    CurrentLocation =[[CLLocation alloc] initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.longitude];

    if ([travelStatus isEqualToString:@"driving"])
    {
        if (StartLocationTaken == FALSE)
        {
            StartLocationTaken = TRUE;
            StartLocation = [[CLLocation alloc] initWithLatitude:CurrentLocation.coordinate.latitude longitude:CurrentLocation.coordinate.longitude];

            NewLocaton = [[CLLocation alloc] init];
            OldLocation = [[CLLocation alloc] init];

            OldLocation = StartLocation;

        }
        NewLocaton = CurrentLocation;

        if ((NewLocaton.coordinate.latitude == OldLocation.coordinate.latitude) && (NewLocaton.coordinate.longitude == OldLocation.coordinate.longitude))
        {
            NSLog(@"Same location");
        }
        else
        {
            TotalM = TotalM+[NewLocaton distanceFromLocation:OldLocation];
        }

        TotalKM = (TotalM / 1000); //Converting Meters to KM

        OldLocation = NewLocaton;

        totalDistance = @"";
        totalDistance = [NSString stringWithFormat:@"%.2f", TotalKM];

        NSLog(@"totalDistance: %@",[NSString stringWithFormat:@"%.2f KM", TotalKM]);
    }
}

-(IBAction)myLocaton:(id)sender
{
    gotLocation = false;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                 
                                                            longitude:myLocation.coordinate.longitude
                                                                 zoom:14];
    
    [_mkap animateToCameraPosition:camera];
  //  [self currentLocation];
}
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    [self.view bringSubviewToFront:_currentLocationBtn];
    timerMoveMap =  [[NSDate date] timeIntervalSince1970];
}

-(void)onlineView
{
    [self.view bringSubviewToFront:_mapView];
    [self.view bringSubviewToFront:_onlineBtn];
    [self.view bringSubviewToFront:_menuImgBtn];
    [self.view bringSubviewToFront:_menuBtn];
    [self.view bringSubviewToFront:_currentLocationBtn];
    [self.view bringSubviewToFront:_tempLabel];
    [self.view bringSubviewToFront:_tempButton];
    [self.view bringSubviewToFront:_BannerView];
    [_navigationBtn setHidden:YES];
    [_sosBtn setHidden:YES];
    [_offlineImg setHidden:YES];
    
    [_onlineBtn setTitle:LocalizedString(@"GO OFFLINE") forState:UIControlStateNormal];
}

-(void)offlineView
{
    [self.view bringSubviewToFront:_whiteView];
    [self.view bringSubviewToFront:_onlineBtn];
    [self.view bringSubviewToFront:_menuImgBtn];
    [self.view bringSubviewToFront:_menuBtn];
    [self.view bringSubviewToFront:_tempLabel];
    [self.view bringSubviewToFront:_tempButton];
    
    [self.view bringSubviewToFront:_BannerView];
    [_navigationBtn setHidden:YES];
    [_sosBtn setHidden:YES];
    [_offlineImg setHidden:NO];
    [_offlineImg setImage:[UIImage imageNamed:@"icon"]];
    [self.view bringSubviewToFront:_offlineImg];
    
    
    [_onlineBtn setTitle:LocalizedString(@"GO ONLINE") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    MINT_METHOD_TRACE_START
    [CSS_Class APP_Blackbutton:_onlineBtn];
    [CSS_Class APP_Blackbutton:_statusBtn];
    
    [CSS_Class APP_Blackbutton:_rejectBtn];
    [CSS_Class APP_Blackbutton:_acceptBtn];
    
    [CSS_Class APP_Blackbutton:_submitBtn];
    
    _navigationBtn.layer.shadowRadius = 2.0f;
    _navigationBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _navigationBtn.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _navigationBtn.layer.shadowOpacity = 0.5f;
    _navigationBtn.layer.masksToBounds = NO;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_notifyView.frame];
    _notifyView.layer.masksToBounds = NO;
    _notifyView.layer.shadowColor = [UIColor blackColor].CGColor;
    _notifyView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    _notifyView.layer.shadowOpacity = 1.5f;
    _notifyView.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *shadows = [UIBezierPath bezierPathWithRect:_commonRateView.frame];
    _commonRateView.layer.masksToBounds = NO;
    _commonRateView.layer.shadowColor = [UIColor blackColor].CGColor;
    _commonRateView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    _commonRateView.layer.shadowOpacity = 1.5f;
    _commonRateView.layer.shadowPath = shadows.CGPath;
    
    UIBezierPath *shadow = [UIBezierPath bezierPathWithRect:_timerView.bounds];
    _timerView.layer.masksToBounds = NO;
    _timerView.layer.shadowColor = [UIColor grayColor].CGColor;
    _timerView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    _timerView.layer.shadowOpacity = 1.5f;
    _timerView.layer.shadowPath = shadow.CGPath;
    
    _timerView.layer.cornerRadius = _timerView.frame.size.height/2;
    _timerView.clipsToBounds = YES;
    
    _userImg.layer.cornerRadius = _userImg.frame.size.height/2;
    _userImg.clipsToBounds = YES;
    
    _rateUserImg.layer.cornerRadius = _rateUserImg.frame.size.height/2;
    _rateUserImg.clipsToBounds = YES;
    
    
    _paymentBtn.layer.cornerRadius = 5;
    _paymentBtn.clipsToBounds = YES;
    
    
    [CSS_Class APP_textfield_Outfocus:_commentsText];
    MINT_NONARC_METHOD_TRACE_STOP
}

-(IBAction)onlineBtn:(id)sender
{
    [audioPlayer stop];
    globalStatus =@"";
    NSString *status;
    
    if ([_onlineBtn.titleLabel.text isEqualToString:LocalizedString(@"GO ONLINE")])
    {
        status = @"active";
        [self getIncomingRequest];
    }
    else
    {
        status = @"offline";
    }
    
    [self updateAvailablity:status];
}

-(void)updateAvailablity:(NSString *)status
{
    MINT_METHOD_TRACE_START
    if([appDelegate internetConnected])
    {
        params=@{@"service_status":status};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:STATUS withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 if ([response objectForKey:@"error"])
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[response objectForKey:@"error"] viewController:self okPop:NO];
                 }
                 else
                 {
                     //Success
                     NSLog(@"service_status ...%@", response);
                     NSString *first_name = [response valueForKey:@"first_name"];
                     NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                     NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                     
                     NSDictionary *dict = [response valueForKey:@"service"];
                     NSString *serviceStatus = [dict valueForKey:@"status"];
                     
                     if ([serviceStatus isEqualToString:@"active"])
                     {
                         [_mapView setHidden:NO];
                         [_whiteView setHidden:YES];
                         [_onlineBtn setTitle:LocalizedString(@"GO OFFLINE") forState:UIControlStateNormal];
                         [self onlineView];
                     }
                     else
                     {
                         [_mapView setHidden:YES];
                         [_whiteView setHidden:NO];
                         [_onlineBtn setTitle:LocalizedString(@"GO ONLINE") forState:UIControlStateNormal];
                         [self offlineView];
                     }
                     
                     //  NSString *balance =[Utilities removeNullFromString:[response valueForKey:@"balance"]];
                     
                     //  NSString *wallet_id =[Utilities removeNullFromString:[response valueForKey:@"wallet_id"]];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:first_name forKey:@"first_name"];
                     [defaults setObject:avatar forKey:@"avatar"];
                     [defaults setObject:status forKey:@"status"];
                     // [defaults setObject:balance forKey:@"balance"];
                     // [defaults setObject:wallet_id forKey:@"wallet_id"];
                 }
                 
             }
             else
             {
                 if ([strErrorCode intValue]==1)
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
                 else if ([strErrorCode intValue]==2)
                 {
                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                     {
                         //Refresh token
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[error valueForKey:@"error"]  viewController:self okPop:NO];
                     }
                 }
                 else if ([strErrorCode intValue]==3)
                 {
                     if ([error objectForKey:@"email"]) {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"password"]) {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG")  viewController:self okPop:NO];
                     }
                 }
                 else
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG")  viewController:self okPop:NO];
                 }
                 NSLog(@"%@",error);
                 
             }
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    MINT_NONARC_METHOD_TRACE_STOP
}

-(IBAction)menuBtn:(id)sender
{
    if (leftmenuFlag)
    {
        leftmenuFlag = false;
        [leftMenuViewClass setHidden:NO];
        [self LeftMenuView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    UITapGestureRecognizer *tapGesture_condition=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewOuterTap)];
    tapGesture_condition.cancelsTouchesInView=NO;
    tapGesture_condition.delegate=self;
    [self.view addGestureRecognizer:tapGesture_condition];
    
    leftMenuViewClass = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:self options:nil] objectAtIndex:0];
    [leftMenuViewClass setFrame:CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width - 100, self.view.frame.size.height)];
    
    leftMenuViewClass.LeftMenuViewDelegate =self;
    leftMenuViewClass.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:leftMenuViewClass];
    
    [leftMenuViewClass setHidden:YES];
    
    [self setDesignStyles];
    [self LocalizationUpdate];
    [self getProfileDetails:0];
}

static void extracted(HomeViewController *object) {
    [object getProfileDetails:1];
}

-(void)LeftMenuView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        leftMenuViewClass.frame = CGRectMake(0, 0, self.view.frame.size.width - 100,  self.view.frame.size.height);
        
    }];
    waitingBGView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width  ,self.view.frame.size.height)];
    
    [waitingBGView setBackgroundColor:[UIColor blackColor]];
    [waitingBGView setAlpha:0.6];
    [self.view addSubview:waitingBGView];
    [self.view bringSubviewToFront:leftMenuViewClass];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"prograss"];
    [defaults synchronize];
    [leftMenuViewClass awakeFromNib];
    
    extracted(self);
}

- (void)ViewOuterTap
{
    [UIView animateWithDuration:0.3 animations:^{
        
        leftMenuViewClass.frame = CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width - 100,  self.view.frame.size.height);
        
    }];
    leftmenuFlag = true;
    [waitingBGView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch* )touch
{
    if ([touch.view isDescendantOfView:leftMenuViewClass])
    {
        return NO;
    }
    return YES;
}

-(void)yourTripsView
{
    [self ViewOuterTap];
    YourTripViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"YourTripViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}
-(void)summaryView
{
    [self ViewOuterTap];
    SummaryViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

-(void)helpView
{
    [self ViewOuterTap];
    HelpViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:wallet animated:YES completion:nil];
}
-(void)shareView
{
    [self ViewOuterTap];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:[NSURL URLWithString:@"http://taxialaan.com/redirect/store"]];
    [sharingItems addObject:@"\n"];
    [sharingItems addObject:@"Introducer : "];
    [sharingItems addObject:[defaults valueForKey:@"share_key"]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

-(void)profileView
{
    [self ViewOuterTap];
    ProfileViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

-(void)earningsView
{
    [self ViewOuterTap];
    EarningsViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"EarningsViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

-(void)settingsView
{
    [self ViewOuterTap];
    LanguageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageController"];
    controller.page_identifier = @"Profile";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)logOut
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"Alert!") message:LocalizedString(@"Are you sure want to logout?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:LocalizedString(@"NO") style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self logoutMethod];
        
    }];
    [alertController addAction:ok];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)logoutMethod
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *idStr = [defaults valueForKey:@"id"];
        NSDictionary *param = @{@"id":idStr};
        
        NSString *url = [NSString stringWithFormat:@"api/provider/logout"];
        [afn getDataFromPath_NoLoader:url withParamData:param withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                [self ViewOuterTap];
                
                
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                [self.navigationController pushViewController:wallet animated:YES];
            }
            else
            {
                [CSS_Class alertviewController_title:@"Alert" MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
            }
        }];
    }
    else
    {
        [CSS_Class alertviewController_title:LocalizedString(@"Alert") MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
    }
    
}

-(void)wallet
{
    [self ViewOuterTap];
    WalletController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"walletController"];
    [self.navigationController pushViewController:wallet animated:YES];
    
    // [self presentViewController:wallet animated:YES completion:nil];
}

-(IBAction)acceptBtn:(id)sender

{
    [audioPlayer stop];
    audioPlayer=nil;
    
    MINT_METHOD_TRACE_START
    
    if ([_acceptBtn.currentTitle isEqualToString:LocalizedString(@"ARRIVED")])
    {
        [_statusBtn setTitle:LocalizedString(@"ARRIVED") forState:UIControlStateNormal];
        [self statusBtnAction:self];
    }
    else if ([_acceptBtn.currentTitle isEqualToString:LocalizedString(@"PICKEDUP")])
    {
        [_statusBtn setTitle:LocalizedString(@"PICKEDUP") forState:UIControlStateNormal];
        [self statusBtnAction:self];
    }
    else if ([_acceptBtn.currentTitle isEqualToString:LocalizedString(@"ACCEPT")])
    {
        if([appDelegate internetConnected])
        {
            if (isSchedule)
            {
                scheduleStr = @"true";
            }
            else
            {
                scheduleStr = @"false";
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_ID = [defaults valueForKey:@"request_id"];
            
            NSString *url = [NSString stringWithFormat: @"api/provider/trip/%@", request_ID];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:url  withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
             {
                 if (response)
                 {
                     NSLog(@"RESPONSE ...%@", response);
                     
                     if ([scheduleStr isEqualToString:@"true"])
                     {
                         [_statusView setHidden:NO];
                     }
                     else
                     {
                         //                         [_statusView setHidden:YES];
                     }
                     [self getIncomingRequest];
                     
                     [_timerView setHidden:YES];
                 }
                 else
                 {
                     if ([strErrorCode intValue]==1)
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                     }
                     else if ([strErrorCode intValue]==2)
                     {
                         if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                         {
                             //Refresh token
                         }
                         else
                         {
                             [self logoutMethod];
                         }
                     }
                     else if ([strErrorCode intValue]==3)
                     {
                         if ([error objectForKey:@"password"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else
                         {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                         }
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                     }
                     NSLog(@"%@",error);
                     
                 }
             }];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        //Nothing to call
    }
}

-(IBAction)rejectBtn:(id)sender
{
    [audioPlayer stop];
    audioPlayer=nil;
    
    if ([_rejectBtn.currentTitle isEqualToString:LocalizedString(@"CANCEL")])
    {
        [self cancelBtn:self];
    }
    else
    {
        
        MINT_METHOD_TRACE_START
        if([appDelegate internetConnected])
        {
            scheduleStr = @"false";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_ID = [defaults valueForKey:@"request_id"];
            
            NSString *url = [NSString stringWithFormat: @"%@api/provider/trip/%@", SERVICE_URL, request_ID];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:DELETE_METHOD];
            [afn getDataFromPath:url  withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
             {
                 if (response)
                 {
                     NSLog(@"RESPONSE ...%@", response);
                     
                     GMSPolyline *polyline;
                     polyline.map = nil;
                     [_mkap clear];
                     
                     startLocationMarker.map=nil;
                     startLocationMarker=[[GMSMarker alloc]init];
                     
                     endLocationMarker.map=nil;
                     endLocationMarker=[[GMSMarker alloc]init];
                     statusrDestinationSearchOrStart = true;
                     statusDestinationTripNormal = true ;
                     globalStatus = @"";
                     
                     [UIView animateWithDuration:0.45 animations:^{
                         
                         _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                     }];
                 }
                 else
                 {
                     if ([strErrorCode intValue]==1)
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                     }
                     else if ([strErrorCode intValue]==2)
                     {
                         if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                         {
                             //Refresh token
                         }
                         else
                         {
                             [self logoutMethod];
                         }
                     }
                     else if ([strErrorCode intValue]==3)
                     {
                         if ([error objectForKey:@"password"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else
                         {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                         }
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                     }
                     NSLog(@"%@",error);
                     
                 }
             }];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        MINT_NONARC_METHOD_TRACE_STOP
    }
}

- (IBAction)statusBtnAction:(id)sender
{
    MINT_METHOD_TRACE_START
    if ([_statusBtn.currentTitle isEqualToString:LocalizedString(@"ARRIVED")])
    {
        [self updateStatus:@"ARRIVED"];
    }
    else if ([_statusBtn.currentTitle isEqualToString:LocalizedString(@"PICKEDUP")])
    {
        [self updateStatus:@"PICKEDUP"];
    }
    else if ([_statusBtn.currentTitle isEqualToString:LocalizedString(@"DROPPED")])
    {
        [self updateStatus:@"DROPPED"];
    }
    else if ([_statusBtn.currentTitle isEqualToString:LocalizedString(@"COMPLETED")])
    {
        
        [self updateStatus:@"COMPLETED"];
        
        //        [self updateStatus:@"PAYMENT"];
        
        //        [UIView animateWithDuration:0.45 animations:^{
        //
        //            _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
        //
        //            _invoiceView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 300);
        //
        //            _rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
        //
        //            [self.view bringSubviewToFront:_commonRateView];
        //        }];
    }
    MINT_NONARC_METHOD_TRACE_STOP
}

-(void)updateStatus:(NSString *)status
{
    MINT_METHOD_TRACE_START
    if([appDelegate internetConnected])
    {
        if ([status isEqualToString:@"DROPPED"])
        {
            CLGeocoder *ceo = [[CLGeocoder alloc]init];
            [ceo reverseGeocodeLocation:CurrentLocation
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          CLPlacemark *placemark = [placemarks objectAtIndex:0];
                          if (placemark)
                          {
                              NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                              
                              NSLog(@"I am currently at %@",locatedAt);
                              locationString = locatedAt;
                              
                              params = @{@"status":status, @"d_latitude":[NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.latitude], @"d_longitude": [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude], @"distance":totalDistance, @"address":locationString};
                              [self statusUpdateMethod:params];
                          }
                          else {
                              NSLog(@"Could not locate");
                              locationString = @"";
                          }
                      }
             ];
        }
        else
        {
            params = @{@"status":status};
            [self statusUpdateMethod:params];
        }
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)statusUpdateMethod:(NSDictionary*)parameter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *request_ID = [defaults valueForKey:@"request_id"];
    
    NSString *url = [NSString stringWithFormat: @"%@api/provider/trip/%@", SERVICE_URL, request_ID];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:PATCH_METHOD];
    [afn getDataFromPath:url  withParamData:parameter withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
     {
         if (response)
         {
             NSLog(@"RESPONSE ...%@", response);
             [self getIncomingRequest];
         }
         else
         {
             if ([strErrorCode intValue]==1)
             {
                 [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
             }
             else if ([strErrorCode intValue]==2)
             {
                 if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                 {
                     //Refresh token
                 }
                 else
                 {
                     [self logoutMethod];
                 }
             }
             else if ([strErrorCode intValue]==3)
             {
                 if ([error objectForKey:@"password"]) {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                 }
                 else
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
             }
             else
             {
                 [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
             }
             NSLog(@"%@",error);
             
         }
     }];
}


- (IBAction)paymentBtnAction:(id)sender
{
    
    [self paymentCheckProvider];
    [self.view endEditing:YES];
    
    
}
- (IBAction)submitBtnAction:(id)sender
{
    MINT_METHOD_TRACE_START
    if([appDelegate internetConnected])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_ID = [defaults valueForKey:@"request_id"];
        
        NSInteger num=(NSUInteger)(floor(_rating.value));
        NSString*rat=[NSString stringWithFormat:@"%ld",num];
        
        params = @{@"rating":rat,@"comment":_commentsText.text};
        
        NSString *url = [NSString stringWithFormat: @"api/provider/trip/%@/rate", request_ID];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:url  withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 _commentsText.text = @"";
                 _rating.value = 0.00;
                 
                 [UIView animateWithDuration:0.45 animations:^{
                     
                     _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height+20), self.view.frame.size.width,  300);
                     
                     _invoiceView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                     _rateViewView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width+20, 0, self.view.frame.size.width, 300);
                 }];
                 [self myLocaton:self];
                 [self getIncomingRequest];
                 [self getProfileDetails:0];
                 statusrDestinationSearchOrStart = true;
                 statusDestinationTripNormal = true ;
                 globalStatus = @"";
                 
                 
             }
             else
             {
                 if ([strErrorCode intValue]==1)
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
                 else if ([strErrorCode intValue]==2)
                 {
                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                     {
                         //Refresh token
                     }
                     else
                     {
                         [self logoutMethod];
                     }
                 }
                 else if ([strErrorCode intValue]==3)
                 {
                     if ([error objectForKey:@"password"]) {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                     }
                 }
                 else
                 {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
                 NSLog(@"%@",error);
                 
             }
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    MINT_NONARC_METHOD_TRACE_STOP
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_commentsText)
    {
        [_commentsText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}


-(IBAction)navigationBtn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *source_Lat = [defaults valueForKey:@"S_LAT"];
    NSString *source_Lng = [defaults valueForKey:@"S_LNG"];
    
    NSString *des_Lat = [defaults valueForKey:@"D_LAT"];
    NSString *des_Lng = [defaults valueForKey:@"D_LNG"];
    
    NSLog(@"%@, %@, %@, %@", source_Lat, source_Lng, des_Lat, des_Lng);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@,%@&daddr=%@,%@&dirflg=r",source_Lat, source_Lng, des_Lat, des_Lng]];
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://?"]])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSLog(@"Can't use comgooglemaps://");
    }
}

-(void)calculationUpdateMethod
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *request_ID = [defaults valueForKey:@"request_id"];
    
    NSString *url = [NSString stringWithFormat: @"api/provider/trip/%@/calculate", request_ID];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    
    NSDictionary *parameter = @{@"latitude":[NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude]};
    
    [afn getDataFromPath_NoLoader:url withParamData:parameter withBlock:^(id response, NSDictionary *error, NSString *strErrorCode) {
        
        if (response)
        {
            NSLog(@"Calculate RESPONSE ...%@", response);
        }
        else
        {
            if ([strErrorCode intValue]==1)
            {
                [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
            }
            else if ([strErrorCode intValue]==2)
            {
                if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                {
                    //Refresh token
                }
                else
                {
                    [self logoutMethod];
                }
            }
            else if ([strErrorCode intValue]==3)
            {
                if ([error objectForKey:@"password"]) {
                    [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                }
                else
                {
                    [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                }
            }
            else
            {
                [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
            }
            NSLog(@"%@",error);
            
        }
    }];
}


-(IBAction)cancelBtn:(id)sender
{
    if([appDelegate internetConnected])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_ID = [defaults valueForKey:@"request_id"];
        
        NSString *url = [NSString stringWithFormat: @"api/provider/cancel"];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        NSDictionary *param = @{@"id":request_ID};
        [afn getDataFromPath:url  withParamData:param withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"CANCEL RESPONSE ...%@", response);
                 
                 GMSPolyline *polyline;
                 polyline.map = nil;
                 [_mkap clear];
                 
                 startLocationMarker.map=nil;
                 startLocationMarker=[[GMSMarker alloc]init];
                 
                 endLocationMarker.map=nil;
                 endLocationMarker=[[GMSMarker alloc]init];
                 statusrDestinationSearchOrStart = true;
                 statusDestinationTripNormal = true;
                 globalStatus = @"";
                 
                 
                 [UIView animateWithDuration:0.45 animations:^{
                     
                     _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
                 }];
             }
             else
             {
                 if ([strErrorCode intValue]==2)
                 {
                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                     {
                         //Refresh token
                     }
                     else
                     {
                         [self logoutMethod];
                     }
                 }
                 else {
                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
                 NSLog(@"%@",error);
                 
             }
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    MINT_NONARC_METHOD_TRACE_STOP
}

-(IBAction)sosBtnAction:(id)sender
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *sosNumber = [Utilities removeNullFromString:[def valueForKey:@"sos"]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:LocalizedString(@"Are you sure want to Call Emergency?") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:LocalizedString(@"NO") style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([sosNumber isEqualToString:@""])
        {
            //No SOS number was provided
        }
        else
        {
            NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:sosNumber]];
            NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:sosNumber]];
            
            if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
            {
                [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
            }
            else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
            {
                [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"Alert") message:LocalizedString(@"Your device does not support calling") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];    }
        }
        
    }];
    [alertController addAction:ok];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)getProfileDetails:(int)stat
{
    if([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        // appDelegate.viewControllerName = @"Profile";
        [afn getDataFromPath_NoLoader:PROFILE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 
                 NSString *first_name = [response valueForKey:@"first_name"];
                 NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                 
                 NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                 
                 NSString *balance =[NSString stringWithFormat:@"%@",[response valueForKey:@"balance"]];
                 
                 NSString *wallet_id =[NSString stringWithFormat:@"%@",[response valueForKey:@"wallet_id"]];
                 
                 
                 [defaults setObject:first_name forKey:@"first_name"];
                 [defaults setObject:avatar forKey:@"avatar"];
                 [defaults setObject:balance forKey:@"balance"];
                 [defaults setObject:status forKey:@"status"];
                 [defaults setObject:wallet_id forKey:@"wallet_id"];
                 [defaults setObject:response[@"share_key"] forKey:@"share_key"];
                 if (stat == 1) {
                     [defaults setInteger:2 forKey:@"prograss"];
                     [self->leftMenuViewClass awakeFromNib];
                     
                 }
             }
             
         }];
    }
    
}

-(void)getWeather
{
    
    if([appDelegate internetConnected])
    {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval=600;
        
        NSString *URLString = @"http://api.openweathermap.org/data/2.5/weather";
        NSDictionary *parameter = @{@"lat":[NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.latitude], @"lon": [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude],@"units":@"metric",@"appid":@"5f36898450370d957056a3c7dd1a87ed"};
        
        [manager GET:URLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             
             NSDictionary *paymentDict = [responseObject valueForKey:@"main"];
             NSString *AA = [paymentDict valueForKey:@"temp"];
             double latdouble = [AA doubleValue];
             NSLog(@"obk-%.0f",latdouble);
             _tempLabel.text = [NSString stringWithFormat:@"%.0f",latdouble];
             
             
         }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"Error %@",error);
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                 NSLog(@"status code: %li", (long)httpResponse.statusCode);
                 
                 NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                 if (errorData == nil)
                 {
                     
                 }
                 
                 
             }];
        
    }
    
    
    
    
}

-(void)paymentCheckProvider{
    
    
    if ([appDelegate internetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_ID = [defaults valueForKey:@"request_id"];
        NSDictionary *params=@{@"request_id":request_ID,@"cash_amount":_textFieldPayment.text};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:paymentCheck withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [self->appDelegate onEndLoader];
            if (response)
            {
                NSString *need_amount = [response valueForKey:@"need_amount"];
                NSString *pay_methhod = [response valueForKey:@"pay_method"];
                // NSString *trip_price = [response valueForKey:@"trip_price"];
                // NSString *user = [response valueForKey:@"user"];
                NSString *amount_by_cash = [response valueForKey:@"amount_by_cash"];
                NSString *amount_by_wallet = [response valueForKey:@"amount_by_wallet"];
                NSString *transfer = [response valueForKey:@"transfer"];
                NSString *error = [response valueForKey:@"error"];
                
                
                if ([error intValue] == 1){
                    
                    [CSS_Class alertviewController_title:@""  MessageAlert:[NSString stringWithFormat:@"%@ : %@",LocalizedString(@"Balance Is Not Enough."),need_amount] viewController:self okPop:NO];
                    
                }else if ([error intValue] == 2 ){
                    
                    [CSS_Class alertviewController_title:@""  MessageAlert:[NSString stringWithFormat:@"%@ : %@",LocalizedString(@"Amount is Less"),need_amount] viewController:self okPop:NO];
                    
                }else {
                    
                    NSString *message = [NSString stringWithFormat:@"%@ : %@ \n %@ : %@ \n %@ : %@", LocalizedString(@"Pay_By_User_Wallet"),amount_by_wallet,LocalizedString(@"Pay_By_User_In_Cash"),amount_by_cash,LocalizedString(@"Transfer_To_User_Wallet"),transfer];
                    [self showPayDialog:message status:pay_methhod];
                }
                
                
            }
            else
            {
                
                [CSS_Class alertviewController_title:@""  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                
            }
            
        }];
        
    }else{
        
        [CSS_Class alertviewController_title:@""  MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
        
    }
}

- (void)payNow:(NSString*)payment_model {
    
    if ([appDelegate internetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_ID = [defaults valueForKey:@"request_id"];
        NSDictionary *params=@{@"request_id":request_ID,
                               @"cash_amount":_textFieldPayment.text,
                               @"status":@"COMPLETED",
                               @"payment_mode":payment_model,
                               @"d_latitude":[NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.latitude], @"d_longitude": [NSString stringWithFormat:@"%.8f", CurrentLocation.coordinate.longitude]
                               };
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_PAYMENT withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [self->appDelegate onEndLoader];
            if (response)
            {
                
                [CSS_Class alertviewController_title:@"" MessageAlert:[response objectForKey:@"message"] viewController:self okPop:NO];
                
                /* [UIView animateWithDuration:0.3 animations:^{
                 
                 self->_invoiceView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 300);
                 
                 self->_rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                 
                 }];*/
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    // [CommenMethods alertviewController_title:@"" MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                    
                    [CSS_Class alertviewController_title:@""  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
                    //                    [CommenMethods onRefreshToken];
                    [self logOut];
                }
                else if ([errorcode intValue]==2)
                {
                    if ([error objectForKey:@"rating"]) {
                        //  [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"rating"] objectAtIndex:0]  viewController:self okPop:NO];
                        
                        [CSS_Class alertviewController_title:@""  MessageAlert:[[error objectForKey:@"rating"]objectAtIndex:0] viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"comments"]) {
                        // [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"comments"] objectAtIndex:0]  viewController:self okPop:NO];
                        
                        [CSS_Class alertviewController_title:@""  MessageAlert:[[error objectForKey:@"comments"]objectAtIndex:0] viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"is_favorite"]) {
                        
                        [CSS_Class alertviewController_title:@""  MessageAlert:[[error objectForKey:@"is_favorite"] objectAtIndex:0] viewController:self okPop:NO];
                    }
                    
                }
                
            }
            
        }];
    }
    else
    {
        
        [CSS_Class alertviewController_title:@""  MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
        
    }
    
}

-(void)showPayDialog:(NSString*)message status:(NSString*)status {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([status isEqual:@"WALLET"]){
            
            [self payNow:status];
            _textFieldPayment.text = @"";
            
            
        }else if ([status isEqual:@"CASH"]){
            [self payNow:status];
            _textFieldPayment.text = @"";
            
        }else if([status isEqual:@"MIX"]){
            
            [self payNow:status];
            _textFieldPayment.text = @"";
            
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)Destination : (NSString *)sourceLat :(NSString*)sourceLng :(NSString*)destLag:(NSString*)destLng {
    
    NSString *googleUrl = @"https://maps.googleapis.com/maps/api/directions/json";
    NSString *url =   [NSString stringWithFormat:@"%@?origin=%@,%@&destination=%@,%@&sensor=false&waypoints=%@&mode=driving&key=%@", googleUrl, sourceLat,sourceLng,destLag,destLng, @"",GOOGLE_API_KEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error)
      {
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
          
          NSArray *routesArray = [json objectForKey:@"routes"];
          
          if ([routesArray count] > 0)
          {
              [ self->_mkap clear];
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  CLLocationCoordinate2D position = CLLocationCoordinate2DMake([sourceLat doubleValue], [sourceLng doubleValue]);
                  GMSMarker *marker = [GMSMarker markerWithPosition:position];
                  marker.icon = [UIImage imageNamed:@"ic_origin_selected_marker"];
                  marker.map = self->_mkap;
                  
                  
                  CLLocationCoordinate2D position2 = CLLocationCoordinate2DMake([destLag doubleValue], [destLng doubleValue]);
                  GMSMarker *marker2 = [GMSMarker markerWithPosition:position2];
                  marker2.icon = [UIImage imageNamed:@"ic_dest_selected_marker"];
                  marker2.map = self->_mkap;
                  
                  GMSPolyline *polyline = nil;
                  [polyline setMap:nil];
                  NSDictionary *routeDict = [routesArray objectAtIndex:0];
                  NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                  NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                  GMSPath *path = [GMSPath pathFromEncodedPath:points];
                  polyline = [GMSPolyline polylineWithPath:path];
                  polyline.strokeWidth = 3.f;
                  polyline.strokeColor = BLUECOLOR_TEXT;
                  polyline.map = self->_mkap;
                  
                  
                  [self->_mkap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:self->bounds withPadding:80.0f]];
                  
              });
          }
      }] resume];
    
}
@end
