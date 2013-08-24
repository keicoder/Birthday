//
//  NotesEditViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "NotesEditViewController.h"
#import "DBirthday.h"
#import "DModel.h"


@interface NotesEditViewController ()

@end

@implementation NotesEditViewController

@synthesize saveButton;
@synthesize textView;

@synthesize birthday;


#pragma mark - 뷰 라이프 사이클 (사용자가 노트 뷰로 넘어올 때 자동으로 키보드 표시)

// 편집 컨트롤러나 상세 뷰 컨트롤러와 마찬가지로 뷰가 보이려는 시점에 생일 엔티티로부터 내용 업데이트

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = self.birthday.notes;
    
    [self.textView becomeFirstResponder];
}


#pragma mark - UITextViewDelegate 프로토콜의 메소드

// textViewDidChange: 콜백 --> 이 메소드는 텍스트 뷰에서 텍스트가 변경될 때마다 일어남
// 사용자가 생일 메모를 수정하면 생일 엔티티를 업데이트

- (void)textViewDidChange:(UITextView *)textView
{
    // NSLog(@"User changed the notes text : %@", self.textView.text);
    self.birthday.notes = self.textView.text;
}


#pragma mark - Save나 Cancel 버튼을 탭했을 때 코어 데이터에 변경 사항 반영

// CoreViewController에서 구현한 saveAndDismiss public 메소드 오버라이드
// 모달 뷰 dismiss 및 코어 데이터에 저장 혹은 취소

- (IBAction)saveAndDismiss:(id)sender
{
    // DModel에서 구현한 saveChanges public 메소드 호출
    [[DModel sharedInstance] saveChanges];
    
    [super saveAndDismiss:sender];
}


- (IBAction)cancelAndDismiss:(id)sender
{
    // DModel에서 구현한 cancelChanges public 메소드 호출
    [[DModel sharedInstance] cancelChanges];
    
    [super cancelAndDismiss:sender];
}



@end
