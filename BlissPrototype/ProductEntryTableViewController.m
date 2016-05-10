//
//  ProductEntryTableViewController.m
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import "ProductEntryTableViewController.h"
#import "ProductEntryTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <Mantle/Mantle.h>
#import "GooglePlaceResult.h"
#import "PlaceResultsTableViewController.h"
#import "NSString+URLEncoding.h"

@import WebKit;
@import GoogleMaps;

#define TABLEVIEW_CELL_PRODUCT_ENTRY @"TABLEVIEW_CELL_PRODUCT_ENTRY"
@interface ProductEntryTableViewController () <UITextFieldDelegate, CLLocationManagerDelegate,PlaceResultsSelectionDelegate,WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) GooglePlaceResult *selectedPlace;
@property (strong, nonatomic) NSString *storeWebsite;
@property (nonatomic,strong) WKWebView *shopWKWebView;
@end

@implementation ProductEntryTableViewController
{
    NSArray *resultsFromSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //asking for location permission
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductEntryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TABLEVIEW_CELL_PRODUCT_ENTRY];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 454;
    self.navigationItem.title = @"Edit your product info";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Nav method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PlaceResultsTableViewController class]])
    {
        ((PlaceResultsTableViewController *)segue.destinationViewController).places = resultsFromSearch;
        ((PlaceResultsTableViewController *)segue.destinationViewController).delegate = self;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL_PRODUCT_ENTRY forIndexPath:indexPath];
    cell.storeNameTextField.delegate = self;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchForStoresWithKeyword:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Google Places 
- (void)searchForStoresWithKeyword:(NSString *)keyword {
    if (self.latitude && self.longitude)
    {
        NSString  *requestURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=2000&keyword=%@&types=store&key=AIzaSyCxsjqeViR9uh1lWNJH5m-Nb6tVGoFw500",self.latitude.floatValue, self.longitude.floatValue,keyword];
        requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSMutableArray *places = [NSMutableArray new];
                for (NSDictionary *resultDictionary in [responseObject objectForKey:@"results"])
                {
                    NSError *error;
                    GooglePlaceResult *placeResult = [MTLJSONAdapter modelOfClass:[GooglePlaceResult class] fromJSONDictionary:resultDictionary error:&error];
                    if (!error)
                        [places addObject:placeResult];
                }
                resultsFromSearch = places;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"selectPlace" sender:self];
                });
            }
            else {
                NSLog(@"Places API error");
            }
        }] resume];
    }
}

#pragma mark - Core Location Manager
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *usersLocation = [locations firstObject];
    if (usersLocation)
    {
        CLLocationDegrees usersLatitude = usersLocation.coordinate.latitude;
        self.latitude = [NSNumber numberWithDouble:usersLatitude];
        
        CLLocationDegrees usersLongitude = usersLocation.coordinate.longitude;
        self.longitude = [NSNumber numberWithDouble:usersLongitude];
    }
    [self.locationManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - PlaceResultsDelegate

-(void)placeSelected:(GooglePlaceResult *)selectedResult{
    self.selectedPlace = selectedResult;
    ProductEntryTableViewCell *mainCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    mainCell.storeNameTextField.text = self.selectedPlace.name;
    [self.navigationController popViewControllerAnimated:YES];
    //make call to get additional information...
    /*
     

     */
    NSString  *requestURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&key=AIzaSyCxsjqeViR9uh1lWNJH5m-Nb6tVGoFw500",self.selectedPlace.reference];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"received place details");
            NSDictionary *responseDictionary = [responseObject objectForKey:@"result"];
            if (responseDictionary)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *website = [responseDictionary objectForKey:@"website"];
                    
                    ProductEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    [cell.websiteButton setTitle:website forState:UIControlStateNormal];
                    [cell.websiteButton setTitle:website forState:UIControlStateSelected];
                    [cell.websiteButton addTarget:self action:@selector(showWebsite) forControlEvents:UIControlEventTouchUpInside];
                    self.storeWebsite = website;

                });
                
            }
            /*
            NSMutableArray *places = [NSMutableArray new];
            for (NSDictionary *resultDictionary in [responseObject objectForKey:@"results"])
            {
                NSError *error;
                GooglePlaceResult *placeResult = [MTLJSONAdapter modelOfClass:[GooglePlaceResult class] fromJSONDictionary:resultDictionary error:&error];
                if (!error)
                    [places addObject:placeResult];
            }
            resultsFromSearch = places;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"selectPlace" sender:self];
            });
             */
        }
        else {
            NSLog(@"Places API error");
        }
    }] resume];
}

-(void)showWebsite
{
    NSLog(@"showing website");
    if (self.storeWebsite)
    {
        
        NSLog(@"Creating WKWebview for Shop");
        self.shopWKWebView = [[WKWebView alloc]initWithFrame:self.view.frame];
        [self.shopWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.storeWebsite]]];
        [self.shopWKWebView setNavigationDelegate:self];
        [self.view addSubview:self.shopWKWebView];
    }
}

#pragma mark WKWebview Delegate methods
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [self.view addSubview:loadingIndicator];
//    [self.view bringSubviewToFront:loadingIndicator];
//    [loadingIndicator startAnimating];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    [loadingIndicator removeFromSuperview];
//    [loadingIndicator stopAnimating];
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    [loadingIndicator removeFromSuperview];
//    [loadingIndicator stopAnimating];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    [loadingIndicator removeFromSuperview];
//    [loadingIndicator stopAnimating];
}

@end
