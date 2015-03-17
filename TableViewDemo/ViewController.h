//
//  ViewController.h
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 15/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UILabel *lblMessage;
}

@property (nonatomic,retain) NSMutableArray *listValues;
@property (nonatomic, strong) NSCache *imageCache;
@property (strong, nonatomic) NSMutableDictionary *repeatedCells;
@end

