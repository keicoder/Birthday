//
//  CoreViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "CoreViewController.h"

@interface CoreViewController ()

@end

@implementation CoreViewController


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 상속받는 모든 뷰의 백그라운드 칼라 지정
    self.view.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark - 뷰에서 Cancel, Save 버튼 등 특정 버튼을 눌렀을 때 뷰를 해제하기 위한 메소드.

- (IBAction)cancelAndDismiss:(id)sender
{
    NSLog(@"Cancel Button Clicked!");
    [self dismissViewControllerAnimated:YES completion:^{
        // 이 코드 블럭에 집어넣는 코드는 뷰 컨트롤러가 사라진 후 실행된다.
        // 오브젝티브 C 에서 블록은 변수처럼 넘겨줄 수 있는 코드 영역임.
    NSLog(@"Dismiss Complete!");
    }];
}

- (IBAction)saveAndDismiss:(id)sender
{
    NSLog(@"Save Button Clicked!");
    [self dismissViewControllerAnimated:YES completion:^{
        // 이 코드 블럭에 집어넣는 코드는 뷰 컨트롤러가 사라진 후 실행된다.
        // 오브젝티브 C 에서 블록은 변수처럼 넘겨줄 수 있는 코드 영역임.
        NSLog(@"Dismiss Complete!");
    }];
}



@end