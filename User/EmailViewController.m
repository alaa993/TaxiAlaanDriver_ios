//
//  EmailViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "EmailViewController.h"
#import "PasswordViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "CountryCodeController.h"
#import "AFNHelper.h"
#import "AppDelegate.h"
#import "PasswordViewController.h"

@interface EmailViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation EmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self setDesignStyles];
    
    [self setDefaultValues];
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _validationmobileNumber.leftView = paddingView1;
    _validationmobileNumber.leftViewMode = UITextFieldViewModeAlways;
    
    
    [_emailText becomeFirstResponder];
    
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
    [self.changeCountryBtn setTitle:dialCodeStr forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setValue:dialCodeStr forKey:@"dial_code"];
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
    UIImage *image = [UIImage imageNamed:imagePath];
    _countryFlagImageView.image = image;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
    
    isFlagSet = [[NSUserDefaults standardUserDefaults] valueForKey:@"isFlag"];
    if ([isFlagSet isEqualToString:@"YES"])
    {
        
    }
    else
    {
        dialCodeStr =[[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"];
        NSString *country_flag=[[NSUserDefaults standardUserDefaults] valueForKey:@"country_flag"];
        
        country_flag = [Utilities removeNullFromString:country_flag];
        dialCodeStr = [Utilities removeNullFromString:dialCodeStr];
        
        if ([country_flag isEqualToString:@""])
        {
            
        }
        else
        {
            UIImage *image = [UIImage imageNamed:country_flag];
            _countryFlagImageView.image = image;
        }
        
        [self.changeCountryBtn setTitle:dialCodeStr forState:UIControlStateNormal];
    }
}

-(void)LocalizationUpdate{
    _helpLbl.text = LocalizedString(@"What's your email address?");
    _register_Lbl.text = LocalizedString(@"I need to create an account");
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_helpLbl];
    [CSS_Class APP_textfield_Outfocus:_emailText];
    [CSS_Class APP_SocialLabelName:_register_Lbl];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_emailText)
    {
        [_emailText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidBecomeActiveNotification object:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   // [CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _validationmobileNumber)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= INPUTLENGTH || returnKey;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //[CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    emailString = @"true";
    
    if (self.validationmobileNumber.text.length==0) {
        
        [self.view makeToast:LocalizedString(@"ENTERMOBILE")];
        
    }else if (self.validationmobileNumber.text.length > 15){
        
        [self.view makeToast:LocalizedString(@"VALIDATEMOBILE")];
    }
    else
    {
        [self signinService];
    }
}

-(void)signinService{
    
    NSString *phonenumber = [NSString stringWithFormat:@"%@%@",dialCodeStr,_validationmobileNumber.text];
    
    if(phonenumber.length != 0)
    {
        NSString *emailRegEx =@"^((\\+)|(00))[0-9]{6,14}$";
        
        NSPredicate *regExPredicate =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:phonenumber];
        
        if(myStringMatchesRegEx)
        {
            emailString = @"true";
        }
        else
        {
            emailString = @"false";
        }
    }
    
    if(_validationmobileNumber.text.length==0)
    {
        emailString = false;
        
        [self.view makeToast:LocalizedString(@"MOBILE_REQ")];
    }
    else if ([emailString isEqualToString:@"false"])
    {
        emailString = false;
        
        [self.view makeToast:LocalizedString(@"MOBILE_INVALID")];
    }
    if ([emailString isEqualToString:@"true"])
    {
        //appDelegate.strEmail=_emailText.text;
        [self sendotp:phonenumber];
        //PasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
        // controller.callbackstring = @"signin";
        //[self.navigationController pushViewController:controller animated:YES];
        
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
                    PasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
                    controller.requestid = response[@"request_id"];
                    controller.mobilenumber = mobile;
                    controller.callbackstring = @"signin";
                    controller.firstnamestr = @"";
                    controller.lastnamestr = @"";
                    controller.email = @"";
                    controller.countrycodestr = @"";
                    [self.navigationController pushViewController:controller animated:YES];
                }
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

- (IBAction)changeCountryBtnAction:(id)sender
{
    CountryCodeController *country = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryCodeController"];
    [self presentViewController:country animated:YES completion:nil];
}


-(IBAction)RegisterBtn:(id)sender
{
    RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
