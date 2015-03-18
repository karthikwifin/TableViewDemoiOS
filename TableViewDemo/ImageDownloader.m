//
//  ImageDownloader.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "ImageDownloader.h"
#import "ConstantHandler.h"

@implementation ImageDownloader

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    if ([[url description] isEqualToString:@""])
    {
        url = [[NSBundle mainBundle] URLForResource:@"imagenotfound_big" withExtension:@"png"];
    }
    __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        UIImage *image = [ UIImage imageNamed:@"imagenotfound_big.png"];
        UIImage *errorImage = [ UIImage imageNamed:@"ErrorImage.png"];
        
        if (!error) {
            UIImage *receivedImage = [ UIImage imageWithData: data];
            if (receivedImage) {
                if (receivedImage.size.width != kImageSize || receivedImage.size.height != kImageSize)
                {
                    NSData *reducedData = [ ImageDownloader reducekImageSize:receivedImage];
                    completionBlock(YES,reducedData); //Block return reduced image size
                }
                else{
                    completionBlock(YES, data); //Block return with original image size
                }
            }
            else{
                NSData *reducedData = [ ImageDownloader reducekImageSize:image];
                completionBlock(YES, reducedData); //Block return with local image
            }
        }
        else {
            NSData *reducedData = [ ImageDownloader reducekImageSize: errorImage];
            completionBlock(YES, reducedData); //Block return with local image
        }
    }];
}

+ (NSData*) reducekImageSize : (UIImage*) image
{
    //Image resizing with specified width and height
    CGSize itemSize = CGSizeMake(kImageSize, kImageSize);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    NSData *reducedData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
    UIGraphicsEndImageContext();
    return reducedData;
}

@end
