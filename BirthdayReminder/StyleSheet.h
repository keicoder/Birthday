//
//  StyleSheet.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 25..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {
    LabelTypeName = 0,
    LabelTypeBirthdayDate,
    LabelTypeDaysUntilBirthday,
    LabelTypeDaysUntilBirthdaySubText,
    LabelTypeLarge
}LabelType;


@interface StyleSheet : NSObject

+(void)styleLabel:(UILabel *)label withType:(LabelType)labelType;
+(void)styleRoundCorneredView:(UIView *)view;


@end
