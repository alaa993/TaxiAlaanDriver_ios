//
//  ChangePasswordViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 01/02/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "EmailViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "AFNHelper.h"
#import "ViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDesignStyles];
     appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
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
    [CSS_Class APP_textfield_Outfocus:_passText];
    [CSS_Class APP_textfield_Outfocus:_confirmPassText];
    [CSS_Class APP_textfield_Outfocus:_oldPassText];
    
    [CSS_Class APP_labelName_Small:_oldPassLbl];
    [CSS_Class APP_labelName_Small:_passLbl];
    [CSS_Class APP_labelName_Small:_confirmPassLbl];
    [CSS_Class APP_Blackbutton:_changePasswordBtn];
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_oldPassText)
    {
        [_passText becomeFirstResponder];
    }
    if(textField==_passText)
    {
        [_confirmPassText becomeFirstResponder];
    }
    else if(textField==_confirmPassText)
    {
        [_confirmPassText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _passText) || (textField == _oldPassText) || (textField == _confirmPassText))
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PASSWORDLENGTH || returnKey;
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
    
    if((_passText.text.length==0) || (_confirmPassText.text.length==0) || (_confirmPassText.text.length==0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:@"Password fields are required" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if(![_passText.text isEqualToString:_confirmPassText.text])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"ALERT") message:@"New password and confirm password must be same" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        if([appDelegate internetConnected])
        {
            NSDictionary*params;
            params=@{@"password":_passText.text, @"password_confirmation":_confirmPassText.text, @"password_old":_oldPassText.text};
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            appDelegate.viewControllerName = @"Profile";
            [afn getDataFromPath:CHANGE_PASSWORD  withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
             {
                 if (response)
                 {
                     NSLog(@"RESPONSE ...%@", response);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Password changed"preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                         [self backBtn:self];
//                         EmailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewController"];
//                         [self.navigationController pushViewController:controller animated:YES];
                     }];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     if ([strErrorCode intValue]==1)
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
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
                         if ([error objectForKey:@"password"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"password_confirmation"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"password_confirmation"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"password_old"]) {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR") MessageAlert:[[error objectForKey:@"password_old"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else
                         {
                             [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                         }
                     }
                     else
                     {
                         [CSS_Class alertviewController_title:LocalizedString(@"ERROR")  MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
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


@end
