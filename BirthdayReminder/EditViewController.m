//
//  EditViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 생일 편집 뷰에서 Cancel 버튼을 눌렀을 때 홈 뷰 컨트롤러로 되돌아가기 위한 메소드.

- (IBAction)cancelAndDismiss:(id)sender
{
    NSLog(@"Cancel Button Clicked!");
    [self dismissViewControllerAnimated:YES completion:^{
        // 이 코드 블럭에 집어넣는 코드는 뷰 컨트롤러가 사라진 후 실행된다.
        // 오브젝티브 C 에서 블록은 변수처럼 넘겨줄 수 있는 코드 영역임.
        NSLog(@"Dismiss Complete!");
    }];
}
@end
