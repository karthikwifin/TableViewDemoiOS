//
//  FeedData.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 15/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "FeedData.h"
#import "Constants.h"

@implementation FeedData
@synthesize factTitle,factDescription,factImage;

//Check null value string
-(BOOL)isNotNull:(id)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

//Replace null string with empty string
-(BOOL)checkNullValues:(NSDictionary *)attributes
{
    if ([ self isNotNull:[attributes valueForKeyPath:kTitle]] ) {
        self.factTitle = [attributes valueForKeyPath:kTitle];
    }
    else{
        return NO;
    }
    
    if ([ self isNotNull:[attributes valueForKeyPath:kDescription]]) {
        self.factDescription = [attributes valueForKeyPath:kDescription];
    }
    else{
        self.factDescription = kEmpty;
    }
    
    if ([ self isNotNull:[attributes valueForKeyPath:kImage]]) {
        self.factImage = [attributes valueForKeyPath:kImage];
    }
    else{
        self.factImage=kEmpty;
    }
    
    return YES;
}

@end
