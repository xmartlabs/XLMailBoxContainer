//
//  XLButtonBarSwipeContainerController.m
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

#import "XLSwipeButtonBarViewCell.h"
#import "XLButtonBarSwipeContainerController.h"

@interface XLButtonBarSwipeContainerController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) IBOutlet XLSwipeButtonBarView * swipeBar;
@property (nonatomic) BOOL shouldUpdateSwipeBar;

@end

@implementation XLButtonBarSwipeContainerController
{
    XLSwipeButtonBarViewCell * _sizeCell;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shouldUpdateSwipeBar = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.shouldUpdateSwipeBar = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.swipeBar.superview){
        [self.view addSubview:self.swipeBar];
    }
    if (!self.swipeBar.delegate){
        self.swipeBar.delegate = self;
    }
    if (!self.swipeBar.dataSource){
        self.swipeBar.dataSource = self;
    }
    self.swipeBar.labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    self.swipeBar.leftRightMargin = 8;
    UICollectionViewFlowLayout * flowLayout = (id)self.swipeBar.collectionViewLayout;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.swipeBar setShowsHorizontalScrollIndicator:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UICollectionViewLayoutAttributes *attributes = [self.swipeBar layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    CGRect cellRect = attributes.frame;
    [self.swipeBar.selectedBar setFrame:CGRectMake(cellRect.origin.x, self.swipeBar.frame.size.height - 5, cellRect.size.width, 5)];
}


-(XLSwipeButtonBarView *)swipeBar
{
    if (_swipeBar) return _swipeBar;
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 35, 0, 35)];
    _swipeBar = [[XLSwipeButtonBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f) collectionViewLayout:flowLayout];
    _swipeBar.backgroundColor = [UIColor orangeColor];
    _swipeBar.selectedBar.backgroundColor = [UIColor blackColor];
    _swipeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _swipeBar;
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController updateIndicatorToViewController:(UIViewController *)viewController fromViewController:(UIViewController *)fromViewController
{
    if (self.shouldUpdateSwipeBar){
        NSUInteger newIndex = [self.swipeViewControllers indexOfObject:viewController];
        XLSwipeDirection direction = XLSwipeDirectionLeft;
        if (newIndex < [self.swipeViewControllers indexOfObject:fromViewController]){
            direction = XLSwipeDirectionRight;
        }
        [self.swipeBar moveToIndex:newIndex animated:YES swipeDirection:direction];
    }
}



#pragma merk - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = self.swipeBar.labelFont;
    UIViewController<XLSwipeContainerChildItem> * childController =   [self.swipeViewControllers objectAtIndex:indexPath.item];
    [label setText:[childController nameForSwipeContainer:self]];
    CGSize labelSize = [label intrinsicContentSize];
    
    return CGSizeMake(labelSize.width + (self.swipeBar.leftRightMargin * 2), collectionView.frame.size.height);
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.swipeBar moveToIndex:indexPath.item animated:YES swipeDirection:XLSwipeDirectionNone];
    self.shouldUpdateSwipeBar = NO;
    [self moveToViewControllerAtIndex:indexPath.item];  
}

#pragma merk - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.swipeViewControllers.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[XLSwipeButtonBarViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, self.swipeBar.frame.size.height)];
    }
    NSAssert([cell isKindOfClass:[XLSwipeButtonBarViewCell class]], @"UICollectionViewCell should be or extend XLSwipeButtonBarViewCell");
    XLSwipeButtonBarViewCell * swipeCell = (XLSwipeButtonBarViewCell *)cell;
    UIViewController<XLSwipeContainerChildItem> * childController =   [self.swipeViewControllers objectAtIndex:indexPath.item];
    
    [swipeCell.label setText:[childController nameForSwipeContainer:self]];
    
    return swipeCell;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.containerView){
        self.shouldUpdateSwipeBar = YES;
    }
}


@end
