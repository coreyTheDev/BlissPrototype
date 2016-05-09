//
//  PlaceResultsTableViewController.h
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlaceResult.h"
@protocol PlaceResultsSelectionDelegate<NSObject>
-(void)placeSelected:(GooglePlaceResult *)selectedResult;
@end
@interface PlaceResultsTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *places;
@property (weak, nonatomic) id<PlaceResultsSelectionDelegate> delegate;
@end
