//
//  FirstViewController.m
//  BlissPrototype
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface FirstViewController ()<GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) GMSAutocompleteViewController *autoCompleteViewController;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@end

@implementation FirstViewController
{
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient = [[GMSPlacesClient alloc] init];
    
    
    //asking for location permission
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
- (IBAction)searchForStores:(id)sender {
    if (self.latitude && self.longitude)
    {
        NSString  *requestURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=2000&types=establishment&key=AIzaSyCxsjqeViR9uh1lWNJH5m-Nb6tVGoFw500",self.latitude.floatValue, self.longitude.floatValue];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
                NSLog(@"%@",responseObject);
//                NSDictionary *routes = object["results"] as! [NSDictionary]
//                for route in routes {
//                    println(route["name"])
//                }
            }
            else {
                NSLog(@"Places API error");
            }
        }] resume];
    }
}

- (IBAction)showPickerAutoCompleteViewController:(id)sender {
//    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
//        if (error != nil) {
//            NSLog(@"Pick Place error %@", [error localizedDescription]);
//            return;
//        }
//        
//        self.nameLabel.text = @"No current place";
//        self.addressLabel.text = @"";
//        
//        if (placeLikelihoodList != nil) {
//            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
//            if (place != nil) {
//                self.nameLabel.text = place.name;
//                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
//                                          componentsJoinedByString:@"\n"];
//            }
//        }
//    }];
    if (self.latitude && self.longitude)
    {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                      center.longitude + 0.001);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                      center.longitude - 0.001);
        GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                             coordinate:southWest];
        GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
        _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
        
        [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
            if (error != nil) {
                NSLog(@"Pick Place error %@", [error localizedDescription]);
                return;
            }
            
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress
                                           componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            } else {
                self.nameLabel.text = @"No place selected";
                self.addressLabel.text = @"";
            }
        }];
    }
}

#pragma mark - GMSAutoComplete stuff
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

@end
