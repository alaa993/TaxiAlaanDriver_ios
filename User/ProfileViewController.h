//
//  ProfileViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLb;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *emailtLb;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLb;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *serviceValueLb;
@property (weak, nonatomic) IBOutlet UILabel *serviceLb;


- (IBAction)LanguageBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;
@end
