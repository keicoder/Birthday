//
//  HomeViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"
#import "ActionButton.h" // DeleteButton은 ActionButton 클래스의 하위 클래스 이므로 자동으로 버튼 스타일이 적용 됨


// 데이블 뷰의 데이터소스 및 델리게이트로 선언
// UITableViewDataSource의 필수 메소드 (– tableView:numberOfRowsInSection:, – tableView:cellForRowAtIndexPath:)
// NSFetchedResultsController 클래스 : 코어 데이터 엔티티에 저장된 결과셋을 조회, 변경사항을 델리게이트에 알려줌
// --> 이를 통해 객체의 새로운 추가, 수정, 삭제같은 변경사항을 알 수 있음
// --> 여기서는 코어 데이터 저장소 내의 Birthday 엔티티 목록을 추적하고 이를 홈 뷰 컨트롤러에 보여줄 때 이 클래스 사용함
// 홈 뷰 컨트롤러가 NSFetchedResultsControllerDelegate 프로토콜을 구현한다고 선언


@interface HomeViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *importLabel;
@property (weak, nonatomic) IBOutlet ActionButton *addressBookButton;
@property (weak, nonatomic) IBOutlet ActionButton *facebookButton;

// 컨테이너 뷰(importView)에 대한 아웃렛은 생일 데이타베이스의 존재 여부에 따라 이 뷰를 보여주거나 숨기기 위해 필요함
@property (weak, nonatomic) IBOutlet UIView *importView;


#pragma mark - 최초 친구의 정보를 가져오기 위한 액션 메소드

- (IBAction)importFromAddressBookTapped:(id)sender;
- (IBAction)importFromFacebookTapped:(id)sender;


#pragma mark - Segue 메소드

// -(IBAction)unwindBackToHomeViewController:(UIStoryboardSegue *)segue;



@end