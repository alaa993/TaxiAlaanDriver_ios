//
//  Theme.h
//  FoodieUser
//
//  Created by apple on 9/5/17.
//  Copyright © 2017 Tanjara Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "config.h"

@interface Theme : NSObject

#define SIZE_PRIMARY 16
#define SIZE_PRIMARYDESC 14
#define SIZE_SECONDARY 14
#define SIZE_SECONDARYDESC 12

extern NSString *const FONT_BLACK;
extern NSString *const FONT_BOLD;
extern NSString *const FONT_EXTRABOLD;
extern NSString *const FONT_EXTRALIGHT;
extern NSString *const FONT_LIGHT;
extern NSString *const FONT_MEDIUM;
extern NSString *const FONT_REGULAR;
extern NSString *const FONT_SEMIBOLD;

+ (void)viewShadowDesign:(UIView *)shadowView;

+ (void)setViewBorder:(UIView *)view isLeft:(BOOL )leftBorder isRight:(BOOL )rightBorder isTop:(BOOL )topBorder isBottom:(BOOL )bottomBorder size:(CGFloat)sizevalue xspace:(CGFloat)spacevalue;

+ (void)dottedBorderView:(UIView *)view;

+ (void)primaryButton:(UIButton *)button;

+ (void)secondaryButton:(UIButton *)button;

+ (void)baseButtonWhite:(UIButton *)button;

+ (void)buttonWithoutBg:(UIButton *)button;

+ (void)buttonWithoutBgPrimary:(UIButton *)button;

+(void)cornerRadius:(UIView *)forView forLabel:(UILabel *)label fortextfield:(UITextField *)textField forButton:(UIButton *)button;


+ (void)navigationTitle:(UILabel *)label;

+ (void)header:(UILabel *)label;

+ (void)subHeader:(UILabel *)label;

+ (void)description:(UILabel *)label;

+ (void)lightFontlabel:(UILabel *)label;

+ (void)regularFontlabel:(UILabel *)label;

+ (void)smallFontlabel:(UILabel *)label;

+ (void)animateLabel:(UILabel *)label;

+ (void)primaryLabel:(UILabel *)label;

+ (void)primaryDescLabel:(UILabel *)label;

+ (void)secondaryLabel:(UILabel *)label;

+ (void)secondaryDescLabel:(UILabel *)label;

+ (void)customLabel:(UILabel *)label lblColor:(UIColor *)color size:(CGFloat)lblSize font:(NSString *)lblfont;

+ (void)labelWhite:(UILabel *)label;

+ (void)textfieldOutfocus:(UITextField *)textField;

+ (void)textfieldInfocus:(UITextField *)textField;

+ (void)placeHolder:(UITextField *)textField withPlaceholderString:(NSString *)text;

+ (void)primaryTextField:(UITextField *)textField;

+ (void)otpVerificationTextField:(UITextField *)textField;

+ (void)attributedString:(NSString *)from to:(NSString *)to forLabel:(UILabel *)label;

+ (void)fontForTextView:(UITextView *)textView;

+ (void)circleView:(UIView *)cirecleView;

+ (void)primaryGreenButton:(UIButton *)button;

+ (void)secondaryGreenButton:(UIButton *)button;

+ (void)fontTextView:(UITextView *)textView;

@end
