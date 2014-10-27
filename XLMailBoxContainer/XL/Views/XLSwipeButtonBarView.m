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
@property NSUInteger selectedOptionIndex;

@end

@implementation XLSwipeButtonBarView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeXLSwipeButtonBarView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeXLSwipeButtonBarView];
    }
    return self;
}

-(void)initializeXLSwipeButtonBarView
{
    _selectedOptionIndex = 0;
    [self addSubview:self.selectedBar];
}


-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated swipeDirection:(XLSwipeDirection)swipeDirection
{
    if (self.selectedOptionIndex != index){
        self.selectedOptionIndex = index;
        [self updateSelectedBarPositionWithAnimation:animated swipeDirection:swipeDirection];
    }
}


-(void)updateSelectedBarPositionWithAnimation:(BOOL)animation swipeDirection:(XLSwipeDirection)swipeDirection
{
    CGRect frame = self.selectedBar.frame;
    UICollectionViewCell * cell = [self.dataSource collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedOptionIndex inSection:0]];
    if (cell){
        if (swipeDirection != XLSwipeDirectionNone){
            if (swipeDirection == XLSwipeDirectionLeft)
            {
                float xValue = MIN(self.contentSize.width - self.frame.size.width, cell.frame.origin.x <= 35 ? 0 : cell.frame.origin.x - 35);
                [self  setContentOffset:CGPointMake(xValue, 0) animated:animation];
            }
            else if (swipeDirection == XLSwipeDirectionRight){
                float xValue = MAX(0, cell.frame.origin.x + cell.frame.size.width - self.frame.size.width + 35);
                [self  setContentOffset:CGPointMake(xValue, 0) animated:animation];
            }
            
        }
    }
    else{
        NSLog(@"Log");
    }
    frame.size.width = cell.frame.size.width;
    frame.origin.x = cell.frame.origin.x;
    frame.origin.y = cell.frame.size.height - frame.size.height;
    if (animation){
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectedBar setFrame:frame];
        }];
    }
    else{
        self.selectedBar.frame = frame;
    }
}


#pragma mark - Properties

-(UIView *)selectedBar
{
    if (_selectedBar) return _selectedBar;
    _selectedBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, self.frame.size.width, 5)];
    _selectedBar.layer.zPosition = 9999;
    _selectedBar.backgroundColor = [UIColor blackColor];
    return _selectedBar;
}




#pragma mark - Helpers

//-(void)reloadOptions
//{
//    NSArray * subviews = self.scrollView.subviews;
//    // Remove all subviews
//    for (UIView * view in subviews) {
//        if (view != self.selectedBar){
//            [view removeFromSuperview];
//        }
//    }
//    CGFloat width = 0;
//    for (NSString * option in self.options) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:option forState:UIControlStateNormal];
//        button.contentEdgeInsets = UIEdgeInsetsMake(button.contentEdgeInsets.top, 20, button.contentEdgeInsets.bottom, 20);
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button sizeToFit];
//        CGRect buttonFrame = button.frame;
//        buttonFrame.origin.x = width;
//        button.frame = buttonFrame;
//        width += button.frame.size.width;
//        [self.scrollView addSubview:button];
//    }
//    
//}

@end
