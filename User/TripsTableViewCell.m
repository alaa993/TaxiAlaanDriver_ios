//
//  TripsTableViewCell.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "TripsTableViewCell.h"

@implementation TripsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self LocalizationUpdate];
    // Initialization code
}

-(void)LocalizationUpdate{
    _dateLbl.text = LocalizedString(@"Date");
    _timeLbl.text = LocalizedString(@"Time");
    [_cancelBtn setTitle:LocalizedString(@"Cancel ride") forState:UIControlStateNormal];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
