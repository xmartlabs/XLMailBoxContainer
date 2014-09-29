//
//  XLSwipeButtonBarView.h
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLSwipeContainerController.h"


@interface XLSwipeButtonBarView : UICollectionView

@property (readonly, nonatomic) UIView * selectedBar;
@property UIFont * labelFont;
@property NSUInteger leftRightMargin;

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated swipeDirection:(XLSwipeDirection)swipeDirection;




@end
