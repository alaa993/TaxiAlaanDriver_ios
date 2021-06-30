//
//  RegisterViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "RegisterViewController.h"
#import "CSS_Class.h"
#import "EmailViewController.h"
#import "config.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "HomeViewController.h"
#import "AFNHelper.h"
#import "Colors.h"
#import "ViewController.h"
#import "Utilities.h"
#import "ValidateViewController.h"
#import "PasswordViewController.h"
#import "CountryCodeController.h"
@import GoogleMobileAds;
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation RegisterViewController
{
   
    NSString *emailStr, *firstNameStr, *lastNameStr, *passwordStr, *confirmPass,*code;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.strSmsFrom=@"register";
    
    
    [_detailsScrollView setContentSize:[_detailsScrollView frame].size];
    [_detailsScrollView setKeyboardAvoidingEnabled:YES];
    
    _RegcountrycodeTF.hidden = true;
    _RegcountryflagImgeView.hidden = true;

    [self setDesignStyles];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailStr = [defaults valueForKey:@"Email"];
    
    [self setDefaultValues];
    [self adsGoogle];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LocalizationUpdate];
}

-(void)LocalizationUpdate{
    _headerLbl.text = LocalizedString(@"Enter the details to register");
    _emailLbl.text = LocalizedString(@"Enter mobile number");
    _firstNameLbl.text = LocalizedString(@"Name");
    _firstNameText.placeholder =LocalizedString(@"First name");
    _lastNameText.placeholder =LocalizedString(@"Last name");
    _passwordLbl.text = [NSString stringWithFormat:@"%@%@", LocalizedString(@"E-mail") , LocalizedString(@"optional")];
    _confirmPassLbl.text = LocalizedString(@"Confirm password");
    _phoneLbl.text = LocalizedString(@"Phone Number");
    
    _emailText.text = _mobilenumber;
    _emailText.enabled = NO;
    
    _textFieldCode.placeholder = LocalizedString(@"IntroducerCode");
    _labelCode.text = LocalizedString(@"IntroducerCode");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_headerLbl];
    [CSS_Class APP_textfield_Outfocus:_emailText];
    [CSS_Class APP_textfield_Outfocus:_firstNameText];
    [CSS_Class APP_textfield_Outfocus:_RegcountrycodeTF];
    [CSS_Class APP_textfield_Outfocus:_lastNameText];
    [CSS_Class APP_textfield_Outfocus:_passwordText];
    [CSS_Class APP_textfield_Outfocus:_phoneText];
    [CSS_Class APP_textfield_Outfocus:_confirmPasswordText];
     [CSS_Class APP_textfield_Outfocus:_textFieldCode];
    
    
    [CSS_Class APP_labelName_Small:_emailLbl];
    [CSS_Class APP_labelName_Small:_firstNameLbl];
    [CSS_Class APP_labelName_Small:_lastNameLbl];
    [CSS_Class APP_labelName_Small:_passwordLbl];
    [CSS_Class APP_labelName_Small:_phoneLbl];
    [CSS_Class APP_labelName_Small:_confirmPassLbl];
    [CSS_Class APP_labelName_Small:_labelCode];
    
    _emailText.placeholder = LocalizedString(@"PHN_NO");
    _passwordText.placeholder = LocalizedString(@"EMAIL_EG");

}

-(void) adsGoogle{
    
    _bannerView.adUnitID = @"ca-app-pub-6606021354718512/5888672923";
    _bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[kGADSimulatorID];
    [_bannerView loadRequest:request];
    
}

-(IBAction)backBtn:(id)sender
{
    EmailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_emailText)
    {
        [_firstNameText becomeFirstResponder];
    }
    else if(textField==_firstNameText)
    {
        [_lastNameText becomeFirstResponder];
    }
    else if(textField==_lastNameText)
    {
        [_passwordText becomeFirstResponder];
    }
    else if(textField==_passwordText)
    {
        [_confirmPasswordText becomeFirstResponder];
    }
    else if(textField==_confirmPasswordText)
    {
        [_confirmPasswordText resignFirstResponder];
    }
//    else if(textField==_carNumberText)
//    {
//        [_carNumberText resignFirstResponder];
//    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _emailText) || (textField == _firstNameText) || (textField == _lastNameText))
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= INPUTLENGTH || returnKey;
    }
    else if (textField == _phoneText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PHONELENGTH || returnKey;
    }
    else
    {
        return YES;
    }
    return NO;
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

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    
    if((_emailText.text.length==0) || (_firstNameText.text.length==0) || (_lastNameText.text.length==0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please fill all the details" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
   // }else if (([self validatePhoneWithString:[NSString stringWithFormat:@"%@%@%@", @"+", _codeCountry,_mobilenumber]] == NO) || (self.emailText.text.length > 15)){
     //   [self.view makeToast:LocalizedString(@"VALIDATEMOBILE")];
        
    }
    else
    {
        emailStr=_emailText.text;
        passwordStr=_passwordText.text;
        firstNameStr=_firstNameText.text;
        lastNameStr=_lastNameText.text;
        confirmPass=_confirmPasswordText.text;
        code = _textFieldCode.text;
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:emailStr forKey:@"email"];
        [user setObject:passwordStr forKey:@"password"];
        [user setObject:firstNameStr forKey:@"firstName"];
        [user setObject:lastNameStr forKey:@"lastName"];
        [user setObject:confirmPass forKey:@"ConfirmPass"];
        [self registeruser:_mobilenumber];
     
    }
}

- (void)setDefaultValues
{
    [self parseJSON];
    
    dialCodeStr = @"";
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"country code %@",countryCode);
    
    for (int i=0; i<countriesList.count; i++)
    {
        NSDictionary *countryDict = [countriesList objectAtIndex:i];
        
        NSString *code = [countryDict valueForKey:@"code"];
        
        if ([code isEqualToString:countryCode])
        {
            dialCodeStr = [countryDict valueForKey:@"dial_code"];
        }
    }
    _RegcountrycodeTF.text = dialCodeStr;
    [[NSUserDefaults standardUserDefaults] setValue:_codeCountry forKey:@"dial_code"];
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
    UIImage *image = [UIImage imageNamed:imagePath];
    _RegcountryflagImgeView.image = image;
    isFlagSet = @"YES";
    [[NSUserDefaults standardUserDefaults] setValue:isFlagSet forKey:@"isFlag"];
}

- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"countryCodes" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    countriesList = (NSArray *)parsedObject;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validatePhoneWithString:(NSString*)phone
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}


-(void)registeruser:(NSString *)_mobilenumber{
    
   
    if([appDelegate internetConnected])
    {
        NSDictionary*params;
        params=@{@"mobile":_mobilenumber,
                 @"device_type":@"ios",
                 @"device_token":appDelegate.device_tokenStr,
                 @"login_by":@"manual",
                 @"mobile":_mobilenumber,
                 @"first_name":firstNameStr,
                 @"last_name":lastNameStr,
                 @"device_id":appDelegate.device_UDID,
                // @"country_code":[NSString stringWithFormat:@"%@",_codeCountry],
                 @"service_type":@"",
                 @"service_number":@"",
                 @"service_model":@"",
                 @"email":passwordStr,
                 @"share_key": code,
                 @"app_version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                 };
        
        NSLog(@"PARAMS...%@", params);
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:REGISTER withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 NSLog(@"ttttttt1...%s", "ssssssss");
                 NSDictionary*params;
                 params=@{@"mobile":_mobilenumber,
                          @"device_token":appDelegate.device_tokenStr,
                          @"device_id":appDelegate.device_UDID ,
                          @"device_type":@"ios"};
                 NSLog(@"Parameters ---> %@",params);
                 NSLog(@"ttttttt2...%s", "ssssssss");
                 AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                 
                 [afn getDataFromPath:MD_MOBLOGIN withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
                  {
                      if (response)
                      {
                          
                         
                          NSLog(@"RESPONSE ...%@", response);
                          NSLog(@"ttttttt3...%s", "ssssssss");
                          
                          NSString *access_token = [response valueForKey:@"access_token"];
                          NSLog(@"ttttttt5...%s", "ssssssss");
                          NSString *first_name = [response valueForKey:@"first_name"];
                          NSLog(@"ttttttt6...%s", "ssssssss");
                          NSString *avatar =@"";//[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                          NSLog(@"ttttttt7...%@", [Utilities removeNullFromString:[response valueForKey:@"status"]]);
                          
                          
                          NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                          NSLog(@"ttttttt8...%s", "tttttttt");
                          NSString *currency =[Utilities removeNullFromString:[response valueForKey:@"currency"]];
                          NSLog(@"ttttttt9...%s", "ssssssss");
                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                          
                          [defaults setObject:access_token forKey:@"access_token"];
                          [defaults setObject:first_name forKey:@"first_name"];
                          [defaults setObject:avatar forKey:@"avatar"];
                          [defaults setObject:status forKey:@"status"];
                          [defaults setObject:currency forKey:@"currency"];
                          [defaults setObject:[response valueForKey:@"id"] forKey:@"id"];
                         ;
                          [defaults setObject:[response valueForKey:@"sos"] forKey:@"sos"];
                          [defaults setObject:response[@"share_key"] forKey:@"share_key"];
                          NSLog(@"Ressssssss3", "rssssssss3");
                          HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                          [self.navigationController pushViewController:controller animated:YES];
                          }
                      else
                      {
                         // _passwordText.text = @"";
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
                                  [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                                  ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                                  [self.navigationController pushViewController:wallet animated:YES];
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
                 if ([strErrorCode intValue]==1)
                 {
                     [CSS_Class alertviewController_title:@"" MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                 }
                 else if ([strErrorCode intValue]==2)
                 {
                     if ([[error valueForKey:@"error"] isEqualToString:@"token_expired"])
                     {
                         //Refresh token
                     }
                     else
                     {
                         [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                         ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                         [self.navigationController pushViewController:wallet animated:YES];
                     }
                 }
                 else if ([strErrorCode intValue]==3)
                 {
                     if ([error objectForKey:@"email"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"first_name"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"last_name"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"last_name"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"mobile"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"mobile"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"password"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else if ([error objectForKey:@"password_confirmation"]) {
                         [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"password_confirmation"] objectAtIndex:0]  viewController:self okPop:NO];
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:@"Error!" MessageAlert:@"Please try again later"  viewController:self okPop:NO];
                     }
                 }
                 else
                 {
                     [CSS_Class alertviewController_title:@"Error!" MessageAlert:@"Please try again later"  viewController:self okPop:NO];
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

@end
