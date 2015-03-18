//
//  ViewController.m
//  TableViewDemo
//
//  Created by Karthik Jaganathan on 15/03/15.
//  Copyright (c) 2015 Cognizant Technology Solutions Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "FactsCell.h"
#import "ConstantHandler.h"
#import "JsonFileDownload.h"
#import "ImageDownloader.h"

static NSString *CellIdentifier = @"FactsCell";

@interface ViewController ()

@property (nonatomic,weak) UITableView *tblView;
@property (nonatomic,retain) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.repeatedCells = [NSMutableDictionary dictionary];
    
    self.imageCache = [[NSCache alloc] init]; //NSCache instance to cache image temporarily
    self.imageCache.name = @"com.company.app.imageCache";
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    UITableView *localTable = [ [ UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tblView = localTable;
    [ tableViewController setTableView: self.tblView];
    localTable.translatesAutoresizingMaskIntoConstraints = NO;
    localTable.delegate = self;
    localTable.dataSource = self;
    [self.view addSubview: localTable];
    
    //Apply autolayout constraint to table view
    NSDictionary *views =
    NSDictionaryOfVariableBindings(localTable);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[localTable]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[localTable]|" options:0 metrics:nil views:views]];
    
    localTable = nil;
    [self.tblView registerClass:[FactsCell class] forCellReuseIdentifier:CellIdentifier];
    
    UIRefreshControl *control=[[UIRefreshControl alloc] init]; //refresh control instance
    self.refreshControl = control;
    [self.refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    [tableViewController setRefreshControl: self.refreshControl];
    
    // Request Asynchronous call to download JSON file
    [JsonFileDownload downloadJsonFeed: [NSURL URLWithString:jsonFeedUrl] completionBlock:^(BOOL succeeded, NSDictionary *dictResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.navigationItem setTitle: [ dictResponse objectForKey:@"subjectTitle"]];
            self.listValues = [ dictResponse objectForKey:@"feedArray"];
            [ self.tblView reloadData]; // Reload table once refresh finished
        });
    }];
}

//---------------------------------------------
#pragma mark -
#pragma mark TableView Datasource Methods
//---------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([ self.listValues count] == 0)
    {
        // Display a message when the table is empty
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        lblMessage.text = @"No data is currently available. Please pull down to refresh.";
        lblMessage.textColor = [UIColor blackColor];
        lblMessage.backgroundColor = [ UIColor clearColor];
        lblMessage.numberOfLines = 0;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:20];
        [lblMessage sizeToFit];
        
        self.tblView.backgroundView = lblMessage;
        self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    if (lblMessage) {
        lblMessage.text = @"";
        [ lblMessage removeFromSuperview];
        lblMessage = nil;
    }
    self.tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return [self.listValues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FactsCell *cell = [ self createTableCellWithIndexPath: indexPath];
    return cell;
    
}

//---------------------------------------------
#pragma mark -
#pragma mark TableView Delegate Methods
//---------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return height for layout cell contentview
    NSString *reuseIdentifier = CellIdentifier;
    FactsCell *cell = [self.repeatedCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[FactsCell alloc] init];
        [self.repeatedCells setObject:cell forKey:reuseIdentifier];
    }
    [ self displayCellObjects: indexPath : cell];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return cellHeight + 1.0f; // Add 1.0f for the cell separator height
    
}

//---------------------------------------------
#pragma mark -
#pragma mark Instance Methods
//---------------------------------------------

- (FactsCell *)createTableCellWithIndexPath:(NSIndexPath *)indexPath {
    
    FactsCell *cell = [self.tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [ self displayCellObjects: indexPath : cell];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) displayCellObjects : (NSIndexPath*) indexPath : (FactsCell*) cell
{
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    FeedData *objFeed = [self.listValues objectAtIndex:indexPath.row];
    [cell displayCellValues: objFeed];
    
    UIImageView *imageInCell = (UIImageView*)(FactsCell*)[cell viewWithTag:1];
    
    NSString *cacheKey = [NSString stringWithFormat: @"%@",objFeed.factTitle ];
    imageInCell.image = [self.imageCache objectForKey:cacheKey];
    
    if (imageInCell.image == nil) {
        [ ImageDownloader downloadImageWithURL: [NSURL URLWithString: objFeed.factImage ] completionBlock:^(BOOL succeeded, NSData *data){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData: data];
                if (image) {
                    FactsCell *updateCell = (FactsCell*)[self.tblView cellForRowAtIndexPath: indexPath];
                    [self.imageCache setObject:image forKey:cacheKey];
                    updateCell.imgFacts.image = image;
                }
            });
        }];
    }
}

- (void) reloadTable
{
    [ self.imageCache removeAllObjects];
    [self.refreshControl beginRefreshing];
    
    [JsonFileDownload downloadJsonFeed: [NSURL URLWithString:jsonFeedUrl] completionBlock:^(BOOL succeeded, NSDictionary *dictResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dictResponse) {
                
                [self.navigationItem setTitle: [ dictResponse objectForKey:@"subjectTitle"]];
                if([self.refreshControl isRefreshing]){
                    [self.refreshControl endRefreshing];  // End the refreshing
                }
                self.listValues = [ dictResponse objectForKey:@"feedArray"];
                [ self.tblView reloadData]; //Reload table once refresh finished
            }
            else{
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Internet connection error" message:@"Please check your internet connection and try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                [alertView show];
                [self.refreshControl endRefreshing];  // End the refreshing
            }
            if (self.refreshControl) {
                
                // Get Last Update time
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, h:mm a"];
                NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                self.refreshControl.attributedTitle = attributedTitle;
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.imageCache removeAllObjects];
}

@end
