//
//  StoryContainerViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/18/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxTableChildViewController.h"
#import "MailBoxChildViewController.h"
#import "BarContainerViewController.h"

@interface BarContainerViewController ()
@end

@implementation BarContainerViewController
{
    NSArray * _swipeChildViewControllers;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.swipeBar.selectedBar setBackgroundColor:[UIColor orangeColor]];
    self.animationDuration = 0.3;
}

#pragma mark - XLSwipeContainerControllerDataSource

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController
{
    if (_swipeChildViewControllers) return _swipeChildViewControllers;
    // create child view controllers that will be managed by XLSwipeContainerController
    MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
    _swipeChildViewControllers = @[child_1, child_2, child_3, child_4];
    return _swipeChildViewControllers;
}

@end
