//
//  SummaryViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 21/06/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "SummaryViewController.h"
#import "config.h"
#import "CSS_Class.h"
#import "Colors.h"
#import "HomeViewController.h"
#import "AFNHelper.h"
#import "ViewController.h"
#import "SummaryTableViewCell.h"
#import "Utilities.h"
#import "YourTripViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self getSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSummary
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_SUMMARY withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                count = [response count];
                summaryResponse = response;
                NSLog(@"summary response...%@", response);
                
                [_listTableView reloadData];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CSS_Class alertviewController_title:@"" MessageAlert:LocalizedString(@"ERRORMSG") viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
                    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                    ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    [self.navigationController pushViewController:wallet animated:YES];
                }
            }
            
        }];
    }
    else
    {
        [CSS_Class alertviewController_title:@"" MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
    }
}

#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SummaryTableViewCell *cell = (SummaryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SummaryTableViewCell"];
    
    if (cell == nil)
    {
        cell = (SummaryTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"SummaryTableViewCell" owner:self options:nil] lastObject];
    }
    
    if(indexPath.row % 2 == 0)
    {
        cell.inner.backgroundColor = RGB(248, 248, 248);
    }
    else
    {
        cell.inner.backgroundColor = RGB(240, 240, 240);
    }
    
    cell.countLbl.method = UILabelCountingMethodLinear;
    cell.countLbl.format = @"%d";

    [cell.dollarLbl setHidden:YES];
    
    if (indexPath.row==0)
    {
        if ([summaryResponse objectForKey:@"rides"])
        {
            cell.nameLbl.text = LocalizedString(@"TOTAL NUMBER OF RIDES");
            NSString *ridesStr = [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[summaryResponse objectForKey:@"rides"]]];
            int size = [ridesStr intValue];
            [cell.countLbl countFrom:0 to:size withDuration:2.0f];
            cell.imageLbl.image = [UIImage imageNamed:@"summary-total-rides"];
        }
    }
    else if (indexPath.row==1)
    {
        if ([summaryResponse objectForKey:@"revenue"])
        {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *currency = [def valueForKey:@"currency"];
            cell.imageLbl.image = [UIImage imageNamed:@"summary-revenue"];
            
            cell.nameLbl.text = LocalizedString(@"REVENUE");
           NSString *reveStr = [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[summaryResponse objectForKey:@"revenue"]]];
            int size = [reveStr intValue];
            [cell.countLbl countFrom:0 to:size withDuration:2.0f];
            cell.dollarLbl.text = currency;
            [cell.dollarLbl setHidden:NO];
            cell.countLbl.text = [NSString stringWithFormat:@"%@ %@",currency, reveStr];
        }
    }
    else if (indexPath.row==2)
    {
        if ([summaryResponse objectForKey:@"scheduled_rides"])
        {
            cell.nameLbl.text = LocalizedString(@"NO OF SCHEDULED RIDES");
            NSString *sheduleStr= [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[summaryResponse objectForKey:@"scheduled_rides"]]];
            
            int size = [sheduleStr intValue];
            [cell.countLbl countFrom:0 to:size withDuration:2.0f];
            cell.imageLbl.image = [UIImage imageNamed:@"summary-schedule"];
        }
    }
    else if (indexPath.row==3)
    {
        if ([summaryResponse objectForKey:@"cancel_rides"])
        {
            cell.nameLbl.text = LocalizedString(@"CANCELLED RIDES");
            NSString *cancelStr= [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[summaryResponse objectForKey:@"cancel_rides"]]];
            
            int size = [cancelStr intValue];
            [cell.countLbl countFrom:0 to:size withDuration:2.0f];
            cell.imageLbl.image = [UIImage imageNamed:@"summary-cancel"];
        }
    }
    
    cell.inner.layer.cornerRadius = 5.0f;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        YourTripViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"YourTripViewController"];
        wallet.navigateStr = @"Summary";
        [self.navigationController pushViewController:wallet animated:YES];
    }
}
-(IBAction)backBtn:(id)sender
{
    HomeViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

@end
