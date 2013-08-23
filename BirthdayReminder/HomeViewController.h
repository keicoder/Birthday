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
// NSFetchedResultsController 클래스 : 코어 데이터 엔티티에 저장된 결과셋을 조회, 변경사항을 델리게이트에 알려줌
// --> 이를 통해 객체의 새로운 추가, 수정, 삭제같은 변경사항을 알 수 있음
// --> 여기서는 코어 데이터 저장소 내의 Birthday 엔티티 목록을 추적하고 이를 홈 뷰 컨트롤러에 보여줄 때 이 클래스 사용함
// 홈 뷰 컨트롤러가 NSFetchedResultsControllerDelegate 프로토콜을 구현한다고 선언

@interface HomeViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end