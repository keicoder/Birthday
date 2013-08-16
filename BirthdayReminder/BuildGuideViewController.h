//
//  BuildGuideViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "CoreViewController.h"
#import <QuartzCore/QuartzCore.h>   // 화면캡쳐 예제 (longPressGesture 액션에 구현)


@interface BuildGuideViewController : CoreViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
