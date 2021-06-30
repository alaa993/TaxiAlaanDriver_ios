//
//  PasswordViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "PasswordViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "HomeViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"
#import "AFNHelper.h"
#import "Utilities.h"
#import "ViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self setDesignStyles];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
//    [_passwordText becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
}

-(void)LocalizationUpdate{
    _helpLbl.text = LocalizedString(@"Enter OTP sent to your mobile number");
    _password_Lbl.text = LocalizedString(@"Resend OTP");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_helpLbl];
    [CSS_Class APP_textfield_Outfocus:_passwordText];
    
    [CSS_Class APP_SocialLabelName:_password_Lbl];
    
    [CSS_Class APP_textfield_custom:_otptxt1];
    [CSS_Class APP_textfield_custom:_otptxt2];
    [CSS_Class APP_textfield_custom:_otptxt3];
    [CSS_Class APP_textfield_custom:_otptxt4];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_otptxt1){
        [_otptxt2 becomeFirstResponder];
    }else if(textField==_otptxt2){
        [_otptxt3 becomeFirstResponder];
    }else if(textField==_otptxt3){
        [_otptxt4 becomeFirstResponder];
    }else if(textField==_otptxt4){
        [_otptxt4 resignFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

//MARK:- TextField Delegate Methods:
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string
{
    if ((textField.text.length < 1) && (string.length > 0)){
        NSInteger nextTag = textField.tag + 1;
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];
        return NO;
    }else if ((textField.text.length >= 1) && (string.length > 0)){  //For Maximum “1” Digit:
        NSInteger nextTag = textField.tag + 1;
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];
        return NO;
    }
    else if ((textField.text.length >= 1) && (string.length == 0)){  //deleting values from textfield:
        NSInteger prevTag = textField.tag - 1;
        UIResponder* prevResponder = [textField.superview viewWithTag:prevTag];
        if (! prevResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (prevResponder)
            [prevResponder becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   // [CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   // [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    
    if(_otptxt1.text.length==0 || _otptxt2.text.length==0 || _otptxt3.text.length==0 || _otptxt4.text.length==0){
        
        [self.view makeToast:LocalizedString(@"OTP_REQ")];
    }else{
        NSString *otpstring = [NSString stringWithFormat:@"%@%@%@%@",_otptxt1.text,_otptxt2.text,_otptxt3.text,_otptxt4.text];
        if ([self.callbackstring isEqualToString:@"signin"]){
            
            [self userlogin:otpstring];
        }else if ([self.callbackstring isEqualToString:@"register"]){
            [self verifyotp:otpstring];
        }
    }
}

-(void)sendotp:(NSString *)mobile{
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
                    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:[response valueForKey:@"message"] viewController:self okPop:NO];
                }else if ([[response valueForKey:@"status"]intValue] == 1){
                    [self.view makeToast:LocalizedString(@"OTP sent to your number")];
                    self->_requestid = [response valueForKey:@"request_id"];

                }
                self->_otptxt1.text = @"";
                self->_otptxt2.text = @"";
                self->_otptxt3.text = @"";
                self->_otptxt4.text = @"";
                /*NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                 [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                 [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                 [user setValue:response[@"refresh_token"] forKey:UD_REFERSH_TOKEN];
                 [user setValue:@"" forKey:UD_SOCIAL];
                 
                 [user setBool:true forKey:@"isLoggedin"];
                 [user synchronize];*/
                
                
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

-(void)verifyotp:(NSString *)opt{
    if([appDelegate internetConnected])
    {
        NSDictionary * params=@{@"otp":opt,@"request_id":_requestid};

        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_VERIFYPIN withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode){
            [appDelegate onEndLoader];
            if(response)
            {
                NSLog(@"response %@",response);
                NSLog(@"response status %d",[[response valueForKey:@"status"]intValue]);
                
                if ([[response valueForKey:@"status"]intValue] == 0){
                    [CSS_Class alertviewController_title:LocalizedString(@"") MessageAlert:[response valueForKey:@"message"] viewController:self okPop:NO];
                }else if ([[response valueForKey:@"status"]intValue] == 1){
                    [self registeruser:opt];
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

-(void)registeruser:(NSString *)otp{
    if([appDelegate internetConnected])
    {
        NSDictionary*params;
        params=@{@"mobile":_mobilenumber,@"request_id":_requestid,@"otp":otp, @"device_type":@"ios", @"device_token":appDelegate.device_tokenStr, @"login_by":@"manual", @"mobile":_mobilenumber, @"first_name":_firstnamestr, @"last_name":_lastnamestr, @"device_id":appDelegate.device_UDID,@"country_code":_countrycodestr,@"service_type":@"",@"service_number":@"",@"service_model":@"",@"email":_email};
        
        NSLog(@"PARAMS...%@", params);
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:REGISTER withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 
                 NSDictionary*params;
                 params=@{@"mobile":[_countrycodestr stringByAppendingString:_mobilenumber],@"request_id":_requestid,@"otp":otp, @"device_token":appDelegate.device_tokenStr,@"device_id":appDelegate.device_UDID , @"device_type":@"ios"};
                 NSLog(@"Parameters ---> %@",params);
                 AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                 
                 [afn getDataFromPath:MD_MOBLOGIN withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
                  {
                      if (response)
                      {
                          NSLog(@"RESPONSE ...%@", response);
                          NSString *access_token = [response valueForKey:@"access_token"];
                          NSString *first_name = [response valueForKey:@"first_name"];
                          NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                          NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                          NSString *currency =[Utilities removeNullFromString:[response valueForKey:@"currency"]];
                          
                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                          [defaults setObject:access_token forKey:@"access_token"];
                          [defaults setObject:first_name forKey:@"first_name"];
                          [defaults setObject:avatar forKey:@"avatar"];
                          [defaults setObject:status forKey:@"status"];
                          [defaults setObject:currency forKey:@"currency"];
                          [defaults setObject:[response valueForKey:@"id"] forKey:@"id"];
                          [defaults setObject:[response valueForKey:@"sos"] forKey:@"sos"];
                          
                          HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                          [self.navigationController pushViewController:controller animated:YES];
                      }
                      else
                      {
                          _passwordText.text = @"";
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

-(void)userlogin:(NSString *)otp{
    if([appDelegate internetConnected])
    {
        NSDictionary*params;
        params=@{@"mobile":_mobilenumber,@"request_id":_requestid,@"otp":otp, @"device_token":appDelegate.device_tokenStr,@"device_id":appDelegate.device_UDID , @"device_type":@"ios"};
        
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
                     NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                     NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                     NSString *currencyStr=[response valueForKey:@"currency"];
                     NSString *socialId=[Utilities removeNullFromString:[response valueForKey:@"social_unique_id"]];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:access_token forKey:@"access_token"];
                     [defaults setObject:first_name forKey:@"first_name"];
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
                 _passwordText.text = @"";
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

-(IBAction)passwordbtn:(id)sender
{
//    ForgotPasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
//    [self presentViewController:controller animated:YES completion:nil];
    [self sendotp:_mobilenumber];
}

-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ShowPass:(UIButton *)sender
{
    if (self.passwordText.secureTextEntry == YES)
    {
        self.passwordText.secureTextEntry = NO;
    }
    else
    {
        self.passwordText.secureTextEntry = YES;
    }
}

@end
