//
//  JMCollectionViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/13/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCollectionViewController.h"
#import "JMCollectionViewCell.h"
#import "JMHeaderView.h"
#import "JMFooterView.h"
#import "JMCircleLayout.h"
#import "JMFlowLayout.h"
#import "RVCollectionViewLayout.h"
#import "JMWheelLayout.h"
#import "Colours.h"



@interface JMCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) JMFlowLayout *flowLayout;
@property (nonatomic, strong) JMCircleLayout *circleLayout;
@property (nonatomic, strong) RVCollectionViewLayout *rvLayout;
@property (nonatomic, strong) JMWheelLayout *wheelLayout;
@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;


@end

@implementation JMCollectionViewController

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)loadView
{
    self.circleLayout = [[JMCircleLayout alloc] init];
    self.flowLayout = [[JMFlowLayout alloc] init];
    self.rvLayout = [[RVCollectionViewLayout alloc]init];
    self.wheelLayout = [[JMWheelLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.wheelLayout];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[JMCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [collectionView addGestureRecognizer:tapRecognizer];

    collectionView.backgroundColor =[UIColor robinEggColor];
    collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView = collectionView;
    


}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellCount = 13;
    
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
    
    self.layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Circle", @"Flow"]];
    self.layoutChangeSegmentedControl.selectedSegmentIndex = 1;
    
    [self.layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.layoutChangeSegmentedControl;
    
    
   
    
    //Load the Data for the Collection View
    
    // CollectionView Delegates
    
    
    
    
        
//    [self.collectionView registerClass:[JMCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [self.collectionView registerClass:[JMHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [self.collectionView registerClass:[JMFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
    //[self.collectionView reloadData];
    
 //   [self.collectionView reloadData];
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];

    
}



-(void)layoutChangeSegmentedControlDidChangeValue:(id)sender
{
    //NSLog(@"Sender: %@",sender);
    
    // This just swaps the two values
    if (self.collectionView.collectionViewLayout == self.circleLayout)
    {
        
       [self.flowLayout invalidateLayout];
       
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    }
    else
    {
        [self.circleLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];

    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return cell;
    
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    if (kind == UICollectionElementKindSectionHeader)
//    {
//        JMHeaderView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//        return header;
//    }
//    else
//    {
//        JMFooterView *footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        return footer;
//    }
//}

#pragma Mark Layout & Sizing

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(100, 100.0);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(100, 100);
//}





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
