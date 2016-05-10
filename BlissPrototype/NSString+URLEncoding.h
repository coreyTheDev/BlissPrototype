//
//  NSString+URLEncoding.h
//  Bliss
//
//  Created by Corey Zanotti on 5/9/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForRFC3986;
@end
