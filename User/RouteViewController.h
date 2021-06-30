//
//  RouteViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 06/02/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@import GoogleMaps;

@interface RouteViewController : UIViewController <UIWebViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

{
    NSString *pickup_addressStr, *delivery_addressStr;
}
@property (nonatomic, retain) IBOutlet UIWebView *webViewCtrl;
@property (weak, nonatomic) IBOutlet UILabel *haderLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
