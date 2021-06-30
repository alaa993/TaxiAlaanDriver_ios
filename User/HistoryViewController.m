//
//  HistoryViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "HistoryViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "ViewController.h"
#import "AFNHelper.h"
#import "Utilities.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app_Name = LocalizedString(@"APPNAME");
    [super viewDidLoad];
    [self setDesignStyles];
    
    if ([_historyHintStr isEqualToString:@"UPCOMING"])
    {
        [_commentsView setHidden:YES];
        [_cashLb setHidden:YES];
    }
    
    [self getHistoryDetails];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
    
}

-(void)LocalizationUpdate{
    _headerLbl.text = LocalizedString(@"History");
    _paymentLb.text = LocalizedString(@"Payment method");
    _commentTitleLb.text = LocalizedString(@"Comments");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    [CSS_Class APP_fieldValue_Small:_dateLb];
    [CSS_Class APP_SmallText:_timeLb];
    [CSS_Class APP_fieldValue:_nameLb];
    [CSS_Class APP_labelName:_paymentLb];
    [CSS_Class APP_labelName:_commentTitleLb];
    [CSS_Class APP_fieldValue_Small:_payTypeLb];
    [CSS_Class APP_fieldValue:_cashLb];
    [_timeLb setTextColor:TEXTCOLOR_LIGHT];
    
    [CSS_Class APP_SmallText:_pickLb];
    [CSS_Class APP_SmallText:_dropLb];
    [CSS_Class APP_SmallText:_commentsLb];
    
    _userImg.layer.cornerRadius=_userImg.frame.size.height/2;
    _userImg.clipsToBounds=YES;
}
-(void)phone{
    
  
  
    
   
}

- (IBAction)btnCallPhone:(id)sender {
    if (![sender isKindOfClass:[UIButton class]])
            return;

        NSString *mobileStr = [(UIButton *)sender currentTitle];
    
      if ([mobileStr isEqualToString:@""])
    {
        [CSS_Class alertviewController_title:LocalizedString(@"Alert!") MessageAlert:LocalizedString(@"User was not gave the mobile number") viewController:self okPop:NO];
    }
    else
    {
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:mobileStr]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:mobileStr]];
        
        if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
        {
            [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
        }
        else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
        {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
        }
     
}
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getHistoryDetails
{
    if([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        NSDictionary *params = @{@"request_id":_request_idStr};
        
        NSString *serviceStr;
        
        if([_historyHintStr isEqualToString:@"PAST"])
        {
            serviceStr = HISTORY_DETAILS;
        }
        else
        {
            serviceStr = UPCOMING_HISTORYDETAILS;
        }
        
        [afn getDataFromPath:serviceStr withParamData:params withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"RESPONSE ...%@", response);
                 NSArray *arrLocal=response;
                 if (arrLocal.count!=0)
                 {
                     NSDictionary *dictVal = [arrLocal objectAtIndex:0];
                     NSString *strVal=[dictVal valueForKey:@"static_map"];
                     NSString *escapedString =[strVal stringByReplacingOccurrencesOfString:@"%7C" withString:@"|"];
                     NSURL *mapUrl = [NSURL URLWithString:[escapedString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
                     _mapImg.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
                     
                     _dateLb.text =[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"assigned_at"]];
                     _timeLb.text=[Utilities  convertTimeFormat:[dictVal valueForKey:@"assigned_at"]];
                     _bookingIdLbl.text =[Utilities  removeNullFromString:[dictVal valueForKey:@"booking_id"]];
                     _dropLb.text =[Utilities removeNullFromString:[dictVal valueForKey:@"d_address"]];
                     _pickLb.text =[Utilities  removeNullFromString:[dictVal valueForKey:@"s_address"]];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     NSString *currency = [defaults valueForKey:@"currency"];
                     
                     if (![[dictVal valueForKey:@"payment"] isKindOfClass:[NSNull class]])
                     {
                         if([_historyHintStr isEqualToString:@"PAST"])
                         {
                             [_cashLb setText:[NSString stringWithFormat:@"%@%@", currency,[[dictVal valueForKey:@"payment"] valueForKey:@"total"]]];
                         }
                         else
                         {
                             _cashLb.text= [NSString stringWithFormat:@"%@0.00", currency];
                             _dateLb.text =[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"schedule_at"]];
                             _timeLb.text=[Utilities  convertTimeFormat:[dictVal valueForKey:@"schedule_at"]];
                         }
                     }
                     else
                     {
                         [_cashLb setText:[NSString stringWithFormat:@"%@0.00", currency]];
                     }
                     
                     if (![[dictVal valueForKey:@"user"] isKindOfClass:[NSNull class]])
                     {
                         [_nameLb setText:[[dictVal valueForKey:@"user"] valueForKey:@"first_name"]];
                         _rating_user.value=[[[dictVal valueForKey:@"user"] valueForKey:@"rating"]floatValue];
                         [_payTypeLb setText:[[dictVal valueForKey:@"user"] valueForKey:@"payment_mode"]];
                         NSString *avatar = [Utilities removeNullFromString:[[dictVal valueForKey:@"user"] valueForKey:@"picture"]];
                         [_CallPhone setTitle:[[dictVal valueForKey:@"user"] valueForKey:@"mobile"] forState:UIControlStateNormal];
                         
                         if ([avatar isEqualToString:@""])
                         {
                             [_userImg setImage:[UIImage imageNamed:@"user_profile"]];
                         }
                         else if ([avatar containsString:@"http"])
                         {
                             NSURL *picURL = [NSURL URLWithString:avatar];
                             NSData *data = [NSData dataWithContentsOfURL:picURL];
                             UIImage *image = [UIImage imageWithData:data];
                             [_userImg setImage:image];
                         }
                         else
                         {
                             avatar = [NSString stringWithFormat:@"%@/storage/%@", SERVICE_URL, avatar];
                             NSURL *picURL = [NSURL URLWithString:avatar];
                             NSData *data = [NSData dataWithContentsOfURL:picURL];
                             UIImage *image = [UIImage imageWithData:data];
                             [_userImg setImage:image];
                         }
                     }
                     else
                     {
                         //                         [_cashLb setText:@"0"];
                     }
//                     if (![[dictVal valueForKey:@"rating"] isKindOfClass:[NSNull class]])
//                     {
//                         if ([[dictVal[@"rating"] valueForKey:@"provider_comment"] isEqualToString:@""])
//                         {
//                             _commentsLb.text=@"no comments";
//                         }
//                         else
//                         {
//                             _commentsLb.text=[dictVal[@"rating"] valueForKey:@"provider_comment"];
//                         }
//                     }
                     if (![dictVal[@"rating"] isKindOfClass:[NSNull class]])
                     {
                         if (![[dictVal[@"rating"] valueForKey:@"user_rating"] isKindOfClass:[NSNull class]])
                             _rating_user.value = [[dictVal[@"rating"] valueForKey:@"user_rating"] intValue];
                         else
                             _rating_user.value = 0;
                         
                         if (![[dictVal[@"rating"] valueForKey:@"user_comment"] isKindOfClass:[NSNull class]])
                         {
                             if ([[dictVal[@"rating"] valueForKey:@"user_comment"] isEqualToString:@""])
                             {
                                 _commentsLb.text=@"no comments";
                             }
                             else
                             {
                                 _commentsLb.text=[dictVal[@"rating"] valueForKey:@"user_comment"];
                                 
                             }
                         }
                     }
                 }
                 else
                 {
                     
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


@end
