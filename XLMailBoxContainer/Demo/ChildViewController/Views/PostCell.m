//
//  PostCell.m
//  XLTableViewControllerTest
//
//  Created by Gaston Borba on 4/16/14.
//  Copyright (c) 2014 XmartLabs. All rights reserved.
//

#import "PostCell.h"
    
@implementation PostCell

@synthesize userImage = _userImage;
@synthesize userName  = _userName;
@synthesize postText  = _postText;
@synthesize postDate  = _postDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.postText];
        [self.contentView addSubview:self.postDate];
        
        [self.contentView addConstraints:[self layoutConstraints]];
    }
    return self;
}

#pragma mark - Views

-(UIImageView *)userImage
{
    if (_userImage) return _userImage;
    _userImage = [UIImageView new];
    [_userImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 10.0f;
    return _userImage;
}

-(UILabel *)userName
{
    if (_userName) return _userName;
    _userName = [UILabel new];
    [_userName setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [_userName setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    
    return _userName;
}

-(PostTextLabel *)postText
{
    if (_postText) return _postText;
    _postText = [PostTextLabel new];
    [_postText setTranslatesAutoresizingMaskIntoConstraints:NO];
    _postText.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    _postText.lineBreakMode = NSLineBreakByWordWrapping;
    _postText.numberOfLines = 0;

    return _postText;
}

-(UILabel *)postDate
{
    if (_postDate) return _postDate;
    _postDate = [UILabel new];
    [_postDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    _postDate.textColor = [UIColor grayColor];
    _postDate.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [_postDate setTextAlignment:NSTextAlignmentRight];
    return _postDate;
}


#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"image": self.userImage,
                              @"name": self.userName,
                              @"text": self.postText,
                              @"date" : self.postDate };
    
    NSDictionary *metrics = @{@"imgSize":@50.0,
                              @"margin" :@12.0};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[image(imgSize)]-[name]"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[name]-[date]-20-|"
                                                                        options:NSLayoutFormatAlignAllBaseline
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[image(imgSize)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[name]-[text]-20-|"
                                                                        options:NSLayoutFormatAlignAllLeft
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[text]-20-|"
                                                                        options:NSLayoutFormatAlignAllBaseline
                                                                        metrics:metrics
                                                                          views:views]];
    return result;
}

@end


@implementation PostTextLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.bounds.size.width;
}

@end
