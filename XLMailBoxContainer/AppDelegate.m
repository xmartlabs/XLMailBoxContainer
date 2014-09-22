//
//  AppDelegate.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 2/26/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLSegmentedSwipeContainerController.h"
#import "MailBoxChildViewController.h"
#import "MailBoxTableChildViewController.h"

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // create child view controllers that will be managed by XLSwipeContainerController
    MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
    MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
    MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
    MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
    XLSwipeContainerController * swipeContainer = [[XLSegmentedSwipeContainerController alloc] initWithViewCurrentIndex:0 viewControllers:child_1, child_2, child_3, child_4, nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:swipeContainer];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
    
}


@end
