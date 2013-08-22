//
//  DBirthday.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 21..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DBirthday.h"


@implementation DBirthday

@dynamic birthDay;
@dynamic addressBookID;
@dynamic birthMonth;
@dynamic birthYear;
@dynamic facebookID;
@dynamic imageData;
@dynamic name;
@dynamic nextBirthday;
@dynamic nextBirthdayAge;
@dynamic notes;
@dynamic picURL;
@dynamic uid;


#pragma mark - updateNextBirthdayAndAge (nextBirthday와 nextBirthdayAge를 업데이트하는데 이용)

- (void) updateNextBirthdayAndAge
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:dateComponents];
    
    dateComponents.day = [self.birthDay intValue]; // 친구의 생일 일자 설정
    dateComponents.month = [self.birthMonth intValue]; // 친구의 생일 달 설정
    
    NSDate *birthdayThisYear = [calendar dateFromComponents:dateComponents]; // 친구의 올해 생일
    
    if ([today compare:birthdayThisYear] == NSOrderedDescending) {
        // 올해 생일은 지났으므로 다음 생일은 내년에 돌아온다
        dateComponents.year++;
        self.nextBirthday = [calendar dateFromComponents:dateComponents];
    } else {
        self.nextBirthday = [birthdayThisYear copy];
    }
    
    if ([self.birthYear intValue] > 0) {
        self.nextBirthdayAge = [NSNumber numberWithInt:dateComponents.year - [self.birthYear intValue]];
    } else {
        self.nextBirthdayAge = [NSNumber numberWithInt:0];
    }
}


#pragma mark - updateWithDefaults (Add 버튼을 탭할 때 호출)

- (void) updateWithDefaults
{
    // DBirthday 엔티티의 필수 어트리뷰트인 birthDay와 birthMonth를 설정하기 위해 Add 버튼을 탭할 때 호출

    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    self.birthDay = @(dateComponents.day);
    self.birthMonth = @(dateComponents.month);
    self.birthYear = @0;
    
    [self updateNextBirthdayAndAge];
}


#pragma mark - 세 개의 읽기 전용 게터 메소드 (remainingDaysUntilNextBirthday, isBirthdayToday, birthdayNextToDisplay)

- (int) remainingDaysUntilNextBirthday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    NSTimeInterval timeDiffSecs = [self.nextBirthday timeIntervalSinceDate:today];
    int days = floor(timeDiffSecs/(60.f*60.f*24.f));
    
    return days;
}


- (BOOL) isBirthdayToday
{
    return [self remainingDaysUntilNextBirthday] == 0;
}


- (NSString *) birthdayNextToDisplay
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:self.nextBirthday options:0]; // 핵심 코드 : NSDateComponents 클래스로 두 날짜 사이의 차이를 계산
    
    if (components.month == 0) {
        if (components.day == 0) {
            // 오늘!
            if ([self.nextBirthdayAge intValue] > 0) {
                return [NSString stringWithFormat:@"%@ Today!", self.nextBirthdayAge];
            } else {
                return @"Today!";
            }
        }
        if (components.day == 1) {
            // 내일!
            if ([self.nextBirthdayAge intValue] > 0) {
                return [NSString stringWithFormat:@"%@ Tomorrow!", self.nextBirthdayAge];
            } else {
                return @"Tomorrow!";
            }
        }
    }
    
    NSString *text = @"";
    
    if ([self.nextBirthdayAge intValue] > 0) {
        text = [NSString stringWithFormat:@"%@ on ", self.nextBirthdayAge];
    }
    
    static NSDateFormatter *dateFormatterPartial;
    
    if (dateFormatterPartial == Nil) {
        dateFormatterPartial = [[NSDateFormatter alloc] init];
        [dateFormatterPartial setDateFormat:@"MMM d"];
    }
    
    return [text stringByAppendingFormat:@"%@", [dateFormatterPartial stringFromDate:self.nextBirthday]];
}


@end