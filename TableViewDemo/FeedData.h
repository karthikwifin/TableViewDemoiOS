//
//  FeedData.h
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 15/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedData : NSObject

@property(nonatomic,retain) NSString *factTitle;
@property(nonatomic,retain) NSString *factDescription;
@property(nonatomic,retain) NSString *factImage;

-(BOOL)checkNullValues:(NSDictionary *)attributes;

@end
