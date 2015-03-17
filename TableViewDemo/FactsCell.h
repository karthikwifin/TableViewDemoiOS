//
//  FactsCell.h
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedData.h"

@interface FactsCell : UITableViewCell
{
    BOOL isFirst;
}

@property(nonatomic,retain) UIImageView *imgFacts;
@property(nonatomic,retain) UILabel *lblDescription;

-(void)displayCellValues:(FeedData*)feeds;

@end
