//
//  XLSwipeContainerController.m
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

@interface XLSwipeContainerController ()

@property NSUInteger currentIndex;
@property UISwipeGestureRecognizer * swipeLeftGestureRecognizer;
@property UISwipeGestureRecognizer * swipeRightGestureRecognizer;

@end

@implementation XLSwipeContainerController


-(id)initWithViewControllers:(NSArray *)viewControllers{
    return [self initWithViewControllers:viewControllers currentIndex:0];
}

-(id)initWithViewControllers:(NSArray *)viewControllers currentIndex:(NSUInteger)currentIndex
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        _currentIndex = currentIndex;
        _swipeViewControllers = viewControllers;
    }
    return self;
}

-(id)initWithViewCurrentIndex:(NSUInteger)index viewControllers:(UIViewController *)firstViewController, ...
{
    id eachObject;
    va_list argumentList;
    NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
    if (firstViewController)                            // The first argument isn't part of the varargs list,
    {                                                   // so we'll handle it separately.
        [mutableArray addObject:firstViewController];
        va_start(argumentList, firstViewController);    // Start scanning for arguments after firstViewController.
        while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
            [mutableArray addObject:eachObject];        // that isn't nil, add it to self's contents.
        va_end(argumentList);
    }
    return [self initWithViewControllers:[mutableArray copy] currentIndex:index];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self swipeInit];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self swipeInit];
    }
    return self;
}


-(void)swipeInit
{
    _currentIndex = 0;
    _swipeEnabled = YES;
    _infiniteSwipe = YES;
    _spaceBetweenViewControllers = 0;
    _animationDuration = 0.3f;
    _delegate = self;
    _dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (!self.containerView){
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.containerView];
    }
    if (self.dataSource){
        _swipeViewControllers = [self.dataSource swipeContainerControllerViewControllers:self];
    }
    // add child viewController
    UIViewController * viewController = [self.swipeViewControllers objectAtIndex:self.currentIndex];;
    if (viewController){
        if ([self.delegate respondsToSelector:@selector(swipeContainerController:willShowViewController:withDirection:fromViewController:)]){
            [self.delegate swipeContainerController:self willShowViewController:viewController withDirection:XLSwipeDirectionRight fromViewController:nil];
        }
        [self addChildViewController:viewController];
        [viewController.view setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.containerView addSubview:viewController.view];
        if ([self.delegate respondsToSelector:@selector(swipeContainerController:didShowViewController:withDirection:fromViewController:)]){
            [self.delegate swipeContainerController:self didShowViewController:viewController withDirection:XLSwipeDirectionRight fromViewController:nil];
        }

    }
    if (self.swipeEnabled){
        self.swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
        self.swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
        [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.containerView addGestureRecognizer:self.swipeLeftGestureRecognizer];
        [self.containerView addGestureRecognizer:self.swipeRightGestureRecognizer];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)moveToViewControllerAtIndex:(NSInteger)index withDirection:(XLSwipeDirection)direction
{
    
    if ([self canMoveToIndex:index]){
        UIViewController<XLSwipeContainerChildItem> * currentController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
        UIViewController<XLSwipeContainerChildItem> * newViewController = [self.swipeViewControllers objectAtIndex:index];
        NSInteger x_change = direction == XLSwipeDirectionLeft ? (self.containerView.frame.size.width + self.spaceBetweenViewControllers) : -(self.containerView.frame.size.width + self.spaceBetweenViewControllers);
        [newViewController.view setFrame:CGRectMake(-x_change, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
        newViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if ([self.delegate respondsToSelector:@selector(swipeContainerController:willShowViewController:withDirection:fromViewController:)]){
            [self.delegate swipeContainerController:self willShowViewController:newViewController withDirection:direction fromViewController:currentController];
        }
        [self addChildViewController:newViewController];
        [self.containerView addSubview:newViewController.view];
        __typeof__(self) __weak weakSelf = self;
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
                                 [newViewController didMoveToParentViewController:weakSelf];
                                 if ([weakSelf.delegate respondsToSelector:@selector(swipeContainerController:didShowViewController:withDirection:fromViewController:)]){
                                     [weakSelf.delegate swipeContainerController:weakSelf didShowViewController:newViewController withDirection:direction fromViewController:currentController];
                                 }
                             }
                         }];
        self.currentIndex = index;
    }

}

-(void)moveToViewControllerAtIndex:(NSUInteger)index
{
    if (![self isViewLoaded]){
        self.currentIndex = index;
    }
    else{
        if (self.currentIndex < index){
            [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionRight];
        }
        else if (self.currentIndex > index){
            [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionLeft];
        }
    }
    
}

//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    BOOL hasTopLayoutGuide    = [self respondsToSelector:@selector(viewDidLayoutSubviews)];
//    BOOL hasBottomLayoutGuide = [self respondsToSelector:@selector(bottomLayoutGuide)];
//
//    if (hasTopLayoutGuide || hasBottomLayoutGuide) {
//        for (UIView * subview in self.containerView.subviews) {
//            if ([subview isKindOfClass:[UIScrollView class]]){
//                UIScrollView * scrollView = (UIScrollView *)subview;
//                UIEdgeInsets currentInsets = scrollView.contentInset;
//
//                CGFloat topInset    = hasTopLayoutGuide    ? self.topLayoutGuide.length    : currentInsets.top;
//                CGFloat bottomInset = hasBottomLayoutGuide ? self.bottomLayoutGuide.length : currentInsets.bottom;
//
//                scrollView.contentInset = (UIEdgeInsets){
//                    .top    = topInset,
//                    .bottom = bottomInset,
//                    .left   = currentInsets.left,
//                    .right  = currentInsets.right
//                };
//                scrollView.scrollIndicatorInsets = scrollView.contentInset;
//            }
//        }
//    }
//}


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

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController willShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController didShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}


#pragma mark - XLSwipeContainerControllerDataSource

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController
{
    return self.swipeViewControllers;
}


#pragma mark - Helpers

-(BOOL)canMoveToIndex:(NSUInteger)index
{
    return (self.currentIndex != index && self.delegate && self.swipeViewControllers.count > index);
}


@end
