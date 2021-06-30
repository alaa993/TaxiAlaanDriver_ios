//
//  EmailViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface EmailViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSString *emailString,*isFlagSet;
    NSString *dialCodeStr,*phoneStr;
    NSString *dial_code;
    NSArray *countriesList;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UILabel *register_Lbl;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlagImageView;
@property (weak, nonatomic) IBOutlet UITextField *validationmobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *changeCountryBtn;
- (IBAction)changeCountryBtnAction:(id)sender;

@end
