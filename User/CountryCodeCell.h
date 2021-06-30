//
//  CountryCodeCell.h
//  FoodieUser
//
//  Created by infos on 9/27/17.
//  Copyright © 2017 Tanjara Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UILabel *countryNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLbl;

@end
