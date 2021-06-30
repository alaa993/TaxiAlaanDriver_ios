//
//  ProfileViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ProfileViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AFNHelper.h"
#import "Utilities.h"
#import "ChangePasswordViewController.h"
#import "HomeViewController.h"
#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LanguageController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [_detailsScrollView setContentSize:[_detailsScrollView frame].size];
    [_detailsScrollView setKeyboardAvoidingEnabled:YES];
    
    _imageBtn.layer.cornerRadius=_imageBtn.frame.size.height/2;
    _imageBtn.clipsToBounds=YES;
    
    _profileImage.layer.cornerRadius=_profileImage.frame.size.height/2;
    _profileImage.clipsToBounds=YES;
    
    [self getProfileDetails];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //    [_passwordText becomeFirstResponder];
}

-(void)LocalizationUpdate{
    
    _headerLbl.text = LocalizedString(@"Edit profile");
    _firstNameLb.text = LocalizedString(@"First");
    _lastNameLb.text = LocalizedString(@"Last");
    _phoneLb.text = LocalizedString(@"Phone Number");
    _emailtLb.text = LocalizedString(@"E-mail");
    _serviceLb.text = LocalizedString(@"Service");
    [_saveBtn setTitle:LocalizedString(@"SAVE") forState:UIControlStateNormal];
    [_passwordBtn setTitle:LocalizedString(@"CHANGE PASSWORD") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [self setDesignStyles];
    [self LocalizationUpdate];

}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_firstNameLb];
    [CSS_Class APP_labelName:_lastNameLb];
    [CSS_Class APP_labelName:_phoneLb];
    [CSS_Class APP_labelName:_emailtLb];
    [CSS_Class APP_labelName:_serviceLb];
    [CSS_Class APP_fieldValue:_emailValueLb];
    [CSS_Class APP_fieldValue:_serviceValueLb];

    
    [CSS_Class APP_Blackbutton:_saveBtn];
    [CSS_Class APP_Blackbutton:_passwordBtn];
    
}

-(void)getProfileDetails
{
    if([appDelegate internetConnected])
        {
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
            appDelegate.viewControllerName = @"Profile";
            [afn getDataFromPath:PROFILE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
             {
                 if (response)
                 {
                     NSLog(@"RESPONSE ...%@", response);
                     NSString *avatar = [Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                     _emailValueLb.text = [Utilities removeNullFromString:[response valueForKey:@"email"]];
                     _firstNameText.text = [Utilities removeNullFromString:[response valueForKey:@"first_name"]];
                     _lastNameText.text = [Utilities removeNullFromString:[response valueForKey:@"last_name"]];
                     _phoneText.text = [Utilities removeNullFromString:[response valueForKey:@"mobile"]];
                     
                     NSDictionary *serviceDict = [response valueForKey:@"service"];
                     NSDictionary *nameDict = [serviceDict valueForKey:@"service_type"];
                     _serviceValueLb.text = [Utilities removeNullFromString:[nameDict valueForKey:@"name"]];
                     
                     if (![response[@"avatar"] isKindOfClass:[NSNull class]])
                     {
//                         NSString *socialIdStr = [Utilities removeNullFromString:[response valueForKey:@"social_unique_id"]];
                        
                         if ([avatar containsString:@"http"])
                         {
                             NSURL *socialUrl = [NSURL URLWithString:avatar];
                             NSData *data = [NSData dataWithContentsOfURL:socialUrl];
                             UIImage *image = [UIImage imageWithData:data];
                             [_profileImage setImage:image];
                         }
                         else
                         {
                             avatar = [NSString stringWithFormat:@"%@/storage/%@", SERVICE_URL, avatar];
                             NSURL *picURL = [NSURL URLWithString:avatar];
                             NSData *data = [NSData dataWithContentsOfURL:picURL];
                             UIImage *image = [UIImage imageWithData:data];
                             [_profileImage setImage:image];
                         }
                     }
                     else
                     {
                         [_profileImage setImage:[UIImage imageNamed:@"user_profile"]];

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
                             
                             
                             [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                             ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                             [self.navigationController pushViewController:wallet animated:YES];
                         }
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
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


-(IBAction)backBtn:(id)sender
{
    HomeViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_firstNameText)
    {
        [_lastNameText becomeFirstResponder];
    }
    else if(textField==_lastNameText)
    {
        [_phoneText becomeFirstResponder];
    }
    else if(textField==_phoneText)
    {
        [_phoneText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _firstNameText) || (textField == _lastNameText))
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


-(IBAction)saveBtn:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_firstNameText.text isEqualToString:@""] ||[_lastNameText.text isEqualToString:@""] || [_phoneText.text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter all the fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if([appDelegate internetConnected])
        {
            
            NSDictionary*params;
            params=@{@"mobile":_phoneText.text, @"first_name":_firstNameText.text, @"last_name":_lastNameText.text};
            
            NSLog(@"PARAMS...%@", params);
          
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
             appDelegate.viewControllerName = @"Profile";
            [afn getDataFromPath:PROFILE  withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
             {
               
                 if (response)
                 {
                     NSLog(@"RESPONSE2 ...%@", response);
                     NSString *first_name = [response valueForKey:@"first_name"];
                     NSString *avatar =[Utilities removeNullFromString:[response valueForKey:@"avatar"]];
                     NSString *status =[Utilities removeNullFromString:[response valueForKey:@"status"]];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:first_name forKey:@"first_name"];
                     [defaults setObject:avatar forKey:@"avatar"];
                     [defaults setObject:status forKey:@"status"];
                     [defaults setObject:[response valueForKey:@"id"] forKey:@"id"];

                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Profile Updated"preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     NSLog(@"RESPONSE1 ...%s", "sssdsdsdsdsd");
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
                         else if ([error objectForKey:@"first_name"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"last_name"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"last_name"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"mobile"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"mobile"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"picture"])
                         {
                             [CSS_Class alertviewController_title:@"" MessageAlert:[[error objectForKey:@"picture"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else
                         {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                         }
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
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
}

- (IBAction)regImgViewAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"profileimage"];
//    [_imageBtn setImage:image forState:UIControlStateNormal];
    [_profileImage setImage:image];
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)passwordAction:(id)sender
{
    ChangePasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)LanguageBtnAction:(UIButton *)sender {
    
    LanguageController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageController"];
    controller.page_identifier = @"Profile";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
