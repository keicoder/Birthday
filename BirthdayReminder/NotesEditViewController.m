//
//  NotesEditViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "NotesEditViewController.h"

@interface NotesEditViewController ()

@end

@implementation NotesEditViewController

#pragma mark - UITextViewDelegate 프로토콜의 메소드
// textViewDidChange: 콜백 --> 이 메소드는 텍스트 뷰에서 텍스트가 변경될 때마다 일어남

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"User changed the notes text : %@", self.textView.text);
}


#pragma mark - 뷰 라이프 사이클 (사용자가 노트 뷰로 넘어올 때 자동으로 키보드 표시)

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
