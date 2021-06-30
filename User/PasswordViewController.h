//
//  PasswordViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewClass.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"

@class LoadingViewClass;
@class AppDelegate;

@interface PasswordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    LoadingViewClass *loading;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLbl;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UILabel *password_Lbl;

@property (weak, nonatomic) IBOutlet UITextField *otptxt1;
@property (weak, nonatomic) IBOutlet UITextField *otptxt2;
@property (weak, nonatomic) IBOutlet UITextField *otptxt3;
@property (weak, nonatomic) IBOutlet UITextField *otptxt4;

@property(strong,nonatomic) NSString *requestid;
@property(strong,nonatomic) NSString *mobilenumber;
@property(strong,nonatomic) NSString *callbackstring;
@property(strong,nonatomic) NSString *firstnamestr;
@property(strong,nonatomic) NSString *lastnamestr;
@property(strong,nonatomic) NSString *countrycodestr;
@property(strong,nonatomic) NSString *email;
@property (weak, nonatomic) IBOutlet UIButton *resendbtn;

//Email
@property (strong, nonatomic) NSString *emailStr;

@end
