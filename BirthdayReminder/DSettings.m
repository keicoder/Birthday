//
//  DSettings.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//


#import "DSettings.h"
#import "DBirthday.h"

@implementation DSettings


static DSettings *_sharedInstance = nil;

static NSDateFormatter *dateFormatter;

@synthesize notificationHour;
@synthesize notificationMinute;

// 싱글톤 인스턴스의 접근자 메소드
// accessor method for the singleton instance
+ (DSettings*)sharedInstance {
	if( !_sharedInstance ) {
		_sharedInstance = [[DSettings alloc] init];
	}
	return _sharedInstance;
}


-(int) notificationHour
{
    // 사용자가 알림 시간을 저장했는지 확인. 저장하지 않았다면 기본으로 오전 9시를 설정
    // checks if user has saved a notification hour - if not, defaults to 9am
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *hour = [userDefaults objectForKey:@"notificationHour"];
    if (hour == nil) {
        return 9;
    }
    return [hour intValue];
}


-(void) setNotificationHour:(int)notificationHourNew
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:notificationHourNew] forKey:@"notificationHour"];
    [userDefaults synchronize];
}


-(int) notificationMinute
{
    // 사용자가 알림 분을 저장했는지 확인. 저장하지 않았다면 기본으로 0분를 설정
    // checks if user has saved a notification minute - if not, defaults to 0 minutes on the hour
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *hour = [userDefaults objectForKey:@"notificationMinute"];
    if (hour == nil) {
        return 0;
    }
    return [hour intValue];
}


-(void) setNotificationMinute:(int)notificationMinuteNew
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:notificationMinuteNew] forKey:@"notificationMinute"];
    [userDefaults synchronize];
}


-(DaysBeforeType) daysBefore
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *daysBefore = [userDefaults objectForKey:@"daysBefore"];
    if (daysBefore == nil) {
        return DaysBeforeTypeOnBirthday;
    }
    return [daysBefore intValue];
}


-(void) setDaysBefore:(DaysBeforeType)daysBeforeNew
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:daysBeforeNew] forKey:@"daysBefore"];
    [userDefaults synchronize];
}


-(NSString *) titleForDaysBefore:(DaysBeforeType)daysBefore
{
    switch (daysBefore) {
        case DaysBeforeTypeOnBirthday:
            return @"On Birthday";
        case DaysBeforeTypeOneDay:
            return @"1 Day Before";
        case DaysBeforeTypeTwoDays:
            return @"2 Days Before";
        case DaysBeforeTypeThreeDays:
            return @"3 Days Before";
        case DaysBeforeTypeFiveDays:
            return @"5 Days Before";
        case DaysBeforeTypeOneWeek:
            return @"1 Week Before";
        case DaysBeforeTypeTwoWeeks:
            return @"2 Weeks Before";
        case DaysBeforeTypeThreeWeeks:
            return @"3 Weeks Before";
    }
    return @"";
}


-(NSString *) titleForNotificationTime
{
    int hour = [DSettings sharedInstance].notificationHour;
    int minute = [DSettings sharedInstance].notificationMinute;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    components.hour = hour;
    components.minute = minute;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    if (dateFormatter == nil) {
        // 9:00 am, 2:00 pm 같은 시간을 반환하게끔 날짜 포매터를 생성
        // create a single date formatter to return 9:00am, 2:00pm etc...
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
    }
    
    return [dateFormatter stringFromDate:date];
}


// 사용자 환경 설정에 따른 생일 알림 날짜/시간 계산을 위한 핼퍼 메소드
-(NSDate *) reminderDateForNextBirthday:(NSDate *)nextBirthday
{
    NSTimeInterval timeInterval;
    NSTimeInterval secondsInOneDay = 60.f * 60.f * 24.f;
    
    //work out how many days to detract from the friend's next birthday for the reminder date
    switch (self.daysBefore) {
        case DaysBeforeTypeOnBirthday:
            timeInterval = 0.f;
            break;
        case DaysBeforeTypeOneDay:
            timeInterval = secondsInOneDay;
            break;
        case DaysBeforeTypeTwoDays:
            timeInterval = secondsInOneDay * 2.f;
            break;
        case DaysBeforeTypeThreeDays:
            timeInterval = secondsInOneDay * 3.f;
            break;
        case DaysBeforeTypeFiveDays:
            timeInterval = secondsInOneDay * 5.f;
            break;
        case DaysBeforeTypeOneWeek:
            timeInterval = secondsInOneDay * 7.f;
            break;
        case DaysBeforeTypeTwoWeeks:
            timeInterval = secondsInOneDay * 14.f;
            break;
        case DaysBeforeTypeThreeWeeks:
            timeInterval = secondsInOneDay * 21.f;
            break;
    }
    
    //This creates the day of the reminder at time 00:00
    NSDate *reminderDate = [nextBirthday dateByAddingTimeInterval:-timeInterval];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:reminderDate];
    
    //update the hour and minute of the reminder time
    components.hour = self.notificationHour;
    components.minute = self.notificationMinute;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}



// 알림 날짜 및 친구의 다음 생일 사이의 차이를 기반으로 알림 텍스트를 설정하기 위한 핼퍼 메소드
-(NSString *) reminderTextForNextBirthday:(DBirthday *)birthday
{
    NSString *text;
    
    if ([birthday.nextBirthdayAge intValue] > 0)
    {
        if (self.daysBefore == DaysBeforeTypeOnBirthday) {
            //if the friend's birthday is the same day as the reminder eg. "Joe is 30 today"
            text = [NSString stringWithFormat:@"%@ is %@ ",birthday.name,birthday.nextBirthdayAge];
        }
        else {
            //reminder is in advance of the birthday eg. "Joe will be 30 tomorrow"
            text = [NSString stringWithFormat:@"%@ will be %@ ",birthday.name,birthday.nextBirthdayAge];
        }
    }
    else {
        text = [NSString stringWithFormat:@"It's %@'s Birthday ",birthday.name];
    }
    
    switch (self.daysBefore) {
        case DaysBeforeTypeOnBirthday:
            return [text stringByAppendingFormat:@"today!"];
        case DaysBeforeTypeOneDay:
            return [text stringByAppendingFormat:@"tomorrow!"];
        case DaysBeforeTypeTwoDays:
            return [text stringByAppendingFormat:@"in 2 days!"];
        case DaysBeforeTypeThreeDays:
            return [text stringByAppendingFormat:@"in 3 days!"];
        case DaysBeforeTypeFiveDays:
            return [text stringByAppendingFormat:@"in 5 days!"];
        case DaysBeforeTypeOneWeek:
            return [text stringByAppendingFormat:@"in 1 week!"];
        case DaysBeforeTypeTwoWeeks:
            return [text stringByAppendingFormat:@"in 2 weeks!"];
        case DaysBeforeTypeThreeWeeks:
            return [text stringByAppendingFormat:@"in 3 weeks!"];
    }
    
    return @"";
}


@end
