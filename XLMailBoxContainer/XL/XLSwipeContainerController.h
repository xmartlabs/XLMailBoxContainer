//
//  XLSwipeContainerController.h
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

#import <UIKit/UIKit.h>

/**
 The `XLSwipeContainerItemDelegate` protocol is adopted by child controllers of XLSwipeContainerController. Each child view controller has to define a color and either a image or string in order to create the related UISegmentedControl option and update the color accordingly when the selected child view controller change.
 */
@protocol XLSwipeContainerChildItem <NSObject>

@required

/**
 @return UIImage or NSString used as UISegmentedControl item of child viewController.
 */
- (id)swipeContainerItemAssociatedSegmentedItem;

/**
 @return UIColor used when child controller is selected. The tintColor of UINavigationBar will change to this color when the UISegmentedControl option related to child viewController is selected.
 */
- (UIColor *)swipeContainerItemAssociatedColor;

@end


@interface XLSwipeContainerController : UIViewController

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


/**
 @return array containing all childViewControllers.
 */
@property (readonly) NSArray * swipeViewControllers;

@end
