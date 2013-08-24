//
//  NotesEditViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

// UITextView는 UIScrollView의 하위 클래스임 (*UIControl의 하위 클래스가 아니므로 타깃-액션 이벤트를 사용할 수 없음)
// 따라서 텍스트 뷰 인스턴스에서 텍스트가 변경되는 시점을 잡아내기 위해서는 텍스트 뷰의 델리게이트로 설정하고, UITextViewDelegate 프로토콜을 구현해야 함.
// 여기에서 필요한 UITextViewDelegate 프로토콜의 메소드는 textViewDidChange: 콜백임.
// 이 메소드는 텍스트 뷰에서 텍스트가 변경될 때마다 일어남.

#import "CoreViewController.h"

@class DBirthday;


@interface NotesEditViewController : CoreViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

// birthday 속성 추가
@property (nonatomic, strong) DBirthday *birthday;


@end
