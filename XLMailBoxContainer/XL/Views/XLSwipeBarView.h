//
//  XLSwipeBarView.h
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSwipeBarView : UIView

@property (readonly, nonatomic) UIView * selectedBar;

-(id)initWithFrame:(CGRect)frame optionsAmount:(NSUInteger)optionsAmount selectedOptionIndex:(NSUInteger)selectedOptionIndex;

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated;
-(void)setOptionsAmount:(NSUInteger)optionsAmount animated:(BOOL)animated;

@end
