//
//  XLSwipeContainerController.h
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

#import <UIKit/UITableViewController.h>
#import <UIKit/UIKit.h>

@class XLSwipeContainerController;

/**
 The `XLSwipeContainerItemDelegate` protocol is adopted by child controllers of XLSwipeContainerController. Each child view controller has to define a color and either a image or string in order to create the related UISegmentedControl option and update the color accordingly when the selected child view controller change.
 */
@protocol XLSwipeContainerChildItem <NSObject>

@required

- (NSString *)nameForSwipeContainer:(XLSwipeContainerController *)swipeContainer;

@optional

- (UIImage *)imageForSwipeContainer:(XLSwipeContainerController *)swipeContainer;
- (UIColor *)colorForSwipeContainer:(XLSwipeContainerController *)swipeContainer;

@end



typedef NS_ENUM(NSUInteger, XLSwipeDirection) {
    XLSwipeDirectionLeft,
    XLSwipeDirectionRight,
    XLSwipeDirectionNone
};



@protocol XLSwipeContainerControllerDelegate <NSObject>

@optional

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController updateIndicatorToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController;

@end


@protocol XLSwipeContainerControllerDataSource <NSObject>

@required

-(NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController;

@end



@interface XLSwipeContainerController : UIViewController <XLSwipeContainerControllerDelegate, XLSwipeContainerControllerDataSource, UIScrollViewDelegate>

/**
 Initializes a `XLSwipeContainerController` object with child controllers contained in viewControllers parameter.
 @param viewControllers ChildViewControllers to be added to XLSwipeContainerController.
 @return The newly-initialized XLSwipeContainerController custom container controller.
 */
-(id)initWithViewControllers:(NSArray *)viewControllers;

/**
 Initializes a `XLSwipeContainerController` object with child controllers contained in viewControllers parameter.
 This is the designated initializer.
 @param viewControllers hildViewControllers to be added to XLSwipeContainerController.
 @param currentIndex Index of childViewController selected by default.
 @return The newly-initialized XLSwipeContainerController custom container controller.
 */
-(id)initWithViewControllers:(NSArray *)viewControllers currentIndex:(NSUInteger)currentIndex;

-(id)initWithViewCurrentIndex:(NSUInteger)index viewControllers:(UIViewController *)firstViewController, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @return array containing all childViewControllers.
 */
@property (readonly) NSArray * swipeViewControllers;
@property (nonatomic, retain) IBOutlet UIScrollView * containerView;
@property (nonatomic, assign) IBOutlet id<XLSwipeContainerControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<XLSwipeContainerControllerDataSource> dataSource;

@property (readonly) NSUInteger currentIndex;
@property BOOL skipIntermediateViewControllers;

-(void)moveToViewControllerAtIndex:(NSUInteger)index;
-(void)moveToViewController:(UIViewController *)viewController;

@end
