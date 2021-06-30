//
//  LanguageController.h
//  Provider
//
//  Created by CSS on 13/09/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageview;

@end

@interface LanguageHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectiontitleLbl;

@end


@interface LanguageController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSString * page_identifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstrains;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrains;
@property (weak, nonatomic) IBOutlet UITableView *languageTable;
@property(strong,nonatomic)NSArray * LanguageArray;
- (IBAction)submitBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
