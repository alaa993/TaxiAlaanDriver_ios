//
//  ValidateViewController.h
//  User
//
//  Created by Veena on 13/07/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *validationNumber;
@property (weak, nonatomic) IBOutlet UITextField *validationPin;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet NSString *isFrom;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImgView;



@end
