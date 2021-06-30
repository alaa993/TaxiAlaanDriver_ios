//
//  LeftMenuView.m
//  caretaker_user
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "LeftMenuView.h"
#import "LeftMenuTableViewCell.h"
#import "config.h"
#import "CSS_Class.h"
#import "Colors.h"
#import "ProfileViewController.h"
#import "Utilities.h"
@import SDWebImage;

@implementation LeftMenuView
@synthesize menuImages,menuImagesText,menuTableView;

@synthesize nameLbl,proPicImgBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setDesign];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setDesign];

}

- (void)setDesign
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    nameLbl.text =
    [NSString stringWithFormat:@"%@ %@", [defaults valueForKey:@"first_name"], [defaults valueForKey:@"last_name"]];
    
    _walletIdLabel.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"WalletId"), [defaults valueForKey:@"wallet_id"]];
    _balanceLabel.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"Balance"), [defaults valueForKey:@"balance"]];
    
    _labelCode.text = [NSString stringWithFormat:@"%@: %@",LocalizedString(@"IntroducerCode"), [defaults valueForKey:@"share_key"]];
    NSString *imageUrl = [defaults valueForKey:@"avatar"];
  
    NSInteger theHighScore = [defaults integerForKey:@"prograss"];
    if (theHighScore == 2){
        [_prograssIndicator  setHidden:YES];
        
    }else {
        [_prograssIndicator  setHidden:NO];
        [_prograssIndicator startAnimating];
    }
    
    NSString *statusStr = [defaults valueForKey:@"status"];
    if ([statusStr isEqualToString:@"onboarding"])
    {
        [_menuImg setImage:[UIImage imageNamed:@"yellow"]];
    }
    else if ([statusStr isEqualToString:@"approved"])
    {
        [_menuImg setImage:[UIImage imageNamed:@"green"]];
    }
    else
    {
        [_menuImg setImage:[UIImage imageNamed:@"red"]];
    }
    
    self.proPicImgBtn.layer.cornerRadius=self.proPicImgBtn.frame.size.height/2;
    self.proPicImgBtn.clipsToBounds=YES;
    
    if (![imageUrl isKindOfClass:[NSNull class]])
    {
        //        NSString *socialStr = [defaults valueForKey:@"social_unique_id"];
        
      /*  if ([imageUrl containsString:@"http"])
        {
            NSURL *socialUrl = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:socialUrl];
            UIImage *image = [UIImage imageWithData:data];
            [self.proPicImgBtn setImage:image forState:UIControlStateNormal];
        }
        else
        {
            imageUrl = [NSString stringWithFormat:@"%@/storage%@", SERVICE_URL, imageUrl];
            NSURL *picURL = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:picURL];
            UIImage *image = [UIImage imageWithData:data];
            if (image != nil){
                [self.proPicImgBtn setImage:image forState:UIControlStateNormal];
            }else{
                [self.proPicImgBtn setImage:[UIImage imageNamed:@"user_profile"] forState:UIControlStateNormal];
            }
        }*/
        
        imageUrl = [NSString stringWithFormat:@"%@storage%@", SERVICE_URL, imageUrl];
        NSURL *picURL = [NSURL URLWithString:imageUrl];
        [self.proPicImgBtn sd_setImageWithURL:picURL forState: UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_profile"]];
    }
  

    menuImagesText= [[NSArray alloc]initWithObjects:@"Your Trips", @"Wallet",@"Earnings",@"Summary",@"Settings",@"Help",@"Share",@"Logout",nil];
    menuImages = [[NSArray alloc]initWithObjects:@"trip",@"utility",@"profit",@"summary",@"settings",@"help",@"share",@"logout",nil];
    [menuTableView reloadData];
}


#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   return [menuImagesText count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableViewCell *cell = (LeftMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LeftMenuTableViewCellID"];
    if (cell == nil)
    {
        cell = (LeftMenuTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableViewCell" owner:self options:nil] lastObject];
    }
    cell.menuImg.image=[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]];
     cell.menuLbl.text= LocalizedString([menuImagesText objectAtIndex:indexPath.row]);
    //[CSS_Class App_Header:cell.menuLbl];
    //[cell.menuLbl setTextColor:RGB(18, 18, 18)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewRedirectionString = [menuImagesText objectAtIndex:indexPath.row];
    
    if ([viewRedirectionString isEqualToString:@"Your Trips"])
    {
        [self.LeftMenuViewDelegate yourTripsView];
    }
    else if ([viewRedirectionString isEqualToString:@"Summary"])
    {
        [self.LeftMenuViewDelegate summaryView];
    }
    else if ([viewRedirectionString isEqualToString:@"Earnings"])
    {
        [self.LeftMenuViewDelegate earningsView];
    }
    else if ([viewRedirectionString isEqualToString:@"Settings"])
    {
        [self.LeftMenuViewDelegate settingsView];
    }
    else if ([viewRedirectionString isEqualToString:@"Help"])
    {
        [self.LeftMenuViewDelegate helpView];
    }
    else if ([viewRedirectionString isEqualToString:@"Share"])
    {
        [self.LeftMenuViewDelegate shareView];
    }
    else if ([viewRedirectionString isEqualToString:@"Logout"])
    {
        [self.LeftMenuViewDelegate logOut];
    } else if ([viewRedirectionString isEqualToString:@"Wallet"])
    {
        [self.LeftMenuViewDelegate wallet];
        // _vcWallet = [[WalletController alloc]init];
        //[self ]
        
    }
}

- (IBAction)proPicImgBtnAction:(id)sender
{
    [self.LeftMenuViewDelegate profileView];
}
@end
