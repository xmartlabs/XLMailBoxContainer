//
//  XLSwipeNavigationController.m
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

#import "XLSwipeNavigationController.h"

@implementation XLSwipeNavigationController


-(id)initWithViewControllers:(UIViewController<XLSwipeContainerChildItem> *)firstViewController, ...
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
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
        XLSwipeContainerController * containerController = [[XLSwipeContainerController alloc] initWithViewControllers:mutableArray];
        [self setViewControllers:@[containerController]];
        
        
        
    }
    return self;
}


@end
