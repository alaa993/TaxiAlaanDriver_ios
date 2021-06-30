//
//  EarningsViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 11/04/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "EarningsViewController.h"
#import "AFNHelper.h"
#import "config.h"
#import "Colors.h"
#import "CSS_Class.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "EarningsTableViewCell.h"
#import "Utilities.h"

@interface EarningsViewController ()
@end

@implementation EarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self getEarnings];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocaliztionUpdate];
}

-(void)LocaliztionUpdate{
    _HeaderLbl.text =  LocalizedString(@"EARNINGS");
    _totalEarningLbl.text =  LocalizedString(@"Total Earnings");
    _TimeLbl.text = LocalizedString(@"Time");
    _DistanceLbl.text = LocalizedString(@"Distance");
    _amountLbl.text = LocalizedString(@"Amount");
    _TargetLbl.text = LocalizedString(@"Today Completed Target");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getEarnings
{
    if([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:GET_EARNINGS withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *strErrorCode)
         {
             if (response)
             {
                 timeArray = [[NSMutableArray alloc]init];
                 distanceArray = [[NSMutableArray alloc]init];
                 amountArray = [[NSMutableArray alloc]init];
                 NSLog(@"Earnings response ...%@", response);
                 
                 NSArray *ridesArray = [response valueForKey:@"rides"];
                 
                 if (ridesArray.count !=0) {
                     
                     for (NSDictionary *dictVal in ridesArray)
                     {
                         NSString *distance=[NSString stringWithFormat:@"%@",[dictVal valueForKey:@"distance"]];
                         
                         NSString *strTime=[Utilities  convertTimeFormat:[dictVal valueForKey:@"assigned_at"]];
                         
                         NSDictionary *paymentDict=[dictVal valueForKey:@"payment"];
                         NSString *totalValueStr= [NSString stringWithFormat:@"%@",[paymentDict valueForKey:@"total"]];
                         
                         [amountArray addObject:totalValueStr];
                         [distanceArray addObject:distance];
                         [timeArray addObject:strTime];
                     }
                     
                     double sum = 0;
                     for (NSNumber * n in amountArray) {
                         sum += [n doubleValue];
                     }
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     NSString *currency = [defaults valueForKey:@"currency"];
                     _totalEarnigsValues.text = [NSString stringWithFormat:@"%@%.2f",currency, sum];
                     
                     [_listTableView reloadData];
                 }
                 
                 NSString *targetValue = [response valueForKey:@"target"];
                 NSString *ridesValue = [response valueForKey:@"rides_count"];
                 
                 [_circularProgressBar setProgress:[ridesValue floatValue]/10 animated:YES duration:1];
                 
                 [_circularProgressBar setHintTextFont:[UIFont fontWithName:@"ClanPro-NarrMedium" size:22]];
                 
                 [_circularProgressBar setHintTextGenerationBlock:^NSString *(CGFloat progress){
                     
                     return [NSString stringWithFormat:@"%@/%@", ridesValue, targetValue];
                 }];
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


#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EarningsTableViewCell *cell = (EarningsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"EarningsTableViewCell"];
    
    if (cell == nil)
    {
        cell = (EarningsTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"EarningsTableViewCell" owner:self options:nil] lastObject];
    }
    
    if(indexPath.row % 2 == 0)
    {
        cell.inner.backgroundColor = RGB(248, 248, 248);
    }
    else
    {
        cell.inner.backgroundColor = RGB(240, 240, 240);
    }
    
    cell.inner.layer.cornerRadius = 5.0f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currency = [defaults valueForKey:@"currency"];
    
    cell.distanceLbl.text = [NSString stringWithFormat:@"%@Km", [distanceArray objectAtIndex:indexPath.row]];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@", [timeArray objectAtIndex:indexPath.row]];
    NSString *totalValueStr = [NSString stringWithFormat:@"%@", [amountArray objectAtIndex:indexPath.row]];
    
    CGFloat total = [totalValueStr floatValue];
    
    cell.amountLbl.text = [NSString stringWithFormat:@"%@%.2f",currency,total];
        
    [CSS_Class APP_fieldValue:cell.distanceLbl];
    [CSS_Class APP_fieldValue:cell.timeLbl];
    [CSS_Class APP_fieldValue:cell.amountLbl];
    return cell;
}
-(IBAction)backBtn:(id)sender
{
    HomeViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

@end
