//
//  ImageDownloader.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "ImageDownloader.h"
#import "Constants.h"

@implementation ImageDownloader

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    if ([[url description] isEqualToString:@""])
    {
        url = [[NSBundle mainBundle] URLForResource:@"imagenotfound_big" withExtension:@"png"];
    }
    __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        __block NSData *dataValue = nil;
        __block NSData *errorData = nil;
        UIImage *image = [ UIImage imageNamed:@"imagenotfound_big.png"];
        dataValue = UIImageJPEGRepresentation(image, 0);
        
        UIImage *errorImage = [ UIImage imageNamed:@"ErrorImage.jpeg"];
        errorData = UIImageJPEGRepresentation(errorImage, 0);
        
        if (!error) {
            UIImage *receivedImage = [ UIImage imageWithData: data];
            if (receivedImage) {
                if (receivedImage.size.width != kImageSize || receivedImage.size.height != kImageSize)
                {
                    //Image resizing with specified width and height
                    CGSize itemSize = CGSizeMake(kImageSize, kImageSize);
                    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                    [receivedImage drawInRect:imageRect];
                    NSData *reducedData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
                    UIGraphicsEndImageContext();
                    completionBlock(YES,reducedData); //Block return reduced image size
                }
                else{
                    completionBlock(YES, data); //Block return with original image size
                }
            }
            else{
                completionBlock(YES, dataValue); //Block return with local image
            }
        }
        else {
            completionBlock(YES, errorData); //Block return with local image
        }
    }];
}

@end
