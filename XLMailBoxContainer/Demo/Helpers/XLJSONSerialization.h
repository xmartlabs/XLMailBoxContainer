//
//  NSJSONSerialization+XLJSONSerialization.h
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/20/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLJSONSerialization : NSObject

+ (instancetype)sharedInstance;

@property (readonly) NSArray * postsData;

@end
