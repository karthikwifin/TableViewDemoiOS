//
//  ImageDownloader.h
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownloader : NSObject

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock;

@end
