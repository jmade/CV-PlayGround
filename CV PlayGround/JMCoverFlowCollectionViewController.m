//
//  JMCoverFlowCollectionViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/17/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//

#import "JMCoverFlowCollectionViewController.h"
#import "JMCollectionViewCoverFlowCell.h"
#import "JMCircleLayout.h"
#import "JMFlowLayout.h"
#import "JMCoverFlowLayout.h"
#import "JMWheelLayout.h"
#import "Random.h"
#import "UIImage+ImageEffects.h"
#import "Colours.h"
//#import "UIImage+Resize.h"

@interface JMCoverFlowCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) JMFlowLayout *flowLayout;
@property (nonatomic, strong) JMCircleLayout *circleLayout;
@property (nonatomic, strong) JMCoverFlowLayout *coverFlowLayout;
@property (nonatomic, strong) JMWheelLayout *wheelLayout;
@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *blurredImageArray;
@property (nonatomic, strong) UIImageView *backingImageView;
@property (nonatomic, assign) NSInteger newImageWidthInt;

@end

@implementation JMCoverFlowCollectionViewController 

-(void)loadView
{

    self.coverFlowLayout = [[JMCoverFlowLayout alloc]init];
    self.wheelLayout = [[JMWheelLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.wheelLayout];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[JMCollectionViewCoverFlowCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.backgroundColor =[UIColor robinEggColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.bounces = YES;
    
    self.collectionView = collectionView;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad
        self.newImageWidthInt = 25+IMAGE_HEIGHT;
        
    }
    else
    {
        // iPhone
        self.newImageWidthInt = IMAGE_HEIGHT;
    }
    
    
    [self setUpDataModel];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Wheel", @"CoverFlow"]];
    self.layoutChangeSegmentedControl.selectedSegmentIndex = 0;
    
    [self.layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.layoutChangeSegmentedControl;
    
//    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
   
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
}

-(void)setUpDataModel
{
    self.cellCount = 20;
    
    self.imageArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i=0 ; i < self.cellCount; i++)
    {
        [self.imageArray insertObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)i]] atIndex:i];
    }

  
}



-(void)layoutChangeSegmentedControlDidChangeValue:(id)sender
{
    if (self.collectionView.collectionViewLayout == self.wheelLayout)
    {
        
        [self.coverFlowLayout invalidateLayout];
        
        [self.collectionView setCollectionViewLayout:self.coverFlowLayout animated:YES];
    }
    else
    {
        [self.wheelLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.wheelLayout animated:YES];
        
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
  
}





-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMCollectionViewCoverFlowCell *cell = (JMCollectionViewCoverFlowCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //get image name and assign
    cell.image = [self.imageArray objectAtIndex:indexPath.row];
    
    //set offset accordingly
    CGFloat xOffset = ((self.collectionView.contentOffset.x - cell.frame.origin.x) / self.newImageWidthInt) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(xOffset, 0.0);

    UIPanGestureRecognizer *cellPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanOnCell:)];
    
    //[cell addGestureRecognizer:cellPanGestureRecognizer];
    
    return cell;
    
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    for(JMCollectionViewCoverFlowCell *view in self.collectionView.visibleCells) {
        CGFloat xOffset = ((self.collectionView.contentOffset.x - view.frame.origin.x) / self.newImageWidthInt) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(xOffset, 0);
    }
}


-(void)handlePanOnCell:(UIPanGestureRecognizer*)sender {
    
    
//    NSLog(@"Pan Handled: %@",sender);
//    
//    // Grow image view
//    CGRect frame = sender.view.bounds;
//    CGRect offsetFrame = CGRectOffset(frame, 0.0,-20);
//    sender.view.frame = offsetFrame;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
