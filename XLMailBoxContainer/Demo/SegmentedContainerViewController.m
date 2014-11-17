//
//  SegmentedContainerViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/21/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxChildViewController.h"
#import "MailBoxTableChildViewController.h"
#import "SegmentedContainerViewController.h"

@interface SegmentedContainerViewController ()

@end

@implementation SegmentedContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - XLSwipe

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController
{
    // create child view controllers that will be managed by XLSwipeContainerController
    MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
    return @[child_1, child_2, child_3, child_4];
}


-(CGFloat)spaceBetweenViewControllers
{
    return 150.0;
}

@end
