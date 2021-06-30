//
//  ViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provider-Swift.h"

@interface ViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *btnCodeCountry;

@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIView *virifiView;
@property (strong, nonatomic) IBOutlet UIButton *btnVirifi;
@property (strong, nonatomic) IBOutlet OTPInputView *otpInputView;
@property (strong, nonatomic) IBOutlet UILabel *lbPhoneNumber;

@end

