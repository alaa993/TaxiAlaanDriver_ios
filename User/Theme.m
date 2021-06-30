//
//  Theme.m
//  FoodieUser
//
//  Created by apple on 9/5/17.
//  Copyright © 2017 Tanjara Infotech. All rights reserved.
//

#import "Theme.h"
#import <QuartzCore/QuartzCore.h>

@implementation Theme

NSString *const FONT_BLACK = @"ClanPro-NarrNews";
NSString *const FONT_BOLD = @"ClanPro-NarrMedium";
NSString *const FONT_EXTRABOLD = @"ClanPro-Book";
NSString *const FONT_EXTRALIGHT = @"ClanPro-Book";
NSString *const FONT_LIGHT = @"ClanPro-Book";
NSString *const FONT_MEDIUM = @"ClanPro-NarrMedium";
NSString *const FONT_REGULAR = @"ClanPro-NarrNews";
NSString *const FONT_SEMIBOLD = @"ClanPro-Book";

+ (void)viewShadowDesign:(UIView *)shadowView
{
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.shadowOpacity = 0.1;
    shadowView.layer.cornerRadius = 2;
    CGRect shadowFrame = shadowView.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    shadowView.layer.shadowPath = shadowPath;
}

+ (void)dottedBorderView:(UIView *)view
{
    CAShapeLayer *viewBorder = [CAShapeLayer layer];
    viewBorder.strokeColor = [UIColor blackColor].CGColor;
    viewBorder.lineWidth = 1;
    viewBorder.lineDashPattern = @[@2, @2];
    viewBorder.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, view.frame.size.height-1, view.frame.size.width, 1)].CGPath;
    [view.layer addSublayer:viewBorder];
}

+ (void)setViewBorder:(UIView *)view isLeft:(BOOL )leftBorder isRight:(BOOL )rightBorder isTop:(BOOL )topBorder isBottom:(BOOL )bottomBorder size:(CGFloat)sizevalue xspace:(CGFloat)spacevalue
{
    CALayer *border = [CALayer layer];
    
    if(leftBorder)
    {
        border.frame = CGRectMake(0.0f, 0.0f, sizevalue, view.frame.size.height);
    }
    else if(rightBorder)
    {
        border.frame = CGRectMake(view.frame.size.height-sizevalue, 0.0f, sizevalue, view.frame.size.height);
    }
    else if(topBorder)
    {
        border.frame = CGRectMake(spacevalue, 0.0f, view.frame.size.width, sizevalue);
    }
    else if(bottomBorder)
    {
        border.frame = CGRectMake(spacevalue, view.frame.size.height-sizevalue, view.frame.size.width, sizevalue);
    }
    
    border.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [view.layer addSublayer:border];
}


+ (void)primaryButton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:16];
    button.layer.cornerRadius = 2.0f;
    [button setTitleColor:WHITE forState:UIControlStateNormal];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = PRIMARYCOLOR;
}

+ (void)primaryGreenButton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:16];
    button.layer.cornerRadius = 2.0f;
    [button setTitleColor:WHITE forState:UIControlStateNormal];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = SECONDARYCOLOR;
}

+ (void)secondaryButton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:16];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 0.0f;
    button.layer.borderColor = PRIMARYCOLOR.CGColor;
    [button setTitleColor:PRIMARYCOLOR forState:UIControlStateNormal];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
}

+ (void)secondaryGreenButton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:16];
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 0.0f;
    button.layer.borderColor = SECONDARYCOLOR.CGColor;
    [button setTitleColor:SECONDARYCOLOR forState:UIControlStateNormal];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
}


+ (void)baseButtonWhite:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:16];
    button.layer.cornerRadius = 2.0f;
    [button setTitleColor:BLACK forState:UIControlStateNormal];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = WHITE;
}

+ (void)buttonWithoutBg:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:14];
    [button setTitleColor:PRIMARYTEXT forState:UIControlStateNormal];
    button.clipsToBounds = NO;
}

+ (void)buttonWithoutBgPrimary:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:14];
    [button setTitleColor:PRIMARYCOLOR forState:UIControlStateNormal];
    button.clipsToBounds = NO;
}


//LABEL

+ (void)navigationTitle:(UILabel *)label;
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = BLACK;
    [label setFont:[UIFont fontWithName:FONT_SEMIBOLD size:16]];
}
+ (void)header:(UILabel *)label;
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_BOLD size:22]];
}

+ (void)subHeader:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_SEMIBOLD size:16]];
}

+ (void)description:(UILabel *)label;
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = SECONDARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
}

+ (void)customLabel:(UILabel *)label lblColor:(UIColor *)color size:(CGFloat)lblSize font:(NSString *)lblfont
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    [label setFont:[UIFont fontWithName:lblfont size:lblSize]];
}


+ (void)primaryLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_SEMIBOLD size:16]];
}

+ (void)primaryDescLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
}

+ (void)secondaryLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_SEMIBOLD size:14]];
}

+ (void)secondaryDescLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = SECONDARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
}

+ (void)labelWhite:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = WHITE;
    [label setFont:[UIFont fontWithName:FONT_SEMIBOLD size:15]];
}

+ (void)attributedString:(NSString *)from to:(NSString *)to forLabel:(UILabel *)label;
{
    label.textColor = SECONDARYTEXT;
    UIFont *font = [UIFont fontWithName:FONT_REGULAR size:15];
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName:font }];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:PRIMARYCOLOR
                 range:NSMakeRange([from length]+1, [to length])];
    [label setAttributedText:text];
}


+ (void)lightFontlabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_LIGHT size:14]];
}

+ (void)regularFontlabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:16]];
}

+ (void)smallFontlabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = PRIMARYTEXT;
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
}


+ (void)cornerRadius:(UIView *)forView forLabel:(UILabel *)label fortextfield:(UITextField *)textField forButton:(UIButton *)button
{
    forView.clipsToBounds = YES;
    forView.layer.cornerRadius = 3;
    
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 3;
    
    textField.clipsToBounds = YES;
    textField.layer.cornerRadius = 3;
    
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 3;
}


+ (void)textfieldInfocus:(UITextField *)textField
{
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font=[UIFont fontWithName:FONT_SEMIBOLD size:16];
    
    textField.textColor = PRIMARYTEXT;
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = PRIMARYCOLOR.CGColor;
    [textField.layer addSublayer:bottomBorder];
}


+ (void)textfieldOutfocus:(UITextField *)textField
{
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font=[UIFont fontWithName:FONT_SEMIBOLD size:16];
    
    textField.textColor = PRIMARYTEXT;
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = PRIMARYTEXT.CGColor;
    [textField.layer addSublayer:bottomBorder];
}

+ (void)primaryTextField:(UITextField *)textField
{
    textField.font=[UIFont fontWithName:FONT_SEMIBOLD size:15.0];
    textField.textColor = PRIMARYTEXT;
}

+ (void)fontForTextView:(UITextView *)textView{
    
    textView.font=[UIFont fontWithName:FONT_SEMIBOLD size:14.0];
    textView.textColor = SECONDARYTEXT;
}

+ (void)otpVerificationTextField:(UITextField *)textField
{
    textField.font=[UIFont fontWithName:FONT_SEMIBOLD size:15.0];
    textField.textColor = WHITE;
    textField.backgroundColor = SECONDARYTEXT;
    textField.clipsToBounds = YES;
    textField.layer.cornerRadius = 3;
}

+ (void)placeHolder:(UITextField *)textField withPlaceholderString:(NSString *)text
{
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        UIColor *color = RGB(211, 211, 211);
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

+ (void)animateLabel:(UILabel *)label
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // moves label up 100 units in the y axis
                         label.transform = CGAffineTransformMakeTranslation(0, -30);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // move label back down to its original position
                                              label.transform = CGAffineTransformMakeTranslation(0, 5);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.2
                                                                    delay:0
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   // move label back down to its original position
                                                                   label.transform = CGAffineTransformMakeTranslation(0,-2);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.2
                                                                                         delay:0
                                                                                       options:UIViewAnimationOptionCurveEaseOut
                                                                                    animations:^{
                                                                                        // move label back down to its original position
                                                                                        label.transform = CGAffineTransformMakeTranslation(0,0);
                                                                                    }
                                                                                    completion:nil];
                                                               }];
                                          }];
                     }];
}

+ (void)circleView:(UIView *)cirecleView
{
    
    cirecleView.clipsToBounds = YES;
    cirecleView.layer.cornerRadius = cirecleView.frame.size.width/2;
}

+ (void)fontTextView:(UITextView *)textView{
    
    textView.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
    textView.textColor = PRIMARYCOLOR;
}

@end
