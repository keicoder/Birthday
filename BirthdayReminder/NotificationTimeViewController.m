//
//  NotificationTimeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "NotificationTimeViewController.h"
#import "StyleSheet.h"
#import "DSettings.h"

@interface NotificationTimeViewController ()

@end

@implementation NotificationTimeViewController


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // StyleSheet 클래스 임포트 후 styleLabel 메소드 호출
	[StyleSheet styleLabel:self.whatTimeLabel withType:LabelTypeDaysUntilBirthday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 알림 시간 및 분에 대한 사용자 설정을 조회
    // Retrieve the stored user settings for notification hour and minute
    int hour = [DSettings sharedInstance].notificationHour;
    int minute = [DSettings sharedInstance].notificationMinute;
    
    // NSDateComponents를 활용해 저장된 시간/분 설정을 적용해 오늘 날짜를 생성
    // Use NSDateComponents to create today's date with the hour/minute stored user notification settings
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    components.hour = hour;
    components.minute = minute;
    
    // 저장된 사용자 설정과 일치하는 시간/분을 보여주게끔 데이트 피커/시간 피커를 업데이트
    // Update the date/time picker to display the hour/minutes matching the stored user settings
    self.timePicker.date = [[NSCalendar currentCalendar] dateFromComponents:components];
}


#pragma mark - UIDatePicker 액션 메소드

- (IBAction)didChangeTime:(id)sender
{
    // NSDateComponents는 날짜를 개별 연도, 월, 일, 시간, 분, 초 요소로 나눠준다.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self.timePicker.date];
    
    // NSLog(@"Changed time to %d:%d", components.hour, components.minute);
    
    [DSettings sharedInstance].notificationHour = components.hour;
    [DSettings sharedInstance].notificationMinute = components.minute;
}
@end
