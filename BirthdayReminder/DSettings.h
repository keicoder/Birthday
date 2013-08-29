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

@interface DSettings : NSObject


+ (DSettings*)sharedInstance;

@property (nonatomic) int notificationHour;
@property (nonatomic) int notificationMinute;
@property (nonatomic) DaysBeforeType daysBefore;

-(NSString *) titleForNotificationTime;
-(NSString *) titleForDaysBefore:(DaysBeforeType)daysBefore;



@end
