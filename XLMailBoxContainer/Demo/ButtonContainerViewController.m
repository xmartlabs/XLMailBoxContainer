//
//  ButtonContainerViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/28/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxTableChildViewController.h"
#import "MailBoxChildViewController.h"
#import "ButtonContainerViewController.h"

@interface ButtonContainerViewController ()

@end

@implementation ButtonContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.swipeBar.selectedBar setBackgroundColor:[UIColor orangeColor]];
}

#pragma mark - XLSwipeContainerControllerDataSource

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController
{
    // create child view controllers that will be managed by XLSwipeContainerController
    MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_5 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_6 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_7 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_8 = [[MailBoxChildViewController alloc] init];
    return @[child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8];
}

@end
