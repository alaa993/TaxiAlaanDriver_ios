//
//  HelpViewController.m
//  User
//
//  Created by iCOMPUTERS on 21/06/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "HelpViewController.h"
#import "config.h"
#import "CSS_Class.h"
#import "Colors.h"
#import "HomeViewController.h"
#import "AFNHelper.h"
#import "ViewController.h"
#import "Utilities.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    strProviderCell = @"";
    [self getHelpDetails];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
}

-(void)LocalizationUpdate{
    _navicationTitleLbl.text = LocalizedString(@"HELP");
    _helpLbl.text = LocalizedString(@"TaxiAlaan Help");
    _infoLbl.text = LocalizedString(@"Our team person will contact you soon!");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)callBtn:(id)sender
{
    if ([strProviderCell isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Admin was not provided the number to call." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:strProviderCell]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:strProviderCell]];
        
        if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
        {
            [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
        }
        else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
        {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device does not support calling" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

-(IBAction)mailBtn:(id)sender
{
    if ([appDelegate internetConnected])
    {
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        // Configure the fields of the interface.
        [composeVC setToRecipients:@[mailAddress]];
        [composeVC setSubject:@"TaxiAlaan Mail Composer"];
        [composeVC setMessageBody:@"Hello TaxiAlaan" isHTML:NO];
        
        if (![MFMailComposeViewController canSendMail]) {
            NSLog(@"Mail services are not available.");
            return;
        }
        else
        {
            // Present the view controller modally.
            [self presentViewController:composeVC animated:YES completion:nil];
        }
    }
    else
    {
        [CSS_Class alertviewController_title:@"" MessageAlert:LocalizedString(@"CHKNET") viewController:self okPop:NO];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if(result ==MFMailComposeResultCancelled)
    {
        [CSS_Class alertviewController_title:@"Alert!" MessageAlert:@"Mail cancelled by you" viewController:self okPop:NO];
    }
    else if(result ==MFMailComposeResultSent)
    {
        [CSS_Class alertviewController_title:@"Success!" MessageAlert:@"Our team person will contact you." viewController:self okPop:NO];
    }
    else if(result ==MFMailComposeResultFailed)
    {
        [CSS_Class alertviewController_title:@"Alert!" MessageAlert:@"Mail sent failed, Please try again later." viewController:self okPop:NO];
    }
}

-(IBAction)browserBtn:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICE_URL]];
}

-(void)getHelpDetails
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_HELP withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                NSLog(@"help response...%@", response);
                strProviderCell = [Utilities removeNullFromString:[response valueForKey:@"contact_number"]];
                mailAddress = [Utilities removeNullFromString:[response valueForKey:@"contact_email"]];
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


@end
