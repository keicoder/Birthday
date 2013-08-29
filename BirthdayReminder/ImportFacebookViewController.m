//
//  ImportFacebookViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 28..
//  Copyright (c) 2013년 jun. All rights reserved.
//

// 페이스북 친구와 친구의 생일을 테이블 뷰에 보여줌
// 페이스북 사용자의 생일은 모델에서 처리하고 생일 불러오기 인스턴스로 변환해준다.
// 그런 다음 생일 불러오기 객체로 이뤄진 배열이 알림을 통해 옵저버 객체로 전달된다.
// 따라서 페이스북 불러오기 뷰 컨트롤러를 NotificationFacebookBirthdaysDidUpdate 알림의 옵저버로 설정해야 한다.
// 여기서는 페이스북 불러오기 뷰 컨트롤러가 나타날 때마다 이 컨트롤러를 옵저버로 등록하고 사라질 때는 등록을 해제한다.

#import "ImportFacebookViewController.h"
#import "DModel.h"

@interface ImportFacebookViewController ()

@end

@implementation ImportFacebookViewController



#pragma mark - 뷰 라이프 사이클


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookBirthdaysDidUpdate:) name:NotificationFacebookBirthdaysDidUpdate object:[DModel sharedInstance]];
    
    // 뷰가 화면에 보일 때마다 fetchAddressBookBirthdays 메소드 호출
    [[DModel sharedInstance] fetchAddressBookBirthdays];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFacebookBirthdaysDidUpdate object:[DModel sharedInstance]];
}


-(void)handleFacebookBirthdaysDidUpdate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    self.birthdays = userInfo[@"birthdays"];
    [self.tableView reloadData];
}




@end
