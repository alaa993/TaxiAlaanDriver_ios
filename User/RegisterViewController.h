//
//  RegisterViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AccountKit/AccountKit.h>
#import <AccountKit/AKFTheme.h>

@class AppDelegate;

@interface RegisterViewController : UIViewController<UIGestureRecognizerDelegate, AKFViewControllerDelegate>
{
    AppDelegate *appDelegate;
    NSMutableArray *servicenames, *serviceids;
    
//    UIView *pickerViewContainer, *backgroundView;
//    UIViewController *viewController;
//    UIPopoverController *popOverForPicker;
//    UIPickerView *comm_PickerView;
    
    NSString *service_IdStr, *service_NameStr;
    NSString *isFlagSet;
    NSString *dialCodeStr,*phoneStr;
    NSString *dial_code;
    NSArray *countriesList;
   

}

@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *firstNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *lastNameText;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordText;

@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *confirmPassLbl;

@property (weak, nonatomic) IBOutlet UITextField *RegcountrycodeTF;
@property (weak, nonatomic) IBOutlet UIImageView *RegcountryflagImgeView;

@property (strong, nonatomic)NSString  *strPhn;

 @property(strong,nonatomic) NSString *mobilenumber;
@property(strong,nonatomic) NSString *codeCountry;
@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
    
@end
