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

@interface XLSwipeContainerController () <UIScrollViewDelegate>

@property NSUInteger currentIndex;

@end

@implementation XLSwipeContainerController
{
    NSUInteger _currentPageAtDragging;
}

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
    if (firstViewController){                           // The first argument isn't part of the varargs list,
                                                        // so we'll handle it separately.
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
    _animationDuration = 0.3f;
    _delegate = self;
    _dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    if (!self.containerView){
        self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.view addSubview:self.containerView];
    }
    self.containerView.bounces = YES;
    [self.containerView setAlwaysBounceHorizontal:YES];
    [self.containerView setAlwaysBounceVertical:NO];
    self.containerView.scrollsToTop = NO;
    self.containerView.delegate = self;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.pagingEnabled = NO;
    self.containerView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    if (self.dataSource){
        _swipeViewControllers = [self.dataSource swipeContainerControllerViewControllers:self];
    }
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds) * self.swipeViewControllers.count, 1.0);// CGRectGetHeight(self.containerView.bounds) - self.containerView.contentInset.top - self.containerView.contentInset.bottom);
    self.containerView.contentSize = contentSize;
    
    // add child viewController
    CGFloat childPosition = [self positionForIndex:self.currentIndex];
    UIViewController * viewController = [self.swipeViewControllers objectAtIndex:self.currentIndex];;
    if (viewController){
        if ([self.delegate respondsToSelector:@selector(swipeContainerController:willShowViewController:withDirection:fromViewController:)]){
            [self.delegate swipeContainerController:self willShowViewController:viewController withDirection:XLSwipeDirectionNone fromViewController:nil];
        }
        [self addChildViewController:viewController];
        [viewController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds))];
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        if ([self.delegate respondsToSelector:@selector(swipeContainerController:didShowViewController:withDirection:fromViewController:)]){
            [self.delegate swipeContainerController:self didShowViewController:viewController withDirection:XLSwipeDirectionNone fromViewController:nil];
        }

    }
}

-(void)moveToViewControllerAtIndex:(NSInteger)index withDirection:(XLSwipeDirection)direction
{
    
    if ([self canMoveToIndex:index]){
        [self.containerView setContentOffset:CGPointMake([self positionForIndex:index], 0) animated:YES];
        /*
        UIViewController<XLSwipeContainerChildItem> * currentController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
        UIViewController<XLSwipeContainerChildItem> * newViewController = [self.swipeViewControllers objectAtIndex:index];
        NSInteger x_change = direction == XLSwipeDirectionRight ? (self.containerView.frame.size.width + self.spaceBetweenViewControllers) : -(self.containerView.frame.size.width + self.spaceBetweenViewControllers);
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
         */
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
            [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionLeft];
        }
        else if (self.currentIndex > index){
            [self moveToViewControllerAtIndex:index withDirection:XLSwipeDirectionRight];
        }
    }
    
}

-(void)moveToViewController:(UIViewController *)viewController
{
    [self moveToViewControllerAtIndex:[self.swipeViewControllers indexOfObject:viewController]];
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController willShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController didShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}

-(CGFloat)spaceBetweenViewControllers
{
    return 0;
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


-(CGFloat)positionForIndex:(NSUInteger)index
{
    return (index * (self.spaceBetweenViewControllers + CGRectGetWidth(self.containerView.bounds)));
}

-(CGFloat)positionForViewController:(UIViewController *)viewController
{
    NSInteger index = [self.swipeViewControllers indexOfObject:viewController];
    if (index == NSNotFound){
        @throw [NSException exceptionWithName:NSRangeException reason:nil userInfo:nil];
    }
    return [self positionForIndex:index];
}

-(NSUInteger)pageForContentOffset:(CGFloat)contentOffset
{
    return (contentOffset + ([self spaceBetweenViewControllers] / 2.0) + (0.5f * [self pageWidth])) / [self pageWidth];
}

-(CGFloat)pageWidth
{
    return [self spaceBetweenViewControllers] + CGRectGetWidth(self.containerView.bounds);
}


#pragma mark - UIScrollViewDelegte

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.swipeViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController * childController = (UIViewController *)obj;
        CGFloat childPosition = [self positionForViewController:childController];
        
        if (fabs(scrollView.contentOffset.x - childPosition) <= CGRectGetWidth(self.containerView.bounds)){
            if (![childController parentViewController]){
                [self addChildViewController:childController];
                [childController didMoveToParentViewController:self];
                [childController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds))];
                childController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [self.containerView addSubview:childController.view];
            }
        }
        else{
            if ([childController parentViewController]){
                [childController.view removeFromSuperview];
                [childController willMoveToParentViewController:nil];
                [childController removeFromParentViewController];
            }
        }
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // called on finger up as we are moving
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // called when scroll view grinds to a halt
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.x;
    _currentPageAtDragging = [self pageForContentOffset:currentOffset];
}


// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSUInteger page = _currentPageAtDragging;
    NSUInteger targetPage = [self pageForContentOffset:targetContentOffset->x];
    if (targetPage > page || targetPage < page){
        targetPage = page + (targetPage > page ? 1 : -1);
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        targetContentOffset->x = [self positionForIndex:targetPage];
    }
    else{
        if (velocity.x > 0){
            targetPage = MIN(0, page - 1);
            scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        }
        else if (velocity.x < 0){
            targetPage = MAX(page + 1, self.swipeViewControllers.count - 1);
            scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        }
        else{
            scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        }
        // Need to call this subsequently to remove flickering. Strange.]
        targetContentOffset->x = [self positionForIndex:targetPage];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [scrollView setContentOffset:CGPointMake(targetContentOffset->x, 0) animated:YES];
//        });
    }
    
}

@end
