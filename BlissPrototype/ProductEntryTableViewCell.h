//
//  ProductEntryTableViewCell.h
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductEntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;

@end
