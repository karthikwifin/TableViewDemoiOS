//
//  JsonFileDownload.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "JsonFileDownload.h"
#import "Constants.h"
#import "FeedData.h"

@implementation JsonFileDownload

+(void)downloadJsonFeed:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSDictionary *dictResponse))completionBlock
{
    __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            
            NSString* string = [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dictFeed = [ self parseJSONFeed: data];
            if (dictFeed) {
                completionBlock(YES, dictFeed);
            }
            else{
               completionBlock(YES, nil);
            }
        } else {
            completionBlock(YES, nil);
        }
    }];
}

+ (NSDictionary*) parseJSONFeed : (NSData*) data
{
    NSError *error = nil;
    NSMutableDictionary * jsonFeed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        
        NSMutableArray *feedArray = [NSMutableArray array];
        for(NSDictionary *dictValue in [jsonFeed objectForKey:@"rows"]){
            //Check Null values
            if(!([dictValue objectForKey:@"title"]==(id)[NSNull null] && [dictValue objectForKey:@"description"]==(id)[NSNull null]&& [dictValue objectForKey:@"imageHref"]==(id)[NSNull null])){
                
                FeedData *feedRecord = [[FeedData alloc] init];
                if([feedRecord checkNullValues:dictValue]){
                    
                    [feedArray addObject:feedRecord];
                }
            }
        }
        //Create dictionary with title and feed values then return
        NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys: feedArray,@"feedArray",[jsonFeed objectForKey: @"title"],@"subjectTitle",nil];
        return jsonDict;
    }
    else{
        NSLog(@"parse error\n");
    }
    
    return nil;
}

@end
