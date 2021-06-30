//
//  AppDelegate.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) NSString *device_tokenStr, *device_UDID, *viewControllerName, *strSmsFrom;

-(BOOL)internetConnected;
-(void)onStartLoader;
-(void)onEndLoader;

@end

