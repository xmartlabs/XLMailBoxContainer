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

@property (nonatomic) NSUInteger currentIndex;

@end

@implementation XLSwipeContainerController
{
    NSUInteger _lastPageNumber;
    CGFloat _lastContentOffset;
}

@synthesize currentIndex = _currentIndex;

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
    _lastContentOffset = 0.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.containerView.pagingEnabled = YES;
    
    if (self.dataSource){
        _swipeViewControllers = [self.dataSource swipeContainerControllerViewControllers:self];
    }
    self.containerView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds) * self.swipeViewControllers.count, 1.0);;
    
    // add child viewController
    CGFloat childPosition = [self positionForIndex:self.currentIndex];
    UIViewController * viewController = [self.swipeViewControllers objectAtIndex:self.currentIndex];
    if (viewController){
        [self addChildViewController:viewController];
        [viewController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.containerView.bounds))];
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.containerView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }
}

-(void)moveToViewControllerAtIndex:(NSInteger)index withDirection:(XLSwipeDirection)direction
{
    
    if ([self canMoveToIndex:index]){
        [self.containerView setContentOffset:CGPointMake([self positionForIndex:index], 0) animated:YES];
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

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController updateIndicatorToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController
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


-(CGFloat)positionForIndex:(NSUInteger)index
{
    return (index * CGRectGetWidth(self.containerView.bounds) + ((CGRectGetWidth(self.containerView.bounds) - CGRectGetWidth(self.view.bounds)) * 0.5));
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
    return (contentOffset + (0.5f * [self pageWidth])) / [self pageWidth];
}

-(CGFloat)pageWidth
{
    return CGRectGetWidth(self.containerView.bounds);
}


#pragma mark - UIScrollViewDelegte

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.containerView == scrollView){
        //  pan direction
        XLSwipeDirection direction = XLSwipeDirectionNone;
        if (scrollView.contentOffset.x > _lastContentOffset){
            direction = XLSwipeDirectionLeft;
        }
        else if (scrollView.contentOffset.x < _lastContentOffset){
            direction = XLSwipeDirectionRight;
        }
        NSUInteger currentPage = [self pageForContentOffset:scrollView.contentOffset.x];
        if (currentPage != self.currentIndex){
            self.currentIndex = currentPage;
        }
        _lastContentOffset = scrollView.contentOffset.x;
        //-
        [self.swipeViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController * childController = (UIViewController *)obj;
            CGFloat childPosition = [self positionForViewController:childController];
            
            if (fabs(scrollView.contentOffset.x - childPosition) < CGRectGetWidth(self.containerView.bounds)){
                if (![childController parentViewController]){
                    [self addChildViewController:childController];
                    [childController didMoveToParentViewController:self];
                    [childController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.containerView.bounds))];
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
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.containerView == scrollView){
        _lastPageNumber = [self pageForContentOffset:scrollView.contentOffset.x];
        _lastContentOffset = scrollView.contentOffset.x;
    }
}


#pragma mark - Properties


-(NSUInteger)currentIndex
{
    return _currentIndex;
}

-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    UIViewController * fromViewController = [self.swipeViewControllers objectAtIndex:_currentIndex];
    _currentIndex = currentIndex;
    // invoke delegate method
    if ([self.delegate respondsToSelector:@selector(swipeContainerController:updateIndicatorToViewController:fromViewController:)]){
        [self.delegate swipeContainerController:self updateIndicatorToViewController:[self.swipeViewControllers objectAtIndex:_currentIndex] fromViewController:fromViewController];
    }
    //
}

@end
