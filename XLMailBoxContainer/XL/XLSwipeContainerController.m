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
@property UISwipeGestureRecognizer * swipeLeftGestureRecognizer;
@property UISwipeGestureRecognizer * swipeRightGestureRecognizer;

@end

@implementation XLSwipeContainerController

@synthesize swipeViewControllers = _swipeViewControllers;
@synthesize currentIndex         = _currentIndex;
@synthesize segmentedControl     = _segmentedControl;
@synthesize swipeLeftGestureRecognizer = _swipeLeftGestureRecognizer;
@synthesize swipeRightGestureRecognizer = _swipeRightGestureRecognizer;


-(id)initWithViewControllers:(NSArray *)viewControllers{
    return [self initWithViewControllers:viewControllers currentIndex:0];
}

-(id)initWithViewControllers:(NSArray *)viewControllers currentIndex:(NSUInteger)currentIndex
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        _currentIndex = currentIndex;
        _swipeViewControllers = viewControllers;
        _swipeEnabled = YES;
        _infiniteSwipe = NO;
        _spaceBetweenViewControllers = 0;
        _animationDuration = 0.3f;
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
    if (self.swipeEnabled){
        self.swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
        self.swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
        [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
        [self.view addGestureRecognizer:self.swipeRightGestureRecognizer];
        
    }
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

-(void)moveToViewControllerAtIndex:(NSInteger)index withDirection:(XLSwipeDirection)direction
{
    
    if (self.currentIndex != index){
        UIViewController<XLSwipeContainerChildItem> * currentController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
        UIViewController<XLSwipeContainerChildItem> * newViewController = [self.swipeViewControllers objectAtIndex:index];
        NSInteger x_change = direction == XLSwipeDirectionLeft ? (self.view.frame.size.width + self.spaceBetweenViewControllers) : -(self.view.frame.size.width + self.spaceBetweenViewControllers);
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
        [UIView animateWithDuration:self.animationDuration
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
        self.currentIndex = index;
        [self.segmentedControl setSelectedSegmentIndex:index];
    }

}

-(void)moveToViewControllerAtIndex:(NSUInteger)index
{
    if (self.currentIndex < index){
        [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionRight];
    }
    else if (self.currentIndex > index){
        [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionLeft];
    }
    
}


-(void)changeSwipeViewController:(UISegmentedControl *)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    [self moveToViewControllerAtIndex:index];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    BOOL hasTopLayoutGuide    = [self respondsToSelector:@selector(topLayoutGuide)];
    BOOL hasBottomLayoutGuide = [self respondsToSelector:@selector(bottomLayoutGuide)];

    if (hasTopLayoutGuide || hasBottomLayoutGuide) {
        for (UIView * subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]){
                UIScrollView * scrollView = (UIScrollView *)subview;
                UIEdgeInsets currentInsets = scrollView.contentInset;

                CGFloat topInset    = hasTopLayoutGuide    ? self.topLayoutGuide.length    : currentInsets.top;
                CGFloat bottomInset = hasBottomLayoutGuide ? self.bottomLayoutGuide.length : currentInsets.bottom;

                scrollView.contentInset = (UIEdgeInsets){
                    .top    = topInset,
                    .bottom = bottomInset,
                    .left   = currentInsets.left,
                    .right  = currentInsets.right
                };
                scrollView.scrollIndicatorInsets = scrollView.contentInset;
            }
        }
    }
}


-(void)swipeEvent:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            if (self.currentIndex > 0){
                [self moveToViewControllerAtIndex:(self.currentIndex - 1)];
            }
            else if (self.infiniteSwipe){
                [self moveToViewControllerAtIndex:(self.swipeViewControllers.count - 1) withDirection:XLSwipeDirectionLeft];
            }
        }
        else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft){
            if (self.currentIndex < self.swipeViewControllers.count - 1){
                [self moveToViewControllerAtIndex:(self.currentIndex + 1)];
            }
            else if (self.infiniteSwipe){
                [self moveToViewControllerAtIndex:0 withDirection:XLSwipeDirectionRight];
            }
        }

    }
}


@end
