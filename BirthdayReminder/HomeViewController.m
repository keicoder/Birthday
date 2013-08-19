//
//  HomeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


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



#pragma mark - 테이블 뷰 데이터 소스 메소드 (Table view data source)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}


#pragma mark - 테이블 뷰 델리게이트 메소드 (Table view delegate)

// 테이블 뷰의 셀을 선택했을 때 선택된 행의 하이라이트를 자연스럽게 페이드아웃 됨
// * 테이블 뷰의 개별 행 높이는 tableView.heightForRowAtIndexPath 메소드를 구현해 결정할 수 있음


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// 개별 행 높이

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    } else {
        return 72;
    }
}


@end
