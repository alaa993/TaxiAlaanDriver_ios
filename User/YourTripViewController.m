//
//  YourTripViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "YourTripViewController.h"
#import "config.h"
#import "Colors.h"
#import "CSS_Class.h"
#import "TripsTableViewCell.h"
#import "HistoryViewController.h"
#import "AFNHelper.h"
#import "Utilities.h"
#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeViewController.h"
#import "SummaryViewController.h"

@interface YourTripViewController ()

@end

@implementation YourTripViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([_navigateStr isEqualToString:@"Home"])
    {
        [self upcomingBtn:self];
    }
    else
    {
        [self pastBtn:self];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
}

-(void)LocalizationUpdate{
    _headerLb.text = LocalizedString(@"Your Trips");
    [_pastBtn setTitle:LocalizedString(@"Past") forState:UIControlStateNormal];
    [_upcomingBtn setTitle:LocalizedString(@"Upcoming") forState:UIControlStateNormal];

    
}
-(void)getTripList
{
    if([appDelegate internetConnected])
    {
        NSString *serviceStr;
        
        if([identifierStr isEqualToString:@"PAST"])
        {
            serviceStr = PAST_TRIPS;
        }
        else
        {
            serviceStr = UPCOMING_TRIPS;
        }
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:serviceStr withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"TRIP RESPONSE ...%@", response);
                 
                 dateArray = [[NSMutableArray alloc]init];
                 timeArray = [[NSMutableArray alloc]init];
                 amountArray = [[NSMutableArray alloc]init];
                 imageArray = [[NSMutableArray alloc]init];
                 idArray = [[NSMutableArray alloc]init];
                 bookingArray = [[NSMutableArray alloc]init];
                 
                 NSArray *arrLocal=response;
                 if (arrLocal.count!=0)
                 {
                     [_noDataLbl setHidden:YES];
                     [_tripTableView setHidden:NO];
                     
                     for (NSDictionary *dictVal in arrLocal)
                     {
                         if([identifierStr isEqualToString:@"PAST"])
                         {
                             NSString *strDate=[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"assigned_at"]];
                             NSString *strTime=[Utilities  convertTimeFormat:[dictVal valueForKey:@"assigned_at"]];
                             
                             [dateArray addObject:strDate];
                             [timeArray addObject:strTime];
                         }
                         else
                         {
                             NSString *strDate=[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"schedule_at"]];
                             NSString *strTime=[Utilities  convertTimeFormat:[dictVal valueForKey:@"schedule_at"]];
                             [dateArray addObject:strDate];
                             [timeArray addObject:strTime];
                         }
                         
                         [bookingArray addObject:[Utilities removeNullFromString:[dictVal valueForKey:@"booking_id"]]];
                         [imageArray addObject:[dictVal valueForKey:@"static_map"]];
                         [idArray addObject:[dictVal valueForKey:@"id"]];
                         
                         if (![[dictVal valueForKey:@"payment"] isKindOfClass:[NSNull class]])
                         {
                             if([identifierStr isEqualToString:@"PAST"])
                             {
                                 [amountArray addObject:[[dictVal valueForKey:@"payment"] valueForKey:@"total"]];
                             }
                             else
                             {
                                 ///
                             }

                         }
                         else
                         {
                             [amountArray addObject:@"0"];
                         }
                     }
                     [_tripTableView reloadData];
                 }
                 else
                 {
                     [_noDataLbl setHidden:NO];
                     [_tripTableView setHidden:YES];
                 }
             }
             else
             {
                 if ([strErrorCode intValue]==1)
                 {
                     [CSS_Class alertviewController_title: (@"ERROR", nil) MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    
}

#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripsTableViewCell *cell = (TripsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TripsTableViewCell"];
    
    if (cell == nil)
    {
        cell = (TripsTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"TripsTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.dateLbl.text = [NSString stringWithFormat:@"%@", [bookingArray objectAtIndex:indexPath.row]];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@-%@", [dateArray objectAtIndex:indexPath.row],[timeArray objectAtIndex:indexPath.row]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currency = [defaults valueForKey:@"currency"];
    
    [CSS_Class APP_fieldValue:cell.dateLbl];
    [CSS_Class APP_fieldValue_Small:cell.timeLbl];
    [CSS_Class APP_fieldValue:cell.amountLbl];
    cell.timeLbl.textColor = TEXTCOLOR_LIGHT;
    
    NSString *strVal=imageArray [indexPath.row];
    NSString *escapedString =[strVal stringByReplacingOccurrencesOfString:@"%7C" withString:@"|"];
    NSURL *mapUrl = [NSURL URLWithString:[escapedString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
     [cell.mapImg sd_setImageWithURL:mapUrl  placeholderImage:[UIImage imageNamed:@"rd-map"]];
    
    cell.cancelBtn.layer.cornerRadius = 5.0f;
    cell.cancelBtn.layer.borderWidth = 1.0f;
    cell.cancelBtn.layer.borderColor = TEXTCOLOR_LIGHT.CGColor;
    
    if (![identifierStr isEqualToString:@"PAST"])
    {
        [cell.amountLbl setHidden:YES];
        [cell.cancelBtn setHidden:NO];
    }
    else
    {
        [cell.amountLbl setHidden:NO];
        [cell.cancelBtn setHidden:YES];
        cell.amountLbl.text = [NSString stringWithFormat:@"%@%@", currency, [amountArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *orderIdString = [idArray objectAtIndex:indexPath.row];
    NSLog(@"orderIdString ...%@", orderIdString);
    
    HistoryViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    wallet.historyHintStr = identifierStr;
    wallet.request_idStr = orderIdString;
    [self presentViewController:wallet animated:YES completion:nil];
}


-(IBAction)backBtn:(id)sender
{
    if ([_navigateStr isEqualToString:@"Summary"])
    {
        SummaryViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
        [self.navigationController pushViewController:wallet animated:YES];
    }
    else
    {
        HomeViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:wallet animated:YES];
    }
}

-(IBAction)upcomingBtn:(id)sender
{
    identifierStr = LocalizedString(@"UPCOMING");
    [_upcomingLbl setHidden:NO];
    [_pastLbl setHidden:YES];
    
    [self getTripList];
}
-(IBAction)pastBtn:(id)sender
{
    identifierStr =LocalizedString(@"PAST");
    [_upcomingLbl setHidden:YES];
    [_pastLbl setHidden:NO];
    
    [self getTripList];
}

-(IBAction)cancelActionBtn:(id)sender
{
    if ([appDelegate internetConnected])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tripTableView];
        NSIndexPath *indexPath = [_tripTableView indexPathForRowAtPoint:buttonPosition];
        NSLog(@"INDEXPATH...%ld", (long)indexPath.row);
        
        NSString *req_Id = [NSString stringWithFormat:@"%@", [idArray objectAtIndex:indexPath.row]];
        
        NSDictionary *para = @{@"id": req_Id};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:CANCEL_REQUEST  withParamData:para withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 NSLog(@"CANCEL RESPONSE...%@", response);
                 
                 [self getTripList];
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
