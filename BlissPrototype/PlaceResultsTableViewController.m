//
//  PlaceResultsTableViewController.m
//  Bliss
//
//  Created by Corey Zanotti on 5/6/16.
//  Copyright © 2016 Corey Zanotti. All rights reserved.
//

#import "PlaceResultsTableViewController.h"

@interface PlaceResultsTableViewController ()

@end
#define TABLEVIEW_CELL_STORE @"TABLEVIEW_CELL_STORE"
@implementation PlaceResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Store";
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TABLEVIEW_CELL_STORE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TABLEVIEW_CELL_STORE];
    
    GooglePlaceResult *resultForCell = [self.places objectAtIndex:indexPath.row];
    [cell.textLabel setText:resultForCell.name];
    [cell.detailTextLabel setText:resultForCell.vicinity];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(placeSelected:)])
    {
        [self.delegate placeSelected:[self.places objectAtIndex:indexPath.row]];
    }
}

@end
