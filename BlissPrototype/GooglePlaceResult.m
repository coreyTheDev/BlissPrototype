//
//  GooglePlaceResult.m
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import "GooglePlaceResult.h"

@implementation GooglePlaceResult
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"generalId": @"id",
             @"placeId": @"place_id",
             @"rating": @"rating",
             @"vicinity": @"vicinity",
             @"scope": @"scope",
             @"priceLevel": @"price_level",
             @"name": @"name",
             @"reference" : @"reference",
             @"icon": @"icon"
             };
}
@end
