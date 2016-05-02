//
//  JMSnapFlowCollectionViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/25/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMSnapFlowCollectionViewController.h"
#import "JMCollectionViewCell.h"
#import "JMSnapFlowLayout.h"
#import "JMWheelLayout.h"
#import "JMSimpleSpringyLayout.h"
#import "Colours.h"

#define CELL_COUNT 4
#define PAGING 1

@interface JMSnapFlowCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) JMWheelLayout *wheelLayout;
@property (nonatomic, strong) JMSnapFlowLayout *snapLayout;
@property (nonatomic, strong) JMSimpleSpringyLayout *springyLayout;
@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;


@end

@implementation JMSnapFlowCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    self.wheelLayout = [[JMWheelLayout alloc]init];
    self.snapLayout = [[JMSnapFlowLayout alloc]init];
    self.springyLayout = [[JMSimpleSpringyLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.snapLayout];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [collectionView addGestureRecognizer:tapRecognizer];
    
    collectionView.backgroundColor =[UIColor antiqueWhiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = PAGING;
    
    [collectionView registerClass:[JMCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.tintColor = [UIColor black50PercentColor];
    
    
    self.collectionView = collectionView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cellCount = CELL_COUNT;
    
    self.layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Snap", @"Springy"]];
    self.layoutChangeSegmentedControl.selectedSegmentIndex = 1;
    
    
    [self.layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.layoutChangeSegmentedControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutChangeSegmentedControlDidChangeValue:(id)sender
{
    //NSLog(@"Sender: %@",sender);
    
    // This just swaps the two values
    if (self.collectionView.collectionViewLayout == self.springyLayout)
    {
        
        [self.snapLayout invalidateLayout];
        
        [self.collectionView setCollectionViewLayout:self.snapLayout animated:YES];
    }
    else
    {
        [self.springyLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.springyLayout animated:NO];
        
    }
    
}

-(void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (tappedCellPath!=nil)
        {
            self.cellCount = self.cellCount - 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
                
            } completion:nil];
        }
        else
        {
            self.cellCount = self.cellCount + 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
            } completion:nil];
        }
    }
}

#pragma mark - UICollectionView Delegate

- (void)preferredContentSizeChanged:(NSNotification *) notification {
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellCount;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}





-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMCollectionViewCell *cell = (JMCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setLabelString:[NSString stringWithFormat:@"%li",(long)indexPath.row]];
    
    cell.backgroundColor = [UIColor black50PercentColor];
    
    
    cell.layer.cornerRadius = 8.0f;
    
    return cell;
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
