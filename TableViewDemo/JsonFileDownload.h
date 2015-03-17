//
//  JsonFileDownload.h
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonFileDownload : NSObject
{
    
}

+(void)downloadJsonFeed:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSDictionary *dictResponse))completionBlock;

@end
