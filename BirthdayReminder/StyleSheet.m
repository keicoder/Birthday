//
//  StyleSheet.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 25..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "StyleSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "ActionButton.h"
#import "DeleteButton.h"

#define kFontLightOnDarkTextColour [UIColor colorWithRed:255.0/255 green:251.0/255 blue:218.0/255 alpha:1.0]
#define kFontDarkOnLightTextColour [UIColor colorWithRed:1.0/255 green:1.0/255 blue:1.0/255 alpha:1.0]

// #define kFontNavigationTextColour [UIColor colorWithRed:106.f/255.f green:62.f/255.f blue:39.f/255.f alpha:1.f]
#define kFontNavigationTextColour [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1.f] // greyColor
#define kFontNavigationDisabledTextColour [UIColor colorWithRed:106.f/255.f green:62.f/255.f blue:39.f/255.f alpha:0.6f]
#define kNavigationButtonBackgroundColour [UIColor colorWithRed:255.f/255.f green:245.f/255.f blue:225.f/255.f alpha:1.f]
#define kToolbarButtonBackgroundColour [UIColor colorWithRed:39.f/255.f green:17.f/255.f blue:5.f/255.f alpha:1.f]
#define kLargeButtonTextColour [UIColor whiteColor]

#define kFontNavigation [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f]
#define kFontName [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.f]
#define kFontBirthdayDate [UIFont fontWithName:@"HelveticaNeue" size:13.f]
#define kFontDaysUntilBirthday [UIFont fontWithName:@"HelveticaNeue-Bold" size:25.f]
#define kFontDaysUntillBirthdaySubText [UIFont fontWithName:@"HelveticaNeue" size:9.f]
#define kFontLarge [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]
#define kFontButton [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.f]
#define kFontNotes [UIFont fontWithName:@"HelveticaNeue" size:16.f]
#define kFontPicPhoto [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f]
#define kFontDropShadowColour [UIColor colorWithRed:1.0/255 green:1.0/255 blue:1.0/255 alpha:0.75]

#define kFontJun [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f]
#define kFontJunTextColour [UIColor colorWithRed:47.f/255 green:79.f/255 blue:79.f/255 alpha:1.0] // dark slate gray


@implementation StyleSheet

#pragma mark - 홈 테이블 뷰외 셀 및 다양한 뷰의 라벨, 뷰에 적용할 스타일 시트 public 클래스 메소드

+(void)styleLabel:(UILabel *)label withType:(LabelType)labelType
{
    switch (labelType) {
        case LabelTypeName:
            label.font = kFontName;
            label.layer.shadowColor = kFontDropShadowColour.CGColor;
            label.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            label.layer.shadowRadius = 0.0f;
            label.layer.masksToBounds = NO;
            label.textColor = kFontLightOnDarkTextColour;
            break;
        case LabelTypeBirthdayDate:
            label.font = kFontBirthdayDate;
            label.textColor = kFontLightOnDarkTextColour;
            break;
        case LabelTypeDaysUntilBirthday:
            label.font = kFontDaysUntilBirthday;
            label.textColor = kFontDarkOnLightTextColour;
            break;
        case LabelTypeDaysUntilBirthdaySubText:
            label.font = kFontDaysUntillBirthdaySubText;
            label.textColor = kFontDarkOnLightTextColour;
            break;
        case LabelTypeLarge:
            label.textColor = kFontLightOnDarkTextColour;
            label.layer.shadowColor = kFontDropShadowColour.CGColor;
            label.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            label.layer.shadowRadius = 0.0f;
            label.layer.masksToBounds = NO;
            break;
        case LabelTypeJun:
            label.font = kFontJun;
            label.textColor = kFontJunTextColour;
            break;
        default:
            label.textColor = kFontLightOnDarkTextColour;
            break;
    }
    
}


+(void)styleRoundCorneredView:(UIView *)view
{
    view.layer.cornerRadius = 4.f;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}


#pragma mark - 메모 편집 뷰외 텍스트 뷰에 적용할 스타일 시트 public 클래스 메소드

+(void)styleTextView:(UITextView *)textView
{
    textView.backgroundColor = [UIColor clearColor];
    textView.font = kFontNotes;
    textView.textColor = kFontLightOnDarkTextColour;
    textView.layer.shadowColor = kFontDropShadowColour.CGColor;
    textView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    textView.layer.shadowRadius = 0.0f;
    textView.layer.masksToBounds = NO;
}


#pragma mark - 네비게이션 바와 툴바 외양에 적용할 스타일 시트 public 클래스 메소드

+(void)initStyles
{
    // initStyles 메소드는 앱이 최초 실행될 때 한번만 호출한다.
    // 따라서 AppDelegate.m 파일의 application: didFinishLaunchingWithOptions: 메소드에서 이 메소드를 호출한다.
    
    // 네비게이션 바 텍스트 스타일 적용
    
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         kFontNavigationTextColour, UITextAttributeTextColor, nil];
    /*
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         kFontNavigationTextColour, UITextAttributeTextColor,
                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 2)], UITextAttributeTextShadowOffset,
                                         kFontNavigation, UITextAttributeFont,nil];
    */
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    
    
    // 네비게이션 바 배경 이미지
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"iOS_NavigationBar_BackgroundImage.png"] forBarMetrics:UIBarMetricsDefault];
    
     NSDictionary *barButtonItemTextAttributes;
    
    // 네비게이션 버튼
    // 네비게이션 버튼 배경에 틴트 효과 적용 (Tint of the navigation button backgrounds)
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class],nil] setTintColor:kNavigationButtonBackgroundColour];
    
    barButtonItemTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                   kFontNavigationTextColour, UITextAttributeTextColor,
                                   [UIColor whiteColor], UITextAttributeTextShadowColor,
                                   [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,nil];
    
    // appearanceWhenContainedIn 스타일 메소드를 통해 UIBarButtonItem 인스턴스에만 크림 색상 스타일 적용
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonItemTextAttributes forState:UIControlStateNormal];
    
    NSDictionary *disabledBarButtonItemTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         kFontNavigationDisabledTextColour, UITextAttributeTextColor,
                                                         [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:disabledBarButtonItemTextAttributes forState:UIControlStateDisabled];
    
    
    // 툴바
     
    // 툴바 배경 이미지
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"iOS_ToolBar_BackgroundImage.png"]  forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // 툴바 버튼
    //Dark background of Toolbar Buttons
    //Tint of the toolbar button backgrounds
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class],nil] setTintColor:kToolbarButtonBackgroundColour];
    
    // 회색 텍스트 on UIBarButtonItems
    barButtonItemTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor,nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
     setTitleTextAttributes:barButtonItemTextAttributes forState:UIControlStateNormal];
    
    // 버튼 (상세 뷰의 ActionButton 및 DeleteButton)
    // 새로만든 ActionButton 및 ActionButton의 하위 클래스인 DeleteButton 클래스 임포트
    //*** ActionButton의 제목 색상을 구현하면 하위 클래스인 DeleteButton도 이 스타일을 상속하게 됨
    [[ActionButton appearance] setBackgroundImage:[UIImage imageNamed:@"actionButton.png"] forState:UIControlStateNormal];
    [[ActionButton appearance] setTitleColor:kLargeButtonTextColour forState:UIControlStateNormal];
    // [[ActionButton appearance] setFont:kFontLarge];
    
    [[DeleteButton appearance] setBackgroundImage:[UIImage imageNamed:@"deleteButton.png"] forState:UIControlStateNormal];
    [[DeleteButton appearance] setTitleColor:kLargeButtonTextColour forState:UIControlStateNormal];
    // [[DeleteButton appearance] setFont:kFontLarge];
    
    // 테이블 뷰
    [[UITableView appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
}


@end
