//
//  MailBoxChildViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 2/26/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxTableChildViewController.h"

@interface MailBoxTableChildViewController ()

@end

@implementation MailBoxTableChildViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld item", (long)indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - XLSwipeContainerItemDelegate

-(id)swipeContainerItemAssociatedSegmentedItem
{
    return @"Table";
}

-(UIColor *)swipeContainerItemAssociatedColor
{
    return [UIColor blueColor];
}

@end
