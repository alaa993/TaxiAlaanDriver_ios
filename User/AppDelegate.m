//
//  AppDelegate.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Reachability.h"
//#import <SplunkMint/SplunkMint.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CheckMobiService.h"
#import "LanguageController.h"
#import "IQKeyboardManager.h"
#import <Fabric/Fabric.h>
#import <Firebase/Firebase.h>

//@import GoogleMobileAds;
@import GoogleMaps;
@import GooglePlaces;
//@import SplunkMint;
@class LoadingViewClass;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()
{
    LoadingViewClass *loader;
}
@end

@implementation AppDelegate
@synthesize device_tokenStr, device_UDID, viewControllerName, strSmsFrom;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    [[CheckMobiService sharedInstance] setSecretKey:@"2BA5FF58-BCCA-4160-9C98-6E78BC4ED934"];
  // [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* configureError;
  //  [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
   // [GIDSignIn sharedInstance].delegate = self;
    
    device_tokenStr=@"no device";
    viewControllerName = @"";
    device_UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    [defaults2 setObject:device_UDID forKey:@"deviceId"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenStr = [defaults valueForKey:@"access_token"];
    
    [GMSServices provideAPIKey:@"AIzaSyAR7pmTcGZP5IzIREAqnSY6yAD9xORNH2U"];////AIzaSyBcHWuW9rVEgSBj0W9c9Ks6LEDU1rAlneE
    [GMSPlacesClient provideAPIKey:@"AIzaSyAR7pmTcGZP5IzIREAqnSY6yAD9xORNH2U"];////AIzaSyBcHWuW9rVEgSBj0W9c9Ks6LEDU1rAlneE
   // [Fabric with:@[[Crashlytics class]]];
    
    //[[Mint sharedInstance] disableNetworkMonitoring];
//    [[Mint sharedInstance] initAndStartSessionWithAPIKey:@"dd424d93"];
//    [Mint sharedInstance].applicationEnvironment = SPLAppEnvUserAcceptanceTesting;
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"FirstLoad"] !=nil){
        
        LocalizationSetLanguage([[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageCode"]);
        if (tokenStr == (id)[NSNull null] || tokenStr.length == 0 || [tokenStr isEqualToString:@""])
        {
            
        }
        else
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            HomeViewController* infoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            self.navigationController = [[UINavigationController alloc] initWithRootViewController:infoController];
            self.window.rootViewController = self.navigationController;
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }

        
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:@"Load" forKey:@"FirstLoad"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LanguageController * infoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LanguageController"];
        infoController.page_identifier = @"Appdelegate";
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:infoController];
        self.window.rootViewController = self.navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
    self.navigationController.navigationBar.hidden = YES;
    if (launchOptions != nil)
      {
          // opened from a push notification when the app is closed
          NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
          if (userInfo != nil)
          {
              NSLog(@"userInfoibrahim->%s", "aaaaaaaaa");
              [application registerForRemoteNotifications];
             // [UIApplicationLaunchOptionsKey.remoteNotification]
              [self registerForRemoteNotification];
              
          }
          NSLog(@"userInfoibrahim->%s", "bbbbbbbb");
      }
      else
      {
          NSLog(@"userInfoibrahim->%s", "ccccccccc");
          // opened app without a push notification.
      }
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }

    [application registerForRemoteNotifications];
    [self registerForRemoteNotification];
   
    return YES;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSDictionary *userInfo = notification.request.content.userInfo;

  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Change this to your preferred presentation option
  completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary *userInfo = response.notification.request.content.userInfo;

  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  completionHandler();
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
  completionHandler(UIBackgroundFetchResultNoData);
}
 
- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}



-(BOOL)internetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    
    if((internetStatus == NotReachable) || connectionRequired)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)onStartLoader
{
    loader = [LoadingViewClass new];
    [loader startLoading];
}

-(void)onEndLoader
{
    [loader stopLoading];
}

#pragma mark state preservation / restoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"userInfoibrahim->%s", "willFinishLaunchingWithOptions");
    //[self.window makeKeyAndVisible];
    return YES;
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
   
    //NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    //[[NSUserDefaults standardUserDefaults] setObject: fcmToken forKey:@"device_Token"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:
     //@"FCMToken" object:nil userInfo:dataDict];
    //NSLog(@"FCM registration token: %@", dataDict);
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{ BOOL device;
   // NSLog(@"userInfoibrahim: %@", deviceToken);
    device=YES;
   /* const unsigned *tokenBytes = [deviceToken bytes];
    NSString *tkn = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
    ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
    ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
    ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"userInfoibrahim:tkn %@", tkn);
    NSLog(@"userInfoibrahim->%s", "didRegisterForRemoteNotificationsWithDeviceToken");
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"userInfoibrahim = %@",strDevicetoken);
    device_tokenStr = strDevicetoken;*/
   // [[NSUserDefaults standardUserDefaults] setObject: device_tokenStr forKey:@"device_Token"];
    
    
   /* NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    device_tokenStr = [self hexadecimalStringFromData:deviceToken];
    */
    //[FIRMessaging messaging].APNSToken = deviceToken;
    //NSString *newToken = [deviceToken description];
    //newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  //  newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
  //  NSLog(@"My token is: %@", newToken);
    
   // [FIRMessaging messaging].APNSToken = deviceToken;
    
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeUnknown];
     device_tokenStr = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token123: %@", device_tokenStr);
    
    [[NSUserDefaults standardUserDefaults] setObject: device_tokenStr forKey:@"device_Token"];
    
   // NSLog(@"userInfoibrahimtok: %@", device_tokenStr);
    //[[NSUserDefaults standardUserDefaults] setObject: fcmToken forKey:@"device_Token"];
    //NSLog(@"device token %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"device_Token"]);
}
- (NSString *)hexadecimalStringFromData:(NSData *)deviceToken {
  NSUInteger dataLength = deviceToken.length;
  if (dataLength == 0) {
    return nil;
  }

  const unsigned char *dataBuffer = (const unsigned char *)deviceToken.bytes;
  NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
  for (NSInteger index = 0; index < dataLength; ++index) {
    [hexString appendFormat:@"%02x", dataBuffer[index]];
  }
  return [hexString copy];
}
-(void)showLoadingWithTitle:(NSString *)title
{
    
}

-(void)hideLoadingView
{
}

-(void)addShadowto:(UIView *)view {
    // drop shadow
}
//connected
- (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return (networkStatus != NotReachable);
}
//shared appdelegate
+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
    NSLog(@"userInfoibrahim->%s", "didRegisterUserNotificationSettings");
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    {
        NSLog(@"userInfoibrahim->%s", "didReceiveRemoteNotification");
        NSLog(@"Push Notification Information : %@",userInfo);
    }

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"userInfoibrahim->%s", "didFailToRegisterForRemoteNotificationsWithError");
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10



#pragma mark - Class Methods

/**
 Notification Registration
 */
- (void)registerForRemoteNotification {
    NSLog(@"userInfoibrahim->%s", "registerForRemoteNotification");
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        NSLog(@"userInfoibrahim->%s", "SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO");
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
    
   /* if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
          if( !error ){
              dispatch_async(dispatch_get_main_queue(), ^{
                      [[UIApplication sharedApplication] registerForRemoteNotifications];
              });
          }
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];    }

    //[application registerForRemoteNotifications];
    */





@end
