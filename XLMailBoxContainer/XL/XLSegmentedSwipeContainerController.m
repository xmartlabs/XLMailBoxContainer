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

@property (nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic) BOOL shouldUpdateSegmentedControl;

@end

@implementation XLSegmentedSwipeContainerController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.shouldUpdateSegmentedControl = YES;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.shouldUpdateSegmentedControl = YES;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // initialize segmented control
    if (!self.segmentedControl.superview) {
        [self.navigationItem setTitleView:self.segmentedControl];
    }
    [self.segmentedControl removeAllSegments];
    [self.segmentedControl addTarget:self
                              action:@selector(changeSwipeViewController:)
                    forControlEvents:UIControlEventValueChanged];
    [self.swipeViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj conformsToProtocol:@protocol(XLSwipeContainerChildItem)], @"child view controller must conform to XLSwipeContainerChildItem");
        UIViewController<XLSwipeContainerChildItem> * childViewController = (UIViewController<XLSwipeContainerChildItem> *)obj;
        if ([childViewController respondsToSelector:@selector(imageForSwipeContainer:)]){

            [self.segmentedControl insertSegmentWithImage:[childViewController imageForSwipeContainer:self]  atIndex:idx animated:NO];
        }
        else{
            [self.segmentedControl insertSegmentWithTitle:[childViewController nameForSwipeContainer:self] atIndex:idx animated:NO];
        }

    }];
    [self.segmentedControl setSelectedSegmentIndex:self.currentIndex];

}



-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl) return _segmentedControl;
    _segmentedControl = [[UISegmentedControl alloc] init];
    return _segmentedControl;
}


-(void)changeSwipeViewController:(UISegmentedControl *)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    [self swipeContainerController:self updateIndicatorToViewController:[[self.dataSource swipeContainerControllerViewControllers:self] objectAtIndex:index] fromViewController:nil];
    self.shouldUpdateSegmentedControl = NO;
    [self moveToViewControllerAtIndex:index];
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController updateIndicatorToViewController:(UIViewController *)viewController fromViewController:(UIViewController *)fromViewController
{
    if (self.shouldUpdateSegmentedControl){
        UIViewController<XLSwipeContainerChildItem> * childViewController = (UIViewController<XLSwipeContainerChildItem> *)viewController;
        if ([childViewController respondsToSelector:@selector(colorForSwipeContainer:)]){
            [self.segmentedControl setTintColor:[childViewController colorForSwipeContainer:self]];
        }
        [self.segmentedControl setSelectedSegmentIndex:[self.swipeViewControllers indexOfObject:childViewController]];
    }
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    self.shouldUpdateSegmentedControl = YES;
}

@end
