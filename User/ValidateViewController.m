////
////  ValidateViewController.m
////  User
////
////  Created by Veena on 13/07/17.
////  Copyright © 2017 iCOMPUTERS. All rights reserved.
////
//
//#import "ValidateViewController.h"
//#import "CheckMobiService.h"
//#import "Reachability.h"
//#import "MBProgressHUD.h"
//#import "RegisterViewController.h"
//#import "AppDelegate.h"
//#import "config.h"
//#import "SocailMediaViewController.h"
//
//#define kCountryName        @"name"
//#define kCountryCallingCode @"dial_code"
//#define kCountryCode        @"code"
//
//const bool kHangupFirstCallDuringReverseCli = true;
//const bool kShowCheckmobiDetailedMessages = true;
//
//inline static void ShowMessageBox(NSString * title , NSString *message, NSInteger tag, id delegate)
//{
//    UIAlertView * alertView = [[UIAlertView alloc]  initWithTitle:title
//                                                          message:message
//                                                         delegate:delegate
//                                                cancelButtonTitle:LocalizedString(@"OK")
//                                                otherButtonTitles:nil];
//    [alertView setTag:tag];
//    [alertView show];
//}
//
//
//@interface ValidateViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
//
//@property (nonatomic, assign) bool pinStep;
//@property (nonatomic, strong) NSString* validationKey;
//
//@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
//- (void) HandleValidationServiceError:(NSInteger) http_status withBody:(NSDictionary*) body withError:(NSError*) error;
//- (void) PerformPinValidation:(NSString*) key;
//- (void) RefreshGUI;
//
//
//
//@end
//
//@implementation ValidateViewController
//{
//    AppDelegate *appDelegate;
//    UIPickerView *objPickerView;
//    UIToolbar *pickerToolbar;
//    NSArray *countriesList;
//    UITextField *txtSearch;
//}
//@synthesize isFrom;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
//   // appDelegate.strSmsFrom=@"validation";
//    [self RefreshGUI];
//    
//    [self parseJSON];
//    
//    objPickerView =[[UIPickerView alloc]init];
//    objPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    objPickerView.frame = CGRectMake(0.0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
//    //    objPickerView.backgroundColor = [UIColor lightTextColor];
//    
//    objPickerView.delegate = self;
//    objPickerView.dataSource = self;
//    
//    pickerToolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
//    pickerToolbar.barStyle = UIBarStyleDefault;
//    pickerToolbar.tintColor = [UIColor colorWithRed:124/255.0 green:114/255.0 blue:226/255.0 alpha:1.0];;
//    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    
////    txtSearch = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width/2, 30)];
////    txtSearch.backgroundColor=[UIColor whiteColor];
////    [txtSearch setPlaceholder:@"search"];
////    txtSearch.delegate=self;
////    [txtSearch setTextColor:[UIColor lightGrayColor]];
////    [pickerToolbar addSubview:txtSearch];
//    
//    
//    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
//    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton,nil]];
//    
//    _countryCodeTxt.inputView = objPickerView;
//    _countryCodeTxt.inputAccessoryView = pickerToolbar;
//
//
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [self LocalizationUpdate];
//}
//
//
//-(void)LocalizationUpdate{
//    _headerLbl.text = LocalizedString(@"Enter your mobile number");
//    [_resetButton setTitle:LocalizedString(@"Reset") forState:UIControlStateNormal];
//    [_validationButton setTitle:LocalizedString(@"Validate") forState:UIControlStateNormal];
//    _validationPin.placeholder =  LocalizedString(@"Enter Pin");
//    _validationNumber.placeholder = LocalizedString(@"Enter phone Number");
//}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    
//    if (textField == txtSearch)
//    {
//        
//    NSMutableArray *filteredContentList;
//    NSString *searchString = txtSearch.text;
//
//    if([searchString length] != 0)
//    {
//        
//            for(NSString * stringValue in countriesList)
//            {
//                
//                //            NSString * strVideoName = [dictValue objectForKey:@"title"];
//                NSRange VideoNameRange = [[stringValue lowercaseString] rangeOfString:[searchString lowercaseString]];
//                
//                if(VideoNameRange.location != NSNotFound)
//                    [filteredContentList addObject:stringValue];
//            }
//        
//    }
//                //[self searchTableList];
//    else
//    {
//            filteredContentList=[NSMutableArray arrayWithArray:countriesList];
//    }
//    
//  //  [countriesList reloadData];
//
//    }  return YES;
//}
//
//-(IBAction)save:(id)sender
//{
//    [_countryCodeTxt resignFirstResponder];
//
//}
//- (void)parseJSON {
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countryCodes" ofType:@"json"]];
//    NSError *localError = nil;
//    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//    
//    if (localError != nil) {
//        NSLog(@"%@", [localError userInfo]);
//    }
//    countriesList = (NSArray *)parsedObject;
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
//    
//    return 1;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    
//    return 30;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
//    
//    return countriesList.count;
//}
//
//- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    if(_countryFlagImgView.hidden == YES)
//        [_countryCodeTxt setFrame:CGRectMake(60, _countryCodeTxt.frame.origin.y, _countryCodeTxt.frame.size.width-40, _countryCodeTxt.frame.size.height)];
//    
//    [_countryFlagImgView setHidden:NO];
//    
//    NSString *countryCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryCode]];
//    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
//    UIImage *image = [UIImage imageNamed:imagePath];
//    _countryFlagImgView.image = image;
//    
//    NSString *phoneCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryCallingCode]];
//    _countryCodeTxt.text = phoneCode;
//    [_countryCodeTxt setTextColor: [UIColor blackColor]];
////    NSString *countryName = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryName]];
////    _countryCodeTxt.text = countryName;
//    
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UIView *pickerCustomView = [[UIView alloc]initWithFrame:CGRectMake(0,0, objPickerView.frame.size.width, 30)]; //Set desired frame
//    pickerCustomView.backgroundColor = [UIColor clearColor]; //Set desired color or add a UIImageView if you want...
//    
//    NSString *countryCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryCode]];
//    
//    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
//    UIImage *image = [UIImage imageNamed:imagePath];
//    UIImageView *flagImageView = [[UIImageView alloc] initWithImage:image];
//    [flagImageView setFrame:CGRectMake(10, 5, 30, 20)];
//    [pickerCustomView addSubview:flagImageView];
//    
//    NSString *phoneCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryCallingCode]];
//    UILabel *phoneCodeLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, objPickerView.frame.size.width/3-50, 20)];
//    phoneCodeLbl.textAlignment = NSTextAlignmentCenter;
//    phoneCodeLbl.text = phoneCode;
//    [pickerCustomView addSubview:phoneCodeLbl];
//    
//    NSString *countryName = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:row] valueForKey:kCountryName]];
//    UILabel *countryNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(60+phoneCodeLbl.frame.size.width, 5, objPickerView.frame.size.width-(phoneCodeLbl.frame.size.width+flagImageView.frame.size.width+30), 20)];
//    countryNameLbl.textAlignment = NSTextAlignmentLeft;
//    countryNameLbl.text = countryName;
//    [pickerCustomView addSubview:countryNameLbl];
//    
//    return pickerCustomView;
//}
//
//
//- (void) dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidBecomeActiveNotification object:nil];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (IBAction)OnValidate:(id)sender
//{
//    if([[CheckMobiService sharedInstance] secretKey] == nil)
//    {
//        ShowMessageBox(@"Error", @"API secret key is not specified", 0, nil);
//        return;
//    }
//    
//    if(![[Reachability reachabilityForInternetConnection] isReachable])
//    {
//        ShowMessageBox(@"Error", @"No internet connection available!", 0, nil);
//        return;
//    }
//    
//    if(!self.pinStep)
//    {
//        if(self.validationNumber.text.length == 0||self.countryCodeTxt.text == 0)
//        {
//            ShowMessageBox(@"Invalid number", @"Please provide a valid number", 0, nil);
//            return;
//        }
//        
//        [self.validationNumber resignFirstResponder];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//          self.validationNumber.text = [NSString stringWithFormat:@"%@%@",_countryCodeTxt.text,_validationNumber.text];
//        
////        self.val_type = [self GetCurrentValidationType];
//        [[CheckMobiService sharedInstance] RequestValidation:ValidationTypeSMS forNumber:self.validationNumber.text withResponse:^(NSInteger status, NSDictionary* result, NSError* error)
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             
//             NSLog(@"status= %ld result=%@", (long)status, result);
//             
//             if(status == kStatusSuccessWithContent && result != nil)
//             {
//                 NSString* key = [result objectForKey:@"id"];
//                // NSString* type = [result objectForKey:@"type"];
//                 
//               
//                 [_countryCodeTxt setHidden:YES];
//                 
//                 _validationNumber.frame = CGRectMake(30, 95, 260, 40);
//
//                 
//                // strNum = [[result objectForKey:@"validation_info"] objectForKey:@"formatting"];
//                
////                 if([type isEqualToString:kValidationStringCLI])
////                     //[self PerformCliValidation:key withDestinationNr:[result objectForKey:@"dialing_number"]];
////                 else
//                     [self PerformPinValidation:key];
//             }
//             else
//             {
//                 [self HandleValidationServiceError:status withBody:result withError:error];
//             }
//             
//         }];
//    }
//    else
//    {
//        if(self.validationPin.text.length == 0)
//        {
//            ShowMessageBox(@"Invalid pin", @"Please provide a valid pin number", 0, nil);
//            return;
//        }
//        
//        [self.validationPin resignFirstResponder];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        [[CheckMobiService sharedInstance] VerifyPin:self.validationKey withPin:self.validationPin.text withResponse:^(NSInteger status, NSDictionary * result, NSError* error)
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             
//             if(status == kStatusSuccessWithContent && result != nil)
//             {
//                 NSNumber *validated = [result objectForKey:@"validated"];
//                 
//                 if(![validated boolValue])
//                 {
//                     ShowMessageBox(@"Error", @"Invalid PIN!" , 0, nil);
//                     return;
//                 }
//                 
////                 UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Validation" message:@"Successfully Completed" preferredStyle:UIAlertControllerStyleAlert];
////                 UIAlertAction* ok = [UIAlertAction
////                                      actionWithTitle:LocalizedString(@"OK")
////                                      style:UIAlertActionStyleDefault
////                                      handler:^(UIAlertAction * action)
////                                      {
////                                          RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
////                                          controller.isFrom = @"ValidateController";
////                                          controller.phoneText.text=_validationNumber.text;
////                                          
////                                          [self.navigationController pushViewController:alert animated:YES];
//////                                          [alert dismissViewControllerAnimated:YES completion:nil];
////
////                                          
////                                      }];
////                 [alert addAction:ok];
////                 
////                 [self presentViewController:alert animated:YES completion:nil];
//                 
//                   //[self.navigationController pushViewController:alert animated:YES];
//                 NSString *strPhNum = [NSString stringWithFormat:@"%@",_validationNumber.text];
//                 if ([appDelegate.strSmsFrom isEqualToString:@"register"])
//                 {
//                     appDelegate.strSmsFrom=@"validation";
//                     RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
//                     controller.strPhn=strPhNum;
//                     
//                     [self.navigationController pushViewController:controller animated:YES];
//                     
//                 }
//                 else
//                 {
//                     appDelegate.strSmsFrom=@"validation";
//                     SocailMediaViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SocailMediaViewController"];
//                     // controller.isFrom = @"ValidateController";
//                     controller.phnNum=strPhNum;
//                     
//                     [self.navigationController pushViewController:controller animated:YES];
//                     
//                 }
//
//                 [self OnReset:nil];
//             }
//             else
//             {
//                 [self HandleValidationServiceError:status withBody:result withError:error];
//             }
//         }];
//        
//    }
//}
//- (void) PerformPinValidation:(NSString*) key
//{
//    self.validationKey = key;
//    self.pinStep = true;
//   [self RefreshGUI];
//}
//- (IBAction)OnReset:(id)sender
//{
//    self.validationKey = nil;
//    self.pinStep = false;
//    
//    self.validationPin.text = @"";
//    self.validationNumber.text = @"";
//    self.countryCodeTxt.text = @"";
//    
//    [_countryCodeTxt setHidden:NO];
//
//    
//    _validationNumber.frame = CGRectMake(113, 95, 177, 40);
//
//
//
//    [self RefreshGUI];
//
//}
//- (NSString*) ShowDevelopmentMessages:(enum ErrorCode) error
//{
//    switch (error)
//    {
//        case ErrorCodeInvalidPhoneNumber:
//            return  @"Invalid phone number. Please provide the number in E164 format.";
//            
//        case ErrorCodeInvalidApiKey:
//            return @"Invalid API key";
//            
//        case ErrorCodeInsufficientFunds:
//            return @"Insuficient funds. Please recharge your account or subscribe for trial credit";
//            
//        case ErrorCodeInsufficientCliValidations:
//            return  @"No more caller id validations available. Upgrade your account";
//            
//        case ErrorCodeValidationMehodNotAvailableInRegion:
//            return @"Validation method not available for this number";
//            
//        case ErrorCodeInvalidNotificationURL:
//            return @"Invalid notification URL";
//            
//        case ErrorCodeInvalidEventPayload:
//            return @"Invalid event inside the calling action payload";
//            
//        default:
//            return @"Service unavailable. Please try later.";
//    }
//}
//
//- (void) HandleValidationServiceError:(NSInteger) http_status withBody:(NSDictionary*) body withError:(NSError*) error
//{
//    NSLog(@"HandleValidationServiceError: status= %d body: %@ error: %@", (int) http_status, body, error);
//    
//    if(body)
//    {
//        NSString *error_message;
//        enum ErrorCode error = (enum ErrorCode)[[body valueForKey:@"code"] intValue];
//        
//        if(kShowCheckmobiDetailedMessages)
//            error_message = [self ShowDevelopmentMessages:error];
//        else
//        {
//            switch (error)
//            {
//                case ErrorCodeInvalidPhoneNumber:
//                    error_message = @"Invalid phone number. Please provide the number in E164 format.";
//                    break;
//                    
//                default:
//                    error_message = @"Service unavailable. Please try later.";
//            }
//        }
//        
//        ShowMessageBox(@"Error", error_message, 0, nil);
//    }
//    else
//        ShowMessageBox(@"Error", @"Service unavailable. Please try later.", 0, nil);
//}
//
//- (void) RefreshGUI
//{
//    if(self.pinStep)
//        [self.validationButton setTitle:LocalizedString(@"Submit PIN") forState:UIControlStateNormal];
//    else
//        [self.validationButton setTitle:LocalizedString(@"Validate") forState:UIControlStateNormal];
//    
//    self.validationNumber.enabled = !self.pinStep;
//    self.validationPin.hidden = !self.pinStep;
//    self.resetButton.hidden = !self.pinStep;
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
////-(void)onRegister
////{
////    if([appDelegate internetConnected])
////    {
////        NSString* UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
////        NSLog(@"output is : %@", UDID_Identifier);
////        
////        NSDictionary*params;
////        if([strLoginType isEqualToString:@"manual"])
////        {
////            params=@{@"email":_emailText.text,@"password":_passwordText.text,@"first_name":_firstNameText.text,@"last_name":_lastNameText.text,@"mobile":_phoneText.text,@"device_token":appDelegate.strDeviceToken,@"login_by":strLoginType,@"device_type":@"ios", @"device_id":UDID_Identifier};
////        }
////        //        else
////        //        {
////        //            params=@{@"email":_txtEmail.text,@"password":_txtPassword.text,@"first_name":_txtFirstName.text,@"last_name":_txtLastName.text,@"mobile":_txtPhnNo.text,@"device_token":appDelegate.strDeviceToken,@"login_by":strLoginType,@"device_type":@"ios",@"social_unique_id":strSocialUniqueID};
////        //        }
////        
////        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
////        [afn getDataFromPath:MD_REGISTER withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
////            [appDelegate onEndLoader];
////            if(response)
////            {
////                [self onLogin];
////            }
////            else
////            {
////                if ([strCode intValue]==1)
////                {
////                    [CommenMethods alertviewController_title:@"" MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
////                }
////                else
////                {
////                    if ([Error objectForKey:@"email"]) {
////                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
////                    }
////                    else if ([Error objectForKey:@"first_name"]) {
////                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
////                    }
////                    else if ([Error objectForKey:@"last_name"]) {
////                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"last_name"] objectAtIndex:0]  viewController:self okPop:NO];
////                    }
////                    else if ([Error objectForKey:@"mobile"]) {
////                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"mobile"] objectAtIndex:0]  viewController:self okPop:NO];
////                    }
////                    else if ([Error objectForKey:@"password"]) {
////                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
////                    }
////                }
////                
////            }
////        }];
////    }
////    else
////    {
////        
////        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
////    }
////}
//
//@end
