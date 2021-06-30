//
//  CountryCodeController.m
//  FoodieUser
//
//  Created by infos on 9/27/17.
//  Copyright © 2017 Tanjara Infotech. All rights reserved.
//

#import "CountryCodeController.h"
#import "CountryCodeCell.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define kCountryName        @"name"
#define kCountryCallingCode @"dial_code"
#define kCountryCode        @"code"

@interface CountryCodeController ()

@end

@implementation CountryCodeController
{
    NSArray *countriesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self parseJSON];
    _countrySearchBar.delegate = self;
     self.countryTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countryCodes" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    countriesList = (NSArray *)parsedObject;
    
    [_countryTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        isFiltered=NO;
    }
    else{
        isFiltered=YES;
        filteredstring=[[NSMutableArray alloc]init];
        
        for(NSDictionary *sortArray in countriesList)
        {
            NSString *countryName = [sortArray objectForKey: kCountryName];
            NSString *codeName = [sortArray objectForKey:kCountryCode];
            NSString *dialCode = [sortArray objectForKey:kCountryCallingCode];
            NSRange range = [countryName rangeOfString:searchText options:NSNumericSearch];
            NSRange range1 = [codeName rangeOfString:searchText options:NSNumericSearch];
            NSRange range2 = [dialCode rangeOfString:searchText options:NSNumericSearch];
            if(range.location != NSNotFound||range1.location != NSNotFound||range2.location != NSNotFound)
                [filteredstring addObject:sortArray];
        }
        [self.countryTableView reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.view endEditing:YES];

    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];

    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.countryTableView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered) {
        return [filteredstring count];
    }
    
    return countriesList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CountryCodeCell";
    
    CountryCodeCell *cell = (CountryCodeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCodeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *countryCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryCode]];
    
    NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
    
    UIImage *image = [UIImage imageNamed:imagePath];
    if(!isFiltered){
        cell.countryNameLbl.text = [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryName];
        cell.countryCodeLbl.text = [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode];
        cell.flagImageView.image = image;
    }
    else{
        NSString *countryCode = [NSString stringWithFormat:@"%@", [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryCode]];
        NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
        UIImage *image = [UIImage imageNamed:imagePath];
        cell.countryNameLbl.text = [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryName];
        cell.countryCodeLbl.text = [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode];
        cell.flagImageView.image = image;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isFiltered){
        NSString *countryCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryCode]];
        
        NSString *countryName = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryName]];
        
        NSString *countryCallingCode = [NSString stringWithFormat:@"%@", [[countriesList objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];
        
        NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
        
        [[NSUserDefaults standardUserDefaults] setValue:countryCallingCode forKey:@"dial_code"];
        [[NSUserDefaults standardUserDefaults] setValue:imagePath forKey:@"country_flag"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isFlag"];
         [_delegate codeCountryMetode:countryCode :countryName :countryCallingCode];
        NSLog(@"Selected Country : %@, %@, %@", countryCode, countryName, countryCallingCode);
    }
    else{
        NSString *countryCode = [NSString stringWithFormat:@"%@", [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryCode]];
        
        NSString *countryName = [NSString stringWithFormat:@"%@", [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryName]];
        
        NSString *countryCallingCode = [NSString stringWithFormat:@"%@", [[filteredstring objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];
        
        NSString *imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", countryCode];
        
        [[NSUserDefaults standardUserDefaults] setValue:countryCallingCode forKey:@"dial_code"];
        [[NSUserDefaults standardUserDefaults] setValue:imagePath forKey:@"country_flag"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isFlag"];
         [_delegate codeCountryMetode:countryCode :countryName :countryCallingCode];
        NSLog(@"Selected Country : %@, %@, %@", countryCode, countryName, countryCallingCode);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.countryTableView reloadData];
}


#pragma mark - Country code methods

+ (NSArray *)countryNames
{
    static NSArray *_countryNames = nil;
    if (!_countryNames)
    {
        _countryNames = [[[self countryNamesByCode].allValues sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] copy];
    }
    return _countryNames;
}

+ (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes)
    {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
            
            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }
            
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

@end
