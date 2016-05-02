//
//  JMMasterViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/13/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMMasterViewController.h"

#import "JMCollectionViewController.h"

@interface JMMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation JMMasterViewController
@synthesize appKeys,appDict;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    NSString *appData = [[NSString alloc] init];
    appData = [[NSBundle mainBundle] pathForResource:@"appData" ofType:@"plist"];
    NSURL *appDataUrl = [[NSURL alloc] initFileURLWithPath:appData isDirectory:NO];
    appDict = [[NSDictionary alloc] initWithContentsOfURL:appDataUrl];
    appKeys = [appDict allKeys];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [appKeys objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"toJMCollectionVC"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *selectedString = [appKeys objectAtIndex:indexPath.row];
        [[segue destinationViewController] setSelectedCell:selectedString];

    }
    
}

@end
