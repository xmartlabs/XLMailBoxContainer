//
//  XLSwipeBarView.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLSwipeBarView.h"

@interface XLSwipeBarView()

@property UIView * selectedBar;
@property NSUInteger optionsAmount;
@property NSUInteger selectedOptionIndex;

@end

@implementation XLSwipeBarView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _optionsAmount = 1;
        _selectedOptionIndex = 1;
        [self addSubview:self.selectedBar];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _optionsAmount = 1;
        _selectedOptionIndex = 1;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame optionsAmount:(NSUInteger)optionsAmount selectedOptionIndex:(NSUInteger)selectedOptionIndex
{
    self = [self initWithFrame:frame];
    if (self){
        _optionsAmount = optionsAmount;
        _selectedOptionIndex = selectedOptionIndex;
        [self addSubview:self.selectedBar];
    }
    return self;
}

-(UIView *)selectedBar
{
    if (_selectedBar) return _selectedBar;
    _selectedBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self updateSelectedBarPositionWithAnimation:NO];
    return _selectedBar;
}


#pragma mark - Helpers

-(void)updateSelectedBarPositionWithAnimation:(BOOL)animation
{
    CGRect frame = self.selectedBar.frame;
    frame.size.width = self.frame.size.width / self.optionsAmount;
    frame.origin.x = frame.size.width * self.selectedOptionIndex;
    if (animation){
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectedBar setFrame:frame];
        }];
    }
    else{
        self.selectedBar.frame = frame;
    }
}

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated
{
    self.selectedOptionIndex = index;
    [self updateSelectedBarPositionWithAnimation:animated];
}

-(void)setOptionsAmount:(NSUInteger)optionsAmount animated:(BOOL)animated
{
    self.optionsAmount = optionsAmount;
    if (self.optionsAmount <= self.selectedOptionIndex){
        self.selectedOptionIndex = self.optionsAmount - 1;
    }
    [self updateSelectedBarPositionWithAnimation:animated];
}

-(void)layoutSubviews
{
    [self updateSelectedBarPositionWithAnimation:NO];
}

@end
