//
//  FactsCell.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 16/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "FactsCell.h"
#import "Constants.h"
#import "GradientView.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface FactsCell()

@property(nonatomic,retain) UILabel *lblTitle;
@property (nonatomic, strong) GradientView *gradientView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property(nonatomic,retain) FeedData *feed;

-(void)applyAutoLayoutConstraintsToTableViewObjects;

@end

@implementation FactsCell

#pragma mark -
#pragma mark Instance Methods

/*
 This method to apply autolayout to the title, description label and
 image view
 */

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _lblTitle = [[UILabel alloc]init];
        _lblDescription = [[UILabel alloc]init];
        _imgFacts = [[UIImageView alloc]init];
        
        [self.lblTitle setNumberOfLines:0];
        [self.lblTitle setFont:[UIFont fontWithName: @"HelveticaNeue-Bold" size:20.0f]];
        
        [self.lblTitle setTextColor: [ UIColor whiteColor]];
        
        
        [self.lblDescription setNumberOfLines:0];
        [self.lblDescription setFont:[UIFont fontWithName: @"HelveticaNeue-Bold" size:14.0f]];
        [self.lblDescription setLineBreakMode:NSLineBreakByWordWrapping];
        [self.lblDescription setTextColor:[UIColor cyanColor]];
        
        [ self.imgFacts setTag: 1];
        [ self.imgFacts setBackgroundColor: [ UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblDescription];
        [self.contentView addSubview:self.imgFacts];
        
        
    }
    [self applyAutoLayoutConstraintsToTableViewObjects];
    return self;
    
}

-(void)applyAutoLayoutConstraintsToTableViewObjects
{
    //if (!self.didSetupConstraints) {
        [self.lblTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.lblDescription setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imgFacts setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Adding contraints to Leading, Trailing and Top for title
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
        NSLayoutConstraint *topConstraintToTitle =[NSLayoutConstraint constraintWithItem:self.lblTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
        [topConstraintToTitle setPriority:UILayoutPriorityRequired]; // Setting maximum priority for the title
        [self.contentView addConstraint:topConstraintToTitle];
        
        
        // Adding contraints to Leading, Trailing and Top for description
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lblTitle attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        NSLayoutConstraint *bottomConstraintForDescLabel = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        [bottomConstraintForDescLabel setPriority:900];
        [self.contentView addConstraint:bottomConstraintForDescLabel];
        
        // Contraint between title and description label
        NSLayoutConstraint *topConstraintToDescription=[NSLayoutConstraint constraintWithItem:self.lblDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lblTitle attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        [topConstraintToDescription setPriority:UILayoutPriorityRequired];
        [self.contentView addConstraint:topConstraintToDescription];
        
        
        // Adding Constraints to image for CentreY, Leading and Bottom positions
        
        NSLayoutConstraint *centreSpacingConstraint=[NSLayoutConstraint constraintWithItem:self.imgFacts attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [centreSpacingConstraint setPriority:900]; //Lower Priority
        [self.contentView addConstraint:centreSpacingConstraint];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imgFacts attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lblDescription attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imgFacts attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
        
        NSLayoutConstraint *constraintForImageViewBottom=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.imgFacts attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        [constraintForImageViewBottom setPriority:900]; //Lower Priority
        [self.contentView addConstraint:constraintForImageViewBottom];
        
        NSLayoutConstraint *topSpacingCOnstraintImgView=[NSLayoutConstraint constraintWithItem:self.imgFacts attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.lblDescription attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [topSpacingCOnstraintImgView setPriority:900]; //Lower Priority
        [self.contentView addConstraint:topSpacingCOnstraintImgView];
        
        // Setting the Height and Width for the ImageView.
        NSDictionary *dictionary=NSDictionaryOfVariableBindings(_imgFacts,_lblTitle);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalVisual options:0 metrics:nil views:dictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalVisual options:0 metrics:nil views:dictionary]];
    //}
    
    self.didSetupConstraints = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

//Display Cell object values with FeedData instance
-(void)displayCellValues:(FeedData *)feeds
{
    self.feed= feeds;
    [self.lblDescription setText:[feeds factDescription]];
    [self.lblTitle setText:[feeds  factTitle]];
    
}

//Override layoutSubviews method
// 1. Set preferred label width
// 2. Draw Gradient with autoresizing

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        // Set preferred width if autolayout designed programmatically
        [self.lblDescription setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-CGRectGetWidth(self.imgFacts.bounds)-adjust480Spacing];
        [self.lblTitle setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-adjust480Spacing];
    }
    else{
        // Set preferred width if autolayout designed programmatically
        [self.lblDescription setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-CGRectGetWidth(self.imgFacts.bounds)-adjustSpacing];
        [self.lblTitle setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-adjustSpacing];
    }
    
    if (!_gradientView)
        self.gradientView = [[GradientView alloc] initWithFrame:self.contentView.bounds];
    self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gradientView.layer setStartPoint:CGPointMake(0.0, 0.5)];
    [self.gradientView.layer setEndPoint:CGPointMake(1.0, 0.5)];
    self.gradientView.layer.colors = @[ (__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor blueColor].CGColor ];
    [self.contentView addSubview:self.gradientView];
    
    //Bring cell objects to front
    [ self.contentView bringSubviewToFront: self.lblTitle ];
    [ self.contentView bringSubviewToFront: self.lblDescription ];
    [ self.contentView bringSubviewToFront: self.imgFacts ];
}

@end
