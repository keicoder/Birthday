//
//  DSettings.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//


typedef enum : int {
    DaysBeforeTypeOnBirthday = 0,
    DaysBeforeTypeOneDay,
    DaysBeforeTypeTwoDays,
    DaysBeforeTypeThreeDays,
    DaysBeforeTypeFiveDays,
    DaysBeforeTypeOneWeek,
    DaysBeforeTypeTwoWeeks,
    DaysBeforeTypeThreeWeeks
}DaysBeforeType;


#import <Foundation/Foundation.h>
@class DBirthday;


@interface DSettings : NSObject


+ (DSettings*)sharedInstance;

@property (nonatomic) int notificationHour;
@property (nonatomic) int notificationMinute;
@property (nonatomic) DaysBeforeType daysBefore;

-(NSString *) titleForNotificationTime;
-(NSString *) titleForDaysBefore:(DaysBeforeType)daysBefore;


// 사용자 환경 설정에 따른 생일 알림 날짜/시간 계산을 위한 핼퍼 메소드
-(NSDate *) reminderDateForNextBirthday:(NSDate *)nextBirthday;
// 알림 날짜 및 친구의 다음 생일 사이의 차이를 기반으로 알림 텍스트를 설정하기 위한 핼퍼 메소드
-(NSString *) reminderTextForNextBirthday:(DBirthday *)birthday;


@end
