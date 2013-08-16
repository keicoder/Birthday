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
    //self.imageView.center = CGPointMake(160, 160);
    //self.imageView.frame = CGRectMake(55, 300, 300, 200);
    //self.imageView.frame = CGRectMake(5, 5, image.size.width,image.size.height);
    [self.view addSubview:self.imageView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate = self;
    [self.imageView addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(doRotate:)];
    rotationGesture.delegate = self;
    [self.imageView addGestureRecognizer:rotationGesture];
}

#pragma mark -
#pragma mark 핀치 및 회전 감지


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
    scale = gesture.scale;
    [self transformImageview];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousScale = scale * previousScale;
        scale = 1;
    }
}


- (void)doRotate:(UIRotationGestureRecognizer *)gesture
{
    rotation = gesture.rotation;
    [self transformImageview];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousRotation = rotation * previousRotation;
        rotation = 0;
    }
}


@end
