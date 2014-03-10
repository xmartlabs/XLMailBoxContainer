//
//  XLSwipeContainerController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 10/1/13.
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

#import "XLSwipeNavigationController.h"
#import "XLSwipeContainerController.h"

@interface XLSwipeContainerController ()

@property NSUInteger currentIndex;
@property (nonatomic) UISegmentedControl * segmentedControl;

@end

@implementation XLSwipeContainerController

@synthesize swipeViewControllers = _swipeViewControllers;
@synthesize currentIndex         = _currentIndex;
@synthesize segmentedControl     = _segmentedControl;


-(id)initWithViewControllers:(NSArray *)viewControllers{
    return [self initWithViewControllers:viewControllers currentIndex:0];
}

-(id)initWithViewControllers:(NSArray *)viewControllers currentIndex:(NSUInteger)currentIndex
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        _currentIndex = currentIndex;
        _swipeViewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIViewController * viewController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
    // add child viewController
    [self addChildViewController:viewController];
    [viewController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:viewController.view];
    // add segmented control
    [self.navigationItem setTitleView:self.segmentedControl];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIViewController<XLSwipeContainerChildItem> * currentController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
    if (self.navigationController){
        [self.navigationController.navigationBar setTintColor:[currentController swipeContainerItemAssociatedColor]];
    }
    else{
        [_segmentedControl setTintColor:[currentController swipeContainerItemAssociatedColor]];
    }
    [_segmentedControl addTarget:self
                          action:@selector(changeSwipeViewController:)
                forControlEvents:UIControlEventValueChanged];
    return _segmentedControl;
}


-(void)changeSwipeViewController:(UISegmentedControl *)sender
{
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    if (self.currentIndex != selectedIndex){
        UIViewController<XLSwipeContainerChildItem> * currentController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
        UIViewController<XLSwipeContainerChildItem> * newViewController = [self.swipeViewControllers objectAtIndex:selectedIndex];
        NSInteger x_change = self.currentIndex > selectedIndex ? self.view.frame.size.width : -self.view.frame.size.width;
        [newViewController.view setFrame:CGRectMake(-x_change, 0, self.view.frame.size.width, self.view.frame.size.height)];
        newViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (self.navigationController){
            [self.navigationController.navigationBar setTintColor:[newViewController swipeContainerItemAssociatedColor]];
        }
        else{
            [self.segmentedControl setTintColor:[newViewController swipeContainerItemAssociatedColor]];
        }
        [self addChildViewController:newViewController];
        [self.view addSubview:newViewController.view];
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [currentController.view setFrame:CGRectMake(currentController.view.frame.origin.x + x_change, currentController.view.frame.origin.y, currentController.view.frame.size.width, currentController.view.frame.size.height)];
                             [newViewController.view setFrame:CGRectMake(0, newViewController.view.frame.origin.y, newViewController.view.frame.size.width, newViewController.view.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 [currentController removeFromParentViewController];
                                 [currentController.view removeFromSuperview];
                                 [newViewController didMoveToParentViewController:self];
                             }

                         }];
        self.currentIndex = selectedIndex;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        for (UIView * subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]){
                UIScrollView * scrollView = (UIScrollView *)subview;
                UIEdgeInsets currentInsets = scrollView.contentInset;
                scrollView.contentInset = (UIEdgeInsets){
                    .top = self.topLayoutGuide.length,
                    .bottom = currentInsets.bottom,
                    .left = currentInsets.left,
                    .right = currentInsets.right
                };
                scrollView.scrollIndicatorInsets = scrollView.contentInset;
            }
        }
    }
}


@end
