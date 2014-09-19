//
//  XLBarSwipeContainerController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLBarSwipeContainerController.h"

@interface XLBarSwipeContainerController ()

@end

@implementation XLBarSwipeContainerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.swipeBar.superview){
        [self.view addSubview:self.swipeBar];
    }
    else{
        [self.swipeBar setOptionsAmount:[self.dataSource swipeContainerControllerViewControllers:self].count animated:NO];
        [self.swipeBar moveToIndex:self.currentIndex animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(XLSwipeBarView *)swipeBar
{
    if (_swipeBar) return _swipeBar;
    _swipeBar = [[XLSwipeBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5.0f) optionsAmount:[self.dataSource swipeContainerControllerViewControllers:self].count selectedOptionIndex:self.currentIndex];
    _swipeBar.backgroundColor = [UIColor orangeColor];
    _swipeBar.selectedBar.backgroundColor = [UIColor blackColor];
    _swipeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _swipeBar;
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController willShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
    [self.swipeBar moveToIndex:[self.swipeViewControllers indexOfObject:controller] animated:YES];
}

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController didShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
    [self.swipeBar moveToIndex:[self.swipeViewControllers indexOfObject:controller] animated:YES];
}


@end
