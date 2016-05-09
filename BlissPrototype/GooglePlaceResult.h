//
//  GooglePlaceResult.h
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GooglePlaceResult : MTLModel <MTLJSONSerializing>;
@property (strong, nonatomic, readonly) NSString *generalId;
@property (strong, nonatomic, readonly) NSString *placeId;
@property (strong, nonatomic, readonly) NSNumber *rating;;
@property (strong, nonatomic, readonly) NSString *vicinity;
@property (strong, nonatomic, readonly) NSNumber *priceLevel;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *reference;
@property (strong, nonatomic, readonly) NSString *icon;
@property (strong, nonatomic, readonly) NSString *scope;
//not currently getting photos, geometry, types, opening hours
@end
