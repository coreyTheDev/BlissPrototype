//
//  NSString+URLEncoding.m
//  Bliss
//
//  Created by Corey Zanotti on 5/9/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForRFC3986 {
    NSString *unreserved = @"-._~/?:";
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                      alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    return [self
            stringByAddingPercentEncodingWithAllowedCharacters:
            allowed];
}
@end
