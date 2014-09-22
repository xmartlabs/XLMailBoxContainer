//
//  XLSwipeButtonBarView.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLSwipeButtonBarView.h"

@interface XLSwipeButtonBarView ()

@property UIView * selectedBar;
@property NSArray * options;
@property NSUInteger selectedOptionIndex;
@property UIScrollView * scrollView;

@end

@implementation XLSwipeButtonBarView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _options = @[@"Default"];
        _selectedOptionIndex = 0;
        [self addSubview:self.selectedBar];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _options = @[@"Default"];
        _selectedOptionIndex = 0;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame options:(NSArray *)options selectedOptionIndex:(NSUInteger)selectedOptionIndex
{
    self = [self initWithFrame:frame];
    if (self){
        _options = options;
        _selectedOptionIndex = selectedOptionIndex;
        [self addSubview:self.scrollView];
        [self reloadOptions];
        [self.scrollView addSubview:self.selectedBar];
    }
    return self;
}

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated
{
    
}

-(void)setOptionsAmount:(NSUInteger)optionsAmount animated:(BOOL)animated
{
    
}


-(void)updateSelectedBarPositionWithAnimation:(BOOL)animation
{
//    CGRect frame = self.selectedBar.frame;
//    frame.size.width = self.frame.size.width / self.optionsAmount;
//    frame.origin.x = frame.size.width * self.selectedOptionIndex;
//    if (animation){
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.selectedBar setFrame:frame];
//        }];
//    }
//    else{
//        self.selectedBar.frame = frame;
//    }
}


#pragma mark - Properties

-(UIView *)selectedBar
{
    if (_selectedBar) return _selectedBar;
    _selectedBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self updateSelectedBarPositionWithAnimation:NO];
    return _selectedBar;
}

-(UIScrollView *)scrollView
{
    if (_scrollView) return _scrollView;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    return _scrollView;
}


#pragma mark - Helpers

-(void)reloadOptions
{
    NSArray * subviews = self.scrollView.subviews;
    // Remove all subviews
    for (UIView * view in subviews) {
        if (view != self.selectedBar){
            [view removeFromSuperview];
        }
    }
    CGFloat width = 0;
    for (NSString * option in self.options) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:option forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(button.contentEdgeInsets.top, 20, button.contentEdgeInsets.bottom, 20);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button sizeToFit];
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.x = width;
        button.frame = buttonFrame;
        width += button.frame.size.width;
        [self.scrollView addSubview:button];
    }
    
}

@end
