//
//  XLSwipeNavigationController.h
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


#import "XLSwipeContainerController.h"

#import <UIKit/UIKit.h>

/**
 `XLSwipeNavigationController` is just a helper to create the swipe custom container view controller and set it as the rootViewController. You don't need to use this classs at all, optionally you can create a XLSwipeContainerControllergitx
 by your own and set it as the rootViewController of any UINavigationController.
 */
@interface XLSwipeNavigationController : UINavigationController


/**
 Initializes and returns a newly allocated XLSwipeContainerController object, it also set up the rootViewController property with a XLSwipeContainerController instance.
 
 This is the designated initializer.
 
 @param fistViewController,... Variable argument list of view controllers that conforms to XLSwipeContainerItemDelegate. XLSwipeNavigationController will have as many segmented control options as view controllers passed in this parameter.
 */
-(id)initWithViewControllers:(UIViewController<XLSwipeContainerChildItem> *)firstViewController, ... NS_REQUIRES_NIL_TERMINATION;

@end
