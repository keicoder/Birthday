//
//  HomeViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"


// 데이블 뷰의 데이터소스 및 델리게이트로 선언
// UITableViewDataSource의 필수 메소드 (– tableView:numberOfRowsInSection:, – tableView:cellForRowAtIndexPath:)

@interface HomeViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
