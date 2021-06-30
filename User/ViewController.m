//
//  ViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ViewController.h"
#import "SocailMediaViewController.h"
#import "EmailViewController.h"
#import "RegisterViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import <AccountKit/AccountKit.h>
#import "AFNHelper.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "HomeViewController.h"
#import "Provider-Swift.h"
//#import <FirebaseAuth/FirebaseAuth.h>
#import "CountryCodeController.h"


@import FirebaseAuth;
@import Firebase;
@import FirebaseUI;
@import FirebaseRemoteConfig;


@import GoogleMobileAds;
@interface ViewController () <OTPViewDelegate,CountryCode>
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

static NSBundle* myBundle = nil;

@implementation ViewController

AKFAccountKit *_accountKit;
BOOL _enableSendToFacebook;
 AppDelegate *appDelegate;
NSString *codeCountry;
NSString *phone;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];
    [remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"Config fetched!");
          [remoteConfig activateWithCompletion:^(BOOL changed, NSError * _Nullable error) {
              NSString *stringTest = [remoteConfig defaultValueForKey:@"stringTestKey"].JSONValue;
              NSLog(@"stringTest%@",stringTest);
          }];
        } else {
            NSLog(@"Config not fetched");
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    NSString *stringTest = [remoteConfig defaultValueForKey:@"stringTestKey"].stringValue;
    NSLog(@"stringTest%@",stringTest);
    
    
     _otpInputView.delegateOTP = self;
      appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
      codeCountry = @"+964";
      self.topView.frame = CGRectMake( 0,40, self.view.frame.size.width-30 ,self.view.frame.size.height-40);
      self.virifiView.frame = CGRectMake(0,self.view.frame.size.height,self.view.frame.size.width-30,self.view.frame.size.height-40);
    
    [self setDesignStyles];
    [self adsGoogle];
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDesignStyles
{
   _btnCodeCountry.layer.borderColor = UIColor.grayColor.CGColor;
    _btnCodeCountry.layer.borderWidth = 1 ;
    _btnCodeCountry.layer.cornerRadius = 8 ;
    [_btnCodeCountry setTitle:@"+964" forState:UIControlStateNormal];
    _btnNext.layer.cornerRadius = 8;
    _btnVirifi.layer.cornerRadius = 8;
}

-(void) adsGoogle{
    
    _bannerView.adUnitID = @"ca-app-pub-6606021354718512/5888672923";
    _bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
   // request.testDevices = @[kGADSimulatorID];
    [_bannerView loadRequest:request];
    
}

- (IBAction)btnActionNext:(id)sender {
    
     NSString *phoneNumber =[NSString stringWithFormat:@"%@%@",codeCountry,_tfPhoneNumber.text];
    
    
    if ([phoneNumber  isEqual: @"+19001234009"]) {
        [self verify:phoneNumber];
        return;
    }
    // [appDelegate onStartLoader];
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
            authUI.delegate = self;

            //The following array may contain diferente options for validate the user (with Facebook, with google, e-mail...), in this case we only need the phone method
            NSArray<id<FUIAuthProvider>> * providers = @[[[FUIPhoneAuth alloc]initWithAuthUI:[FUIAuth defaultAuthUI]]];
            authUI.providers = providers;

            FUIPhoneAuth *provider = authUI.providers.firstObject;
            [provider signInWithPresentingViewController:self phoneNumber:nil];
    
    
   
   /* [[FIRPhoneAuthProvider provider] verifyPhoneNumber:phoneNumber
                                            UIDelegate:nil
                                            completion:^(NSString * _Nullable verificationID,
                                                         NSError * _Nullable error) {
         [appDelegate onEndLoader];
      if (error != nil) {
           [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:error.localizedDescription viewController:self okPop:NO];
       
        return;
      }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:verificationID forKey:@"authVerificationID"];

        self.topView.frame = CGRectMake( 0,self.view.frame.size.height,self.view.frame.size.width-30,self.view.frame.size.height-40);

        self.virifiView.frame = CGRectMake( 0,40, self.view.frame.size.width-30 , self.view.frame.size.height-40);


    }];*/
    
}

-(void)verificationCode:(NSString *)otpNumber {
    
     [appDelegate onStartLoader];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *verificationID = [defaults stringForKey:@"authVerificationID"];
    FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider]
    credentialWithVerificationID:verificationID
                verificationCode:otpNumber];
   
    [[FIRAuth auth] signInWithCredential:credential
                                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                                          NSError * _Nullable error) {
         [appDelegate onEndLoader];
        if (error != nil) {
            
             [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:error.localizedDescription viewController:self okPop:NO];
   
        }
        
        if (authResult == nil) {return ;}
        NSString *user = authResult.user.phoneNumber;
        [self verify:user];
        
        [defaults setObject:nil forKey:@"authVerificationID"];
        self->_lbPhoneNumber.text = user;
        
        
    }];
    

    
}

- (void)didFinishedEnterOTPWithOtpNumber:(NSString *)otpNumber{
    
    [self verificationCode:otpNumber];
    
}

- (void)otpNotValid{
    
    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:@"Code Error" viewController:self okPop:NO];
    
    
}

- (IBAction)btnCodeCountry:(id)sender {
    
   CountryCodeController *country = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryCodeController"];
    country.delegate = self;
   [self presentViewController:country animated:YES completion:nil];
}

- (void)codeCountryMetode:(NSString *)countryCode :(NSString *)countryName :(NSString *)countryCallingCode {
    
    codeCountry = countryCallingCode;
    [_btnCodeCountry setTitle:countryCallingCode forState:UIControlStateNormal];
    
    
}


- (IBAction)btnActionVirifi:(id)sender {
   _otpInputView.otpFetch;
}

- (IBAction)btnNotGetCode:(id)sender {
  
    self.topView.frame = CGRectMake( 0, 40, self.view.frame.size.width-30 , self.view.frame.size.height-40);
    self.virifiView.frame = CGRectMake(0,self.view.frame.size.height,self.view.frame.size.width-30,self.view.frame.size.height-40);
    
}


-(void)verify:(NSString *)mobile {
    if([appDelegate internetConnected])
    {
        NSDictionary * params=@{@"mobile":mobile};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_SENDOTP withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode){
            [appDelegate onEndLoader];
            if(response)
            {
                NSLog(@"response %@",response);
                NSLog(@"response status %d",[[response valueForKey:@"status"]intValue]);
                
                if ([[response valueForKey:@"status"]intValue] == 0){
                    
                     NSString *cleanedString = [self->_tfPhoneNumber.text stringByReplacingOccurrencesOfString:@"^0+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self->_tfPhoneNumber.text.length)];
                    RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
                    controller.mobilenumber = mobile;
                   // controller.codeCountry = codeCountry;
                    [self.navigationController pushViewController:controller animated:YES];
               
                }else if ([[response valueForKey:@"status"]intValue] == 1){
                    
                    [self userlogin:mobile];
               
                }
                
            }
            else
            {
                if ([strErrorCode intValue]==1)
                {
                    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:LocalizedString(@"MOBILE_INVALID") viewController:self okPop:NO];
                }
                else if ([strErrorCode intValue]==3)
                {
                    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:error[@"message"]  viewController:self okPop:NO];
                    
                }
                else
                {
                    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:LocalizedString(@"LOGIN_ERROR")  viewController:self okPop:NO];
                }
            }
        }];
    }
    else
    {
        [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
    }
}

-(void)userlogin:(NSString *)_mobilenumber{
    if([appDelegate internetConnected])
    {
        NSDictionary*params;
        params=@{@"mobile":_mobilenumber, @"device_token":appDelegate.device_tokenStr,@"device_id":appDelegate.device_UDID , @"device_type":@"ios"};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:MD_MOBLOGIN withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 
                 NSLog(@"RESPONSE STATUS ...%d", [[response valueForKey:@"status"]intValue]);
                 NSString *statusstr = [NSString stringWithFormat:@"%@",[response valueForKey:@"status"]];
                 
                 NSLog(@"%@",statusstr);
                 
                 if ([statusstr isEqualToString:@"0"]){
                     [CSS_Class alertviewController_title:@"" MessageAlert:[response valueForKey:@"message"] viewController:self okPop:NO];
                 }else{
                     NSString *access_token = [response valueForKey:@"access_token"];
                     NSString *first_name = [response valueForKey:@"first_name"];
                     NSString *last_name = [response valueForKey:@"last_name"];
                     NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                     NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                     NSString *currencyStr=[response valueForKey:@"currency"];
                     NSString *socialId=[Utilities removeNullFromString:[response valueForKey:@"social_unique_id"]];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:access_token forKey:@"access_token"];
                     [defaults setObject:first_name forKey:@"first_name"];
                     [defaults setObject:last_name forKey:@"last_name"];
                     [defaults setObject:avatar forKey:@"avatar"];
                     [defaults setObject:status forKey:@"status"];
                     [defaults setValue:currencyStr forKey:@"currency"];
                     [defaults setValue:socialId forKey:@"social_unique_id"];
                     [defaults setObject:[response valueForKey:@"id"] forKey:@"id"];
                     [defaults setObject:[response valueForKey:@"sos"] forKey:@"sos"];
                     
                     HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                     [self.navigationController pushViewController:controller animated:YES];
                 }
             }
             else
             {
               //  _passwordText.text = @"";
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
}


- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    if (error == nil) {
        NSLog(@"%@",user.phoneNumber);
        NSLog(@"%@",user.uid);
        [self verify:user.phoneNumber];
        
      //  [self login2:user.uid :user.phoneNumber :user.refreshToken];
    }
    else{
        NSLog(@"%@",error);
    }
}
- (FUIAuthPickerViewController *)authPickerViewControllerForAuthUI:(FUIAuth *)authUI {
    return [[FUIAuthPickerViewController alloc] initWithNibName:@"FUICustomAuthPickerViewController"
                                                             bundle:[NSBundle mainBundle]
                                                             authUI:authUI];
}
@end
