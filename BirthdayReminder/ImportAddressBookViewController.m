//
//  ImportAddressBookViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 26..
//  Copyright (c) 2013년 jun. All rights reserved.
//

// ** ImportViewController의 하위 클래스

#import "ImportAddressBookViewController.h"
#import "DModel.h"

@interface ImportAddressBookViewController ()

@end

@implementation ImportAddressBookViewController

// 스텁 코드 제거

#pragma mark - 뷰 라이프 사이클

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ImportAddressBookViewController가 DModel의 NotificationAddressBookBirthdaysDidUpdate 알림을 수신해 처리하게 함.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddressBookBirthdaysDidUpdate:) name:NotificationAddressBookBirthdaysDidUpdate object:[DModel sharedInstance]];

    [[DModel sharedInstance] fetchAddressBookBirthdays];
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationAddressBookBirthdaysDidUpdate object:[DModel sharedInstance]];
}



#pragma mark - handleAddressBookBirthdaysDidUpdate

-(void)handleAddressBookBirthdaysDidUpdate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    self.birthdays = [userInfo objectForKey:@"birthdays"];
    [self.tableView reloadData];
    
    if ([self.birthdays count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry, No birthdays found in your address book" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}



@end
