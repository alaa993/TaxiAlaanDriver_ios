////
////  SocailMediaViewController.m
////  User
////
////  Created by iCOMPUTERS on 12/01/17.
////  Copyright © 2017 iCOMPUTERS. All rights reserved.
////
//
//#import "SocailMediaViewController.h"
//#import "config.h"
//#import "CSS_Class.h"
//#import "AFNHelper.h"
//#import "AFNetworking.h"
//#import "CSS_Class.h"
//#import "AppDelegate.h"
//#import "HomeViewController.h"
//#import "Utilities.h"
//#import "ViewController.h"
//#import "Colors.h"
//#import "ValidateViewController.h"
//
//
//@interface SocailMediaViewController ()
//{
//    NSString *UDID_Identifier;
//}
//@end
//
//@implementation SocailMediaViewController
//{
//    AKFAccountKit *_accountKit;
//    UIViewController<AKFViewController> *_pendingLoginViewController;
//    NSString *_authorizationCode;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [self setDesignStyles];
//    [GIDSignIn sharedInstance].uiDelegate = self;
//    [GIDSignIn sharedInstance].delegate = self;
//    UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    // Do any additional setup after loading the view.
//    
//    // initialize Account Kit
//    if (_accountKit == nil) {
//        // may also specify AKFResponseTypeAccessToken
//        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
//    }
//    
//    // view controller for resuming login
//    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];
//
//}
//
//
//-(void)LocalizationUpdate{
//    _headerLbl.text = LocalizedString(@"Choose an account");
//    _fbLbl.text = LocalizedString(@"Facebook");
//    _googleLbl.text = LocalizedString(@"Google");
//    
//    
//}
//- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
//{
//    loginViewController.delegate = self;
//    // Optionally, you may use the Advanced UI Manager or set a theme to customize the UI.
//    loginViewController.uiManager = [[AKFSkinManager alloc]
//                                     initWithSkinType:AKFSkinTypeTranslucent
//                                     primaryColor:BLACKCOLOR
//                                     backgroundImage:[UIImage imageNamed:@"bg-1536"]
//                                     backgroundTint:AKFBackgroundTintWhite
//                                     tintIntensity:0.32];
//}
//
//- (void)loginWithPhone:(id)sender
//{
//    NSString *inputState = [[NSUUID UUID] UUIDString];
//    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:nil state:inputState];
//    viewController.enableSendToFacebook = YES; // defaults to NO
//    [self _prepareLoginViewController:viewController]; // see below
//    [self presentViewController:viewController animated:YES completion:NULL];
//}
//
//- (void) viewController:(UIViewController<AKFViewController> *)viewController
//didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state
//{
//    //    [self proceedToMainScreen];
//    
//    AKFAccountKit *accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
//    [accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
//        // account ID
//        
//        NSLog(@"accountID ... %@",account.accountID);
//        if ([account.emailAddress length] > 0) {
//            NSLog(@"accountID ... %@",account.emailAddress);
//        }
//        else if ([account phoneNumber] != nil) {
//            NSLog(@"accountID ... %@",[[account phoneNumber] stringRepresentation]);
//            phoneNumberStr =[[account phoneNumber] stringRepresentation];
//        }
//        
//        if([loginByStr isEqualToString:@"FB"])
//        {
//            [self checkFacebook];
//        }
//        else if([loginByStr isEqualToString:@"GOOGLE"])
//        {
//            [self checkGmail];
//        }
//    }];
//    [accountKit logOut];
//}
//
//- (void)                 viewController:(UIViewController<AKFViewController> *)viewController
//  didCompleteLoginWithAuthorizationCode:(NSString *)code
//                                  state:(NSString *)state
//{
//    
//}
//
//- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error
//{
//    // ... implement appropriate error handling ...
//    NSLog(@"%@ did fail with error: %@", viewController, error);
//}
//
//- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController
//{
//    // ... handle user cancellation of the login process ...
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(IBAction)backBtn:(id)sender
//{
//    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
//}
//
//-(void)setDesignStyles
//{
//    [CSS_Class App_subHeader:_headerLbl];
//    [CSS_Class App_subHeader:_fbLbl];
//    [CSS_Class App_subHeader:_googleLbl];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    if ([appDelegate.strSmsFrom isEqualToString:@"validation"])
//    {
//        [self checkFacebook];
//        
//    }
//    else
//    {
//        
//    }
//    [self LocalizationUpdate];
//
//}
//- (IBAction)fbLogin:(id)sender {
//    
//    if ([appDelegate internetConnected])
//    {
//        /*********  logout the current session ************/
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logOut];
//        [FBSDKAccessToken setCurrentAccessToken:nil];
//        [FBSDKProfile setCurrentProfile:nil];
//        /*********  logout the current session ************/
//        
//        /*********  start the new session for login ************/
//        
//        // FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        login.loginBehavior = FBSDKLoginBehaviorWeb;
//        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            if (error) {
//                // Process error
//            } else if (result.isCancelled) {
//                // Handle cancellations
//            }
//            else {
//                
//                if ([result.grantedPermissions containsObject:@"email"]) {
//                    
//                    if ([FBSDKAccessToken currentAccessToken]) {
//                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture.type(normal), accounts{username},email, gender, locale, timezone, about"}]
//                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                             if (!error) {
//                                 NSLog(@"fetched user:%@", result);
//                                 
//                                 fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
//                                 NSLog(@"fbAccessToken=>%@", fbAccessToken);
//                                 
//                                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                                 [user setValue:fbAccessToken forKey:@"FB_ACCESSTOKEN"];
//                                 loginByStr =@"FB";
//                                 [self loginWithPhone:self];
//                                 
////                                 ValidateViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidateViewController"];
////                                 [self.navigationController pushViewController:controller animated:YES];
//                                 
//
//                             }
//                         }];
//                    }
//                }
//            }
//        }];
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
//
//- (IBAction)googleLogin:(id)sender {
//     [[GIDSignIn sharedInstance] signIn];
//}
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    
//}
//- (void)signIn:(GIDSignIn *)signIn
//presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//- (void)signIn:(GIDSignIn *)signIn
//dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
//     withError:(NSError *)error
//{
//    if(!error)
//    {
//        NSString *userId = user.userID;
//        googleAccessToken = user.authentication.accessToken;
//        NSLog(@"%@",userId);
//        NSLog(@"%@",googleAccessToken);
//
//        loginByStr =@"GOOGLE";
//        [self loginWithPhone:self];
//    }
//}
//
//- (void)checkGmail
//{
//    if ([appDelegate internetConnected])
//    {
//        NSDictionary *params=@{@"accessToken":googleAccessToken, @"device_token":appDelegate.device_tokenStr,@"device_id":UDID_Identifier ,@"device_type":@"ios",@"login_by":@"google",@"mobile":phoneNumberStr};
//        
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        
//        [afn getDataFromPath:MD_GOOGLE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
//            if (response)
//        {
//            NSLog(@"RESPONSE ...%@", response);
//            NSString *statusResponse = [response[@"status"]stringValue];
//            if ([statusResponse isEqualToString:@"0"])
//            {
//                
//            }
//            if ([statusResponse isEqualToString:@"1"])
//            {
//                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                [user setValue:response[@"access_token"] forKey:@"access_token"];
//                [user setValue:response[@"currency"] forKey:@"currency"];
//                [user setBool:true forKey:@"isLoggedin"];
//                [self onGetProfile];
//            }
//        }
//        else{
//            NSLog(@"RESPONSE ERROR");
//        }
//            
//        }];
//        
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
//
//- (void)checkFacebook
//{
//    if ([appDelegate internetConnected])
//    {
//        
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSString *strToken = [user valueForKey:@"FB_ACCESSTOKEN"];
//        
//        NSDictionary *params=@{@"accessToken":fbAccessToken, @"device_token":appDelegate.device_tokenStr,@"device_id":UDID_Identifier , @"device_type":@"ios",@"login_by":@"facebook",@"mobile":phoneNumberStr};
//        
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        [afn getDataFromPath:MD_FACEBOOK withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
//            
//            NSLog(@"FB CHECK response:%@", response);
//            
//            NSLog(@"FB CHECK ERROR:%@", error);
//            
////            NSString *statusError = [error[@"status"]stringValue];
//            
//            NSString *statusResponse = [response[@"status"]stringValue];
//            
//            if ([statusResponse isEqualToString:@"0"])
//            {
//                
//            }
//            if ([statusResponse isEqualToString:@"1"])
//            {
//                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                [user setValue:response[@"access_token"] forKey:@"access_token"];
//                [user setValue:response[@"currency"] forKey:@"currency"];
//                [user setBool:true forKey:@"isLoggedin"];
//                [self onGetProfile];
//            }
//        }];
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
//
//- (void)onGetProfile
//{
//    if([appDelegate internetConnected])
//    {
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
//        appDelegate.viewControllerName = @"Profile";
//        [afn getDataFromPath:PROFILE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
//         {
//             if (response)
//             {
//                 NSLog(@"RESPONSE ...%@", response);
//                 NSString *first_name = [response valueForKey:@"first_name"];
//                 NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
//                 NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
//                 
//                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                 [defaults setObject:first_name forKey:@"first_name"];
//                 [defaults setObject:avatar forKey:@"avatar"];
//                 [defaults setObject:status forKey:@"status"];
//                 [defaults setObject:[response valueForKey:@"id"] forKey:@"id"];
//                 [defaults setObject:[response valueForKey:@"sos"] forKey:@"sos"];
//                 
//                HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//                [self.navigationController pushViewController:controller animated:YES];
//             }
//             else
//             {
//                 if ([strErrorCode intValue]==1)
//                 {
//                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
//                 }
//                 else if ([strErrorCode intValue]==2)
//                 {
//                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
//                     {
//                         //Refresh token
//                     }
//                     else
//                     {
//                         [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
//                         ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                         [self.navigationController pushViewController:wallet animated:YES];
//                     }
//                 }
//                 else
//                 {
//                     [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
//                 }
//                 NSLog(@"%@",error);
//             }
//         }];
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CONNECTION")preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}
//@end
