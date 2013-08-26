//
//  ImportViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 26..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "CoreViewController.h"

@interface ImportViewController : CoreViewController <UITableViewDelegate, UITableViewDataSource>


// public 배열을 정의해 하위 클래스에서 이 배열 속성에 접근해 데이터를 설정할 수 있게 한다.
@property (strong, nonatomic) NSArray *birthdays;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTapImportButton:(id)sender;
- (IBAction)didTapSelectAllButton:(id)sender;
- (IBAction)didTapSelectNoneButton:(id)sender;



@end