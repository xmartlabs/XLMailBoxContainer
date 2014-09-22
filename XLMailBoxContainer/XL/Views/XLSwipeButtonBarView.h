//
//  XLSwipeButtonBarView.h
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLSwipeButtonBarView

@end

@interface XLSwipeButtonBarView : UIView

@property (readonly, nonatomic) UIView * selectedBar;
@property (readonly, nonatomic) UIScrollView * scrollView;

-(id)initWithFrame:(CGRect)frame options:(NSArray *)options selectedOptionIndex:(NSUInteger)selectedOptionIndex;
-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated;
-(void)setOptionsAmount:(NSUInteger)optionsAmount animated:(BOOL)animated;

@end
