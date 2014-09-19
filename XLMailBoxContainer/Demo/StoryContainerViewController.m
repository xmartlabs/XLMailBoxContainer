//
//  StoryContainerViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/18/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxTableChildViewController.h"
#import "MailBoxChildViewController.h"
#import "StoryContainerViewController.h"

@interface StoryContainerViewController ()

@end

@implementation StoryContainerViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self moveToViewControllerAtIndex:2];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.swipeBar.selectedBar setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - XLSwipe

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController
{
    // create child view controllers that will be managed by XLSwipeContainerController
    MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
    // XLSwipeNavigationController is in charge of create the cusom container view controller (XLSwipeContainerController) and add the child view controllers previously created to it.
    return @[child_1, child_2, child_3, child_4];
}

@end
