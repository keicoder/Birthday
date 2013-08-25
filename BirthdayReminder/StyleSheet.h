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

#pragma mark - 홈 테이블 뷰의 커스텀 테이블 뷰 셀에 적용할 스타일 시트 public 클래스 메소드
+(void)styleLabel:(UILabel *)label withType:(LabelType)labelType;
+(void)styleRoundCorneredView:(UIView *)view;

#pragma mark - 네비게이션 바와 툴바 외양에 적용할 스타일 시트 public 클래스 메소드
+(void)initStyles;

@end
