//
//  BuildGuideViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "BuildGuideViewController.h"

@implementation BuildGuideViewController

// 핀치 및 회전 감지
CGFloat scale, previousScale;
CGFloat rotation, previousRotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 핀치 및 회전 감지
    previousScale = 1;
    
    UIImage *image = [UIImage imageNamed:@"BRAppGuide01.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.userInteractionEnabled = YES;
    //self.imageView.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width/7, [[UIScreen mainScreen] applicationFrame].size.height/7);
    self.imageView.multipleTouchEnabled = YES;
    //self.imageView.center = CGPointMake(160, 160);
    self.imageView.frame = CGRectMake(0, 40, 320, 528);
    //self.imageView.frame = CGRectMake(5, 5, image.size.width,image.size.height);
    [self.view addSubview:self.imageView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate = self;
    [self.imageView addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(doRotate:)];
    rotationGesture.delegate = self;
    [self.imageView addGestureRecognizer:rotationGesture];
    
    // 드래그 감지
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doDrag:)];
    panGesture.delegate = self;
    [self.imageView addGestureRecognizer:panGesture];
    
    /*
    // Long Press 감지
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:(doLongPress:)];
    longGesture.minimumPressDuration = 1.5;   // 최소 몇 초간 눌러야 인식할지 설정
    longGesture.allowableMovement = 15;       // 어느정도 거리까지 누른 상태로 이동해도 인식할지 설정
    longGesture.numberOfTouchesRequired = 1;  // 몇 개의 손가락으로 터치해야  인식할지 설정
    longGesture.delegate = self;
    [self.imageView addGestureRecognizer:longGesture];
    */
}

#pragma mark - 핀치 및 회전 감지

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)transformImageview
{
    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale, scale * previousScale);
    t = CGAffineTransformRotate(t, rotation + previousRotation);
    self.imageView.transform = t;
}


- (void)doPinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"Pinch Gesture detected!");
    
    scale = gesture.scale;
    [self transformImageview];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousScale = scale * previousScale;
        scale = 1;
    }
}


- (void)doRotate:(UIRotationGestureRecognizer *)gesture
{
    NSLog(@"Rotation Gesture detected!");
    
    rotation = gesture.rotation;
    [self transformImageview];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousRotation = rotation * previousRotation;
        rotation = 0;
    }
}


#pragma mark - 드래그(Pan) 감지

- (void)doDrag:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Pan Gesture detected!");
    
    UIView *piece = [gesture view];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        
        [gesture setTranslation:CGPointZero inView:[piece superview]];
    }
}

/*
#pragma mark - Long Press 감지

- (void)doLongPress:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"Long Press Gesture detected!");
}
*/


@end
