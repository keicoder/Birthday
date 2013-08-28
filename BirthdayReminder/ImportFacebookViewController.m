//
//  ImportFacebookViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 28..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "ImportFacebookViewController.h"
#import "DModel.h"

@interface ImportFacebookViewController ()

@end

@implementation ImportFacebookViewController



#pragma mark - 뷰 라이프 사이클

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


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 뷰가 화면에 보일 때마다 fetchAddressBookBirthdays 메소드 호출
    [[DModel sharedInstance] fetchAddressBookBirthdays];
}


@end
