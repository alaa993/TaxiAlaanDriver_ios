//
//  LeftMenuView.h
//  caretaker_user
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewprotocol;

@interface LeftMenuView : UIView<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
{
}

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property(strong,nonatomic) NSArray *menuImages;
@property(strong,nonatomic) NSArray *menuImagesText;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UIImageView *menuImg;
@property (weak, nonatomic) IBOutlet UILabel *walletIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@property (nonatomic,retain) id <LeftMenuViewprotocol> LeftMenuViewDelegate;
@property (weak, nonatomic) IBOutlet UIButton *proPicImgBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *prograssIndicator;
    @property (weak, nonatomic) IBOutlet UILabel *labelCode;
    
@end
@protocol LeftMenuViewprotocol <NSObject>

-(void)yourTripsView;
-(void)summaryView;
-(void)helpView;
-(void)shareView;
-(void)logOut;
-(void)profileView;
-(void)earningsView;
-(void)settingsView;
-(void)wallet;

@end
