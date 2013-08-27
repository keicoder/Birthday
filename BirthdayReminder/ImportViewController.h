//
//  ImportViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 26..
//  Copyright (c) 2013년 jun. All rights reserved.
//

// 연락처 임포트 뷰의 데이블 뷰로 연락처 사진 및 데이터를 불러오기 위해 상위 클래스인 ImportViewController를 활용해 내용을 채움
// -> 이렇게 하면 연락처 불러오기 뷰 뿐만 아니라 나중에 페이스북 불러오기 뷰 컨트롤러를 개발할 때도 상위 클래스에서 로직을 이미 구현한 만큼 시간을 절약할 수 있다.



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