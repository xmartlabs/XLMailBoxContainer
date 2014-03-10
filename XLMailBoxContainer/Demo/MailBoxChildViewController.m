//
//  AMailBoxChildViewController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 2/26/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "MailBoxChildViewController.h"

@interface MailBoxChildViewController ()

@end

@implementation MailBoxChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.text = @"XLMailBoxContainer";
    [self.view addSubview:label];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}


#pragma mark - XLSwipeContainerItemDelegate

-(id)swipeContainerItemAssociatedSegmentedItem
{
    return @"View";
}

-(UIColor *)swipeContainerItemAssociatedColor
{
    return [UIColor orangeColor];
}

@end
