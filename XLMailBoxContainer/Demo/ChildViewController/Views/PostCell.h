//
//  PostCell.h
//  XLTableViewControllerTest
//
//  Created by Gaston Borba on 4/16/14.
//  Copyright (c) 2014 XmartLabs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostTextLabel : UILabel
@end


@interface PostCell : UITableViewCell

@property (nonatomic) UIImageView * userImage;
@property (nonatomic) UILabel * userName;
@property (nonatomic) PostTextLabel * postText;
@property (nonatomic) UILabel * postDate;

@end
