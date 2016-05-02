//
//  JMViewController.m
//  CV PlayGround
//
//  Created by Justin Madewell on 5/29/14.
//  Copyright (c) 2014 Justin Madewell. All rights reserved.
//
#import <DynamicXray/DynamicXray.h>
#import "JMViewController.h"
#import "Colours.h"
#import "BottomAnchorBehavior.h"
#import "OptionsViewController.h"

#define SNAP_DAMPING 0.65
#define ITEM_DAMPING 0.0
#define ITEM_RESISTANCE 1.0
#define ITEM_DENSITY 500.0
#define ITEM_ELASTICTY 0.0
#define ITEM_FRICTION 0.2
#define ITEM_ANGULAR_RESISTANCE 75.0

#define RETURN_DAMPING 0.65
#define RETURN_INITIAL_VELOCITY 0.25
#define RETURN_DURATION 0.20

#define CARD_SIZE 320


#define INCREMENT_VALUE 10
#define PANEL_HEIGHT 300

static const CGFloat __maximumDismissDelay = 0.5f;
// maximum time of delay (in seconds) between when image view is push out and dismissal animations begin
static const CGFloat __velocityFactor = 1.0f;
// affects how quickly the view is pushed out of the view
static const CGFloat __angularVelocityFactor = 0.5f;
// adjusts the amount of spin applied to the view during a push force, increases towards the view bounds
static const CGFloat __minimumVelocityRequiredForPush = 50.0f;
// defines how much velocity is required for the push behavior to be applied

@interface JMViewController ()

@property (nonatomic, strong) UIView *card;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UISnapBehavior *snap;
@property (nonatomic, strong) UIDynamicItemBehavior *item;
@property (nonatomic, strong) UIPushBehavior *push;

@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehavior;

@property (nonatomic, assign) CGPoint snapPoint;

@property (nonatomic, assign) CGPoint currentLocation;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UILabel *pushLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *initialVelocityLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *delayLable;

@property (nonatomic, strong) UIView *optionsPanel;
@property (nonatomic, strong) UIVisualEffectView *visualEffectPanel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *speedValueLabel;
@property (nonatomic, strong) UIStepper *speedStepper;
@property  BOOL optionsPanelVisible;
@property (nonatomic, strong) UILabel *resLabel;


@property (nonatomic, strong) OptionsViewController *optionsVC;

@end

@implementation JMViewController {
    CGRect _originalFrame;
    CGFloat _cardCenter;
    CGFloat iVel;
    CGFloat time;
}



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
    CGRect mainRect = CGRectMake(-160, 0, 640,567);
   
    
    UIView *view = [[UIView alloc]initWithFrame:mainRect];
    view.backgroundColor = [UIColor lightGrayColor];
    self.view = view;
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My VC";
    self.timeFactor = 0;
    self.optionsPanelVisible = NO;
    self.resistanceValue = ITEM_DENSITY;
    
    NSLog(@"First Load self.speedNumber: %f",self.speedNumber);
    self.speedNumber = 270;

    
    
    
    // Card Sizing
    CGSize cardSize = [self makeSizeFromBase:CARD_SIZE withRatio:16 by:9];
    CGRect cardRect = CGRectMake(self.view.center.x-cardSize.width/2,self.view.center.y-cardSize.height/2, cardSize.width, cardSize.height);
    
    //CGRect labelRect = CGRectMake(cardRect.origin.x, cardRect.origin.y, cardSize.width, cardSize.height);
    
    
    [self setupOptionsPanel];
    
   
    
    // Card View Setup
    _card = [[UIView alloc]initWithFrame:cardRect];
    _originalFrame = _card.frame;
    _card.transform = CGAffineTransformIdentity;
    _card.backgroundColor = [UIColor blueberryColor];
    
    
    CGRect labelRect = CGRectMake(0,0, cardSize.width, cardSize.height);
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:labelRect];
    cardLabel.text = @" This Way Up ^ ";
    cardLabel.numberOfLines = 2;
    cardLabel.adjustsFontSizeToFitWidth = YES;
    cardLabel.textColor = [UIColor whiteColor];
    cardLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:40];
    cardLabel.textAlignment = NSTextAlignmentCenter;
    [_card addSubview:cardLabel];
    [self.view addSubview:_card];
    
//    CGPoint convertedCenter =  [self.view convertPoint:_card.center fromView:self.view];
//    NSLog(@"convertedCenter : %@",NSStringFromCGPoint(convertedCenter));
//    
//    CGPoint convertedCenter2 = [self.view convertPoint:_card.center toView:self.view];
//    NSLog(@"convertedCenter2 : %@",NSStringFromCGPoint(convertedCenter2));
//    
//    CGPoint cardCenter = _card.center;
//    NSLog(@"cardCenter : %@",NSStringFromCGPoint(cardCenter));
//    
//    CGPoint selfCenter = self.view.center;
//    NSLog(@"selfCenter : %@",NSStringFromCGPoint(selfCenter));
    
    
    
    
    
    
    
    
    // Setup Pan Gesture Behavior
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delaysTouchesBegan = NO;
    _panGesture.delaysTouchesEnded = NO;
    [_card addGestureRecognizer:_panGesture];
    
    
    
    // Set up the Animator
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    // Start & Add Behaviors
    
    [self startDynamicItemBehavior];
    [self setupPushBehavior];
    //[self startSnapBehavior];
    
    // ADD THE XRAY COMPONENT
//    DynamicXray *xray = [[DynamicXray alloc] init];
//    [_animator addBehavior:xray];
    
    // ADD THE LABLE
    _pushLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 20)];
    _pushLabel.textAlignment = NSTextAlignmentCenter;
    _pushLabel.text = @"0000";
    _pushLabel.textColor = [UIColor blueColor];
    
    [self.view addSubview:_pushLabel];
    
    _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 40, 20)];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.text = @"0000";
    _distanceLabel.textColor = [UIColor raspberryColor];
    [self.view addSubview:_distanceLabel];
    
    _initialVelocityLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 50, 20)];
    _initialVelocityLabel.textAlignment = NSTextAlignmentCenter;
    _initialVelocityLabel.text = @"0000";
    _initialVelocityLabel.textColor = [UIColor dustColor];
    [self.view addSubview:_initialVelocityLabel];
    
    _delayLable = [[UILabel alloc]initWithFrame:CGRectMake(170, 70, 60, 20)];
    _delayLable.textAlignment = NSTextAlignmentCenter;
    _delayLable.text = @"0000";
    _delayLable.textColor = [UIColor purpleColor];
    [self.view addSubview:_delayLable];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 70, 60, 20)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"0000";
    _timeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_timeLabel];

    
    [self.view addSubview:self.visualEffectPanel];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Snap Behavior

-(void)startSnapBehavior
{
    _snap = [[UISnapBehavior alloc]initWithItem:_card snapToPoint:self.view.center];
    _snap.damping = SNAP_DAMPING;
    [_animator addBehavior:_snap];
}


#pragma Dynamic Item Behavior

-(void)startDynamicItemBehavior
{
    _item = [[UIDynamicItemBehavior alloc]initWithItems:@[_card]];
    _item.allowsRotation = YES;
    _item.elasticity = ITEM_ELASTICTY;
    _item.density = self.resistanceValue;
    _item.friction = ITEM_FRICTION;
    _item.resistance = ITEM_RESISTANCE;
    [_animator addBehavior:_item];
    NSLog(@"Dynamic Behavior Set");
    
}

#pragma Push Behavior

-(void)setupPushBehavior
{
    _push = [[UIPushBehavior alloc]initWithItems:@[_card] mode:UIPushBehaviorModeInstantaneous];
    _push.angle = 0.0f;
    _push.magnitude = 0.0f;
}

#pragma Gesture Recognizer

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint boxLocation = [gestureRecognizer locationInView:_card];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {

        [_animator removeBehavior:_snap];
        _timeLabel.text = @"TIME";
        _delayLable.text = @"DEL";
        _pushLabel.text = @"PUSH";
        _initialVelocityLabel.text = @"IVEL";
        _distanceLabel.text = @"DIST";
        
        UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(_card.bounds), boxLocation.y - CGRectGetMidY(_card.bounds));
        _panAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_card offsetFromCenter:centerOffset attachedToAnchor:location];
        [_animator addBehavior:_panAttachmentBehavior];
        [_animator addBehavior:_item];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _panAttachmentBehavior.anchorPoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Stated ENDED
        
        CGFloat xPoints = 320.0;
        CGFloat velocityX = [gestureRecognizer velocityInView:self.view].x;
        CGFloat duration = xPoints / velocityX;
       // NSLog(@"duration: %f",duration);
        
        
        
        
        CGPoint velocityInView = [gestureRecognizer velocityInView:_card.superview];
        CGPoint pointOfRelease = _card.center;
        [_animator removeBehavior:_panAttachmentBehavior];
      
        
        
        
        // Push Velocity
        
        // need to scale velocity values to tame down physics on the iPad
		CGFloat deviceVelocityScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.2f : 1.0f;
		CGFloat deviceAngularScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.7f : 1.0f;
		// factor to increase delay before `dismissAfterPush` is called on iPad to account for more area to cover to disappear
		CGFloat deviceDismissDelay = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.8f : 1.0f;
		CGPoint velocity = [gestureRecognizer velocityInView:self.view];
       // NSLog(@"velocity : %@",NSStringFromCGPoint(velocity));
        //
        
        CGFloat velocityAdjust = 0.1;// * deviceVelocityScale;
		
		if (fabs(velocity.x / velocityAdjust) > __minimumVelocityRequiredForPush || fabs(velocity.y / velocityAdjust) > __minimumVelocityRequiredForPush)
        {
			UIOffset offsetFromCenter = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.view.bounds), boxLocation.y - CGRectGetMidY(self.view.bounds));
			CGFloat radius = sqrtf(powf(offsetFromCenter.horizontal, 2.0f) + powf(offsetFromCenter.vertical, 2.0f));
			CGFloat pushVelocity = (sqrtf(powf(velocity.x, 2.0f) + powf(velocity.y, 2.0f)));
           // NSLog(@"pushVelocity: %f",pushVelocity);
            
            NSNumber *number = [NSNumber numberWithFloat:pushVelocity];
            NSString *string = [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterNoStyle];
            
            
            _pushLabel.text =string;//[NSString stringWithFormat:@"Push: %f",pushVelocity];
            
            
			
			// calculate angles needed for angular velocity formula
			CGFloat velocityAngle = atan2f(velocity.y, velocity.x);
			CGFloat locationAngle = atan2f(offsetFromCenter.vertical, offsetFromCenter.horizontal);
			if (locationAngle > 0)
            {
				locationAngle -= M_PI * 2;
			}
			
			// angle (θ) is the angle between the push vector (V) and vector component parallel to radius, so it should always be positive
			CGFloat angle = fabsf(fabsf(velocityAngle) - fabsf(locationAngle));
			// angular velocity formula: w = (abs(V) * sin(θ)) / abs(r)
			CGFloat angularVelocity = fabsf((fabsf(pushVelocity) * sinf(angle)) / fabsf(radius));
			
			// rotation direction is dependent upon which corner was pushed relative to the center of the view
			// when velocity.y is positive, pushes to the right of center rotate clockwise, left is counterclockwise
			CGFloat direction = (location.x < view.center.x) ? -1.0f : 1.0f;
			// when y component of velocity is negative, reverse direction
			if (velocity.y < 0)
            {
                direction *= -1;
            }
			
			// amount of angular velocity should be relative to how close to the edge of the view the force originated
			// angular velocity is reduced the closer to the center the force is applied
			// for angular velocity: positive = clockwise, negative = counterclockwise
			CGFloat xRatioFromCenter = fabsf(offsetFromCenter.horizontal) / (CGRectGetWidth(_card.frame) / 2.0f);
			CGFloat yRatioFromCetner = fabsf(offsetFromCenter.vertical) / (CGRectGetHeight(_card.frame) / 2.0f);
            
			// apply device scale to angular velocity
			angularVelocity *= deviceAngularScale;
			// adjust angular velocity based on distance from center, force applied farther towards the edges gets more spin
			angularVelocity *= ((xRatioFromCenter + yRatioFromCetner) / 2.0f);
			
            
			
			_push.pushDirection = CGVectorMake((velocity.x / velocityAdjust) * __velocityFactor, (velocity.y / velocityAdjust) * __velocityFactor);
			_push.active = YES;
            
            
            [_animator addBehavior:_push];
            
            
            //[_item addLinearVelocity:velocityInView forItem:_card];
            
            [_item addAngularVelocity:angularVelocity * __angularVelocityFactor * direction forItem:_card];
            
            
        
           // NSLog(@"pushMagnitude: %f", _push.magnitude);
            
            
			
			// delay for dismissing is based on push velocity also
            CGFloat delayFactor = pushVelocity * 0.000117;
            NSLog(@"delayFactor: %f",delayFactor);
            
            CGFloat pushDelay =  __maximumDismissDelay + delayFactor;
           // NSLog(@"pushDelay: %f",pushDelay);
            
            
            CGFloat delay = pushDelay;
            
            NSNumber *delayNumber = [NSNumber numberWithFloat:delay];
            NSString *delayNumberString = [NSNumberFormatter localizedStringFromNumber:delayNumber numberStyle:NSNumberFormatterDecimalStyle];
           
            
            //[self performSelector:@selector(dismissAfterPush) withObject:nil afterDelay:1.0];
            
            
            if (pushVelocity > 1200) {
                [self performSelector:@selector(dismissAfterPush) withObject:nil afterDelay:delay];
                 _delayLable.text = delayNumberString;

            }
            else {
                [self returnToCenter];
            }
            
            
        }
        else
        {
            [self returnToCenter];
        }
    }
}

-(void)dismissAfterPush {
    [self returnToCenter];
}

- (void)returnToCenter {
	if (_animator) {
		[_animator removeAllBehaviors];
        //[_animator addBehavior:_item];
        // ADD THE XRAY COMPONENT
//        DynamicXray *xray = [[DynamicXray alloc] init];
//        [_animator addBehavior:xray];
       
	}
//	[UIView animateWithDuration:0.39 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		_card.transform = CGAffineTransformIdentity;
//		_card.frame = _originalFrame;
//	} completion:nil];
    
    
    
    
    /* Distance Formula */
    
    // Travel Time = Card Width 180 cut in half 90 points per second
    CGFloat dx = self.view.center.x - _card.center.x;
    CGFloat dy = self.view.center.y - _card.center.y;
    CGFloat distance = sqrtf(dx*dx + dy*dy);
   // NSLog(@"Distance: %f",distance);
    NSNumber *distanceNumber = [NSNumber numberWithFloat:distance];
    NSString *distanceString = [NSNumberFormatter localizedStringFromNumber:distanceNumber numberStyle:NSNumberFormatterNoStyle];
    _distanceLabel.text = distanceString;
    
    self.timeFactor = 0;
   // self.speedNumber = 270;
    
    CGFloat speed = self.speedNumber; //270;
    CGFloat baseTime = 0.31;
    
    CGFloat initVelocity = speed / distance;
    //NSLog(@"initVelocity: %f",initVelocity);
     NSLog(@" self.speedNumber: %f",self.speedNumber);
    
    
    
    
    
    CGFloat distanceMultiplyer = 0.0001;
    CGFloat returnDamp = RETURN_DAMPING + distanceMultiplyer;
    

    CGFloat initialVelocitymMultiplyer = 0.003;
    if (distance < 320)
    {
        iVel = distance * initialVelocitymMultiplyer;
        time = baseTime + distance / speed;
    }
    else
    {
    time = 1.012;
    iVel = 1.111;
    }
    
    
    NSNumber *initialVelocityNumber = [NSNumber numberWithFloat:iVel];
    NSString *initialVelocityString = [NSNumberFormatter localizedStringFromNumber:initialVelocityNumber numberStyle:NSNumberFormatterDecimalStyle];
    _initialVelocityLabel.text = initialVelocityString;
    
    
    
   
    
    
    NSTimeInterval *theTime = &(time);
    NSNumber *theTimeNumber = [NSNumber numberWithDouble:*theTime];
    NSString *theTimeString = [NSNumberFormatter localizedStringFromNumber:theTimeNumber numberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *timeNumber = [NSNumber numberWithFloat:time];
    NSString *timeString = [NSNumberFormatter localizedStringFromNumber:timeNumber numberStyle:NSNumberFormatterNoStyle];
    _timeLabel.text = theTimeString;

   // NSLog(@"time: %f",time);

    
    [UIView animateWithDuration:*theTime delay:0.0 usingSpringWithDamping:returnDamp initialSpringVelocity:iVel options:UIViewAnimationOptionCurveEaseOut animations:^{
        _card.transform = CGAffineTransformIdentity;
		_card.frame = _originalFrame;
    } completion:^(BOOL finished) {
        //
    }];
}


-(CGSize)makeSizeFromBase:(CGFloat)base withRatio:(int)x by:(int)y {
    
    CGSize size  = CGSizeZero;
    
    if (x > y) {
        
        CGFloat n = base/x;
        CGFloat height = n * x;
        CGFloat width = n * y;
        
        size = CGSizeMake(width, height);
    }
    else {
        
        CGFloat n = base/y;
        CGFloat height = n * x;
        CGFloat width = n * y;
        
        size = CGSizeMake(width, height);
    }
    
    NSLog(@"Size Made: %@",NSStringFromCGSize(size));
    return size;
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setSpeedValue:self.speedNumber];

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

  
}

#pragma mark - Options Panel

-(void)setupOptionsPanel {
    
    
    
    // Options Panel
    CGRect panelRect = CGRectMake(0, -PANEL_HEIGHT, 320, PANEL_HEIGHT);
   
    self.visualEffectPanel = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectPanel.frame = panelRect;
    
    self.speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 40)];
    self.speedLabel.textColor = [UIColor whiteColor];
    self.speedLabel.textAlignment = NSTextAlignmentCenter;
    self.speedLabel.text = @"Current Speed";
    
    self.speedValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 320, 100)];
    self.speedValueLabel.textColor = [UIColor whiteColor];
    self.speedValueLabel.textAlignment = NSTextAlignmentCenter;
    
    NSNumber *timeNumber = [NSNumber numberWithFloat:self.speedNumber];
    NSString *timeString = [NSNumberFormatter localizedStringFromNumber:timeNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.speedValueLabel.text = timeString;
    
    [self.visualEffectPanel.contentView addSubview:self.speedValueLabel];
    [self.visualEffectPanel.contentView addSubview:self.speedLabel];
    
    CGSize buttonSize =  CGSizeMake(160, 50);
    
    UIView *plusView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, buttonSize.width, buttonSize.height)];
    plusView.backgroundColor = [UIColor grayColor];
    
    UILabel *plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    plusLabel.textAlignment = NSTextAlignmentCenter;
    plusLabel.text = @"+";
    plusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    plusLabel.textColor = [UIColor whiteColor];
    [plusView addSubview:plusLabel];
    
    UIView *minusView = [[UIView alloc]initWithFrame:CGRectMake(160, 120, buttonSize.width, buttonSize.height)];
    minusView.backgroundColor = [UIColor grayColor];
    
    UILabel *minusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    minusLabel.textAlignment = NSTextAlignmentCenter;
    minusLabel.text = @"-";
    minusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    minusLabel.textColor = [UIColor whiteColor];
    [minusView addSubview:minusLabel];
    
    
    
    self.resLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 320, 20)];
    self.resLabel.textAlignment = NSTextAlignmentCenter;
    self.resLabel.textColor = [UIColor whiteColor];
    
    
    CGRectMake(0, 220, 320, 40);
    
    UIView *rPlusView = [[UIView alloc]initWithFrame:CGRectMake(0, 220, buttonSize.width, buttonSize.height)];
    rPlusView.backgroundColor = [UIColor grayColor];
    
    UILabel *rPlusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    rPlusLabel.textAlignment = NSTextAlignmentCenter;
    rPlusLabel.text = @"+";
    rPlusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    rPlusLabel.textColor = [UIColor whiteColor];
    [rPlusView addSubview:rPlusLabel];
    
    UIView *rMinusView = [[UIView alloc]initWithFrame:CGRectMake(160, 220, buttonSize.width, buttonSize.height)];
    rMinusView.backgroundColor = [UIColor grayColor];
    
    UILabel *rMinusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    rMinusLabel.textAlignment = NSTextAlignmentCenter;
    rMinusLabel.text = @"-";
    rMinusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    rMinusLabel.textColor = [UIColor whiteColor];
    [rMinusView addSubview:rMinusLabel];
    
    UITapGestureRecognizer *rPlusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleRPlusTap:)];
    [rPlusView addGestureRecognizer:rPlusTap];
    
    UITapGestureRecognizer *rMinusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleRMinusTap:)];
    [rMinusView addGestureRecognizer:rMinusTap];


  
    [self.visualEffectPanel.contentView addSubview:rPlusView];
    [self.visualEffectPanel.contentView addSubview:rMinusView];
    
    NSNumber *resistanceNumber = [NSNumber numberWithFloat:self.resistanceValue];
    NSString *resistanceString = [NSNumberFormatter localizedStringFromNumber:resistanceNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.resLabel.text = resistanceString;
    
    [self.visualEffectPanel.contentView addSubview:self.resLabel];
    
    
    
    
    UITapGestureRecognizer *plusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePlusTap:)];
    [plusView addGestureRecognizer:plusTap];
    
    UITapGestureRecognizer *minusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMinusTap:)];
    [minusView addGestureRecognizer:minusTap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.visualEffectPanel addGestureRecognizer:swipe];

    
    [self.visualEffectPanel.contentView addSubview:plusView];
    [self.visualEffectPanel.contentView addSubview:minusView];

}


#pragma mark - Panel Gestures

-(void)handleSwipe {
    
    [UIView animateWithDuration:0.68 delay:0.12 usingSpringWithDamping:0.6 initialSpringVelocity:0.43 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.visualEffectPanel.frame = CGRectMake(0, -PANEL_HEIGHT, 320, PANEL_HEIGHT);
        
    } completion:^(BOOL finished){
    }];

    
}

-(void)handleRMinusTap:(UITapGestureRecognizer *)tap{
    
    UIView *tappedView = tap.view;
    [UIView animateWithDuration:0.08 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        tappedView.alpha = 0.20;
    } completion:^(BOOL finished) {
        //
        tappedView.alpha = 1.0;
    }];
    
    CGFloat oldNumber = self.resistanceValue;
    CGFloat newNumber = oldNumber - 100;
    self.resistanceValue = newNumber;
    
    NSNumber *rNumber = [NSNumber numberWithFloat:self.resistanceValue];
    NSString *rString = [NSNumberFormatter localizedStringFromNumber:rNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.resLabel.text = rString;

    
}

-(void)handleMinusTap:(UITapGestureRecognizer *)tap{
    
    UIView *tappedView = tap.view;
    [UIView animateWithDuration:0.08 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        tappedView.alpha = 0.20;
    } completion:^(BOOL finished) {
        //
        tappedView.alpha = 1.0;
    }];

    
    CGFloat oldNumber = self.speedNumber;
    CGFloat newNumber = oldNumber - INCREMENT_VALUE;
    self.speedNumber = newNumber;
    
    NSNumber *timeNumber = [NSNumber numberWithFloat:self.speedNumber];
    NSString *timeString = [NSNumberFormatter localizedStringFromNumber:timeNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.speedValueLabel.text = timeString;
    
}
-(void)handleRPlusTap:(UITapGestureRecognizer *)tap{
    
    UIView *tappedView = tap.view;
    [UIView animateWithDuration:0.08 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        tappedView.alpha = 0.20;
    } completion:^(BOOL finished) {
        //
        tappedView.alpha = 1.0;
    }];

    
    
    CGFloat oldNumber = self.resistanceValue;
    CGFloat newNumber = oldNumber + 100;
    self.resistanceValue = newNumber;
    
    NSNumber *rNumber = [NSNumber numberWithFloat:self.resistanceValue];
    NSString *rString = [NSNumberFormatter localizedStringFromNumber:rNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.resLabel.text = rString;
    
}

-(void)handlePlusTap:(UITapGestureRecognizer *)tap{
    
    UIView *tappedView = tap.view;
    [UIView animateWithDuration:0.08 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        tappedView.alpha = 0.20;
    } completion:^(BOOL finished) {
        //
        tappedView.alpha = 1.0;
    }];

    
    
    
    CGFloat oldNumber = self.speedNumber;
    CGFloat newNumber = oldNumber + INCREMENT_VALUE;
    self.speedNumber = newNumber;
    
    NSNumber *timeNumber = [NSNumber numberWithFloat:self.speedNumber];
    NSString *timeString = [NSNumberFormatter localizedStringFromNumber:timeNumber numberStyle:NSNumberFormatterDecimalStyle];
    self.speedValueLabel.text = timeString;
    
}

- (IBAction)settingsPressed:(id)sender {
    if (self.optionsPanelVisible == NO) {
        self.optionsPanelVisible = YES;
        
        [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //
            self.visualEffectPanel.frame = CGRectMake(0, 0, 320, PANEL_HEIGHT);
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        self.optionsPanelVisible = NO;
        [UIView animateWithDuration:0.75 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.visualEffectPanel.frame = CGRectMake(0, -PANEL_HEIGHT, 320, PANEL_HEIGHT);

        } completion:^(BOOL finished){
        }];

    }
    
   }




@end
