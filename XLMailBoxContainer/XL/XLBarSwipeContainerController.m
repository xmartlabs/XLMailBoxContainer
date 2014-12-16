//
//  XLBarSwipeContainerController.m
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

#import "XLBarSwipeContainerController.h"

@interface XLBarSwipeContainerController ()

@end

@implementation XLBarSwipeContainerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController updateIndicatorToViewController:(UIViewController *)viewController fromViewController:(UIViewController *)fromViewController
{
    [self.swipeBar moveToIndex:[self.swipeViewControllers indexOfObject:viewController] animated:YES];
}



@end
