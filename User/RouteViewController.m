//
//  RouteViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 06/02/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController
@synthesize activityIndicator;

typedef void(^addressCompletion)(NSString *);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
}
-(void)LocalizationUpdate{
    _haderLbl.text = LocalizedString(@"Navigation");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- WebView Delegates

- (void)webViewDidStartLoad:(UIWebView *)web
{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
    [activityIndicator stopAnimating];
}

-(void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet)
    {
        [activityIndicator stopAnimating];
    }
}

@end
