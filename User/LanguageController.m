//
//  LanguageController.m
//  Provider
//
//  Created by CSS on 13/09/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "LanguageController.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "Provider-Swift.h"
@implementation LanguageCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end

@implementation LanguageHeader

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end

@interface LanguageController ()

@end

@implementation LanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _LanguageArray = @[@{@"name":@"English",@"code":@"en"},@{@"name":@"Arabic",@"code":@"ar"},@{@"name":@"Kurdish",@"code":@"ckb"}];
    _heightConstrains.constant = (_LanguageArray.count * 44) + 110;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"SelectLanguageIndex"]==nil){
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:0] forKey:@"SelectLanguageIndex"];
        [[NSUserDefaults standardUserDefaults]setObject:_LanguageArray[0][@"code"] forKey:@"LanguageCode"];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([_page_identifier isEqualToString:@"Profile"]){
        _tableTopConstrains.constant = 50;
    }else{
        _tableTopConstrains.constant = 0;

    }
    [self LocalizationUpdate];
}

-(void)LocalizationUpdate{
   
    _nameTitleLbl.text = LocalizedString(@"Change Language");
    [_submitBtn setTitle:LocalizedString(@"SUBMIT") forState:UIControlStateNormal];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _LanguageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LanguageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LanguageCell" forIndexPath:indexPath];
    cell.nameLbl.text =  _LanguageArray[indexPath.row][@"name"];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectLanguageIndex"]integerValue] == indexPath.row){
        cell.selectedImageview.image = [UIImage imageNamed:@"check-mark"];
    }else{
        cell.selectedImageview.image = [UIImage imageNamed:@"check-box-empty"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LanguageHeader * header = [tableView dequeueReusableCellWithIdentifier:@"LanguageHeader"];
    header.sectiontitleLbl.text = LocalizedString(@"Select your language");
    return  header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"SelectLanguageIndex"];
    [[NSUserDefaults standardUserDefaults]setObject:_LanguageArray[indexPath.row][@"code"] forKey:@"LanguageCode"];
    LocalizationSetLanguage(_LanguageArray[indexPath.row][@"code"]);
   // LocaleManager.apply(identifier: _LanguageArray[indexPath.row][@"code"])
    
    [self LocalizationUpdate];
    [tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitBtnAction:(UIButton *)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    if([self.page_identifier isEqualToString:@"Profile"]){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        ViewController* infoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:infoController animated:YES];
    }
   
    
   
}
- (IBAction)BackBtNAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
