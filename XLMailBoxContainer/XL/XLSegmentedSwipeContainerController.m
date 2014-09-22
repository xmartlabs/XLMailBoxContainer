//
//  XLSegmentedSwipeContainerController.m
//  XLMailBoxContainer ( https://github.com/xmartlabs/XLMailBoxContainer )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLSwipeContainerController.h"
#import "XLSegmentedSwipeContainerController.h"

@interface XLSegmentedSwipeContainerController () <XLSwipeContainerControllerDelegate>

@property (nonatomic) UISegmentedControl * segmentedControl;

@end

@implementation XLSegmentedSwipeContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    // add segmented control
    [self.navigationItem setTitleView:self.segmentedControl];
    self.delegate = self;
}



-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl) return _segmentedControl;
    NSMutableArray * segmentedControlItems = [[NSMutableArray alloc] init];
    for (UIViewController<XLSwipeContainerChildItem> * swipContainerItemVC in self.swipeViewControllers){
        [segmentedControlItems addObject:swipContainerItemVC.swipeContainerItemAssociatedSegmentedItem];
    }
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    [_segmentedControl setSelectedSegmentIndex:self.currentIndex];
    [_segmentedControl addTarget:self
                          action:@selector(changeSwipeViewController:)
                forControlEvents:UIControlEventValueChanged];
    return _segmentedControl;
}


-(void)changeSwipeViewController:(UISegmentedControl *)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    [self moveToViewControllerAtIndex:index];
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController willShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
    if ([controller conformsToProtocol:@protocol(XLSwipeContainerChildItem)]){
        UIViewController<XLSwipeContainerChildItem> * swipContainerItemVC = (UIViewController<XLSwipeContainerChildItem> *)controller;
        if (self.navigationController){
            [self.navigationController.navigationBar setTintColor:[swipContainerItemVC swipeContainerItemAssociatedColor]];
        }
        else{
            [_segmentedControl setTintColor:[swipContainerItemVC swipeContainerItemAssociatedColor]];
        }
    }
    [self.segmentedControl setSelectedSegmentIndex:[self.swipeViewControllers indexOfObject:controller]];
}


-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController didShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}

@end
