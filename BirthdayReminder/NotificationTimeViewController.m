//
//  NotificationTimeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "NotificationTimeViewController.h"
#import "StyleSheet.h"

@interface NotificationTimeViewController ()

@end

@implementation NotificationTimeViewController


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // StyleSheet 클래스 임포트 후 styleLabel 메소드 호출
	[StyleSheet styleLabel:self.whatTimeLabel withType:LabelTypeLarge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIDatePicker 액션 메소드

- (IBAction)didChangeTime:(id)sender
{
    // NSDateComponents는 날짜를 개별 연도, 월, 일, 시간, 분, 초 요소로 나눠준다.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self.timePicker.date];
    
    NSLog(@"Changed time to %d:%d", components.hour, components.minute);
}
@end
