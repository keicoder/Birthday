//
//  SettingsViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//


#import "SettingsViewController.h"
#import "임포트

@interface SettingsViewController ()

@end


@implementation SettingsViewController


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 두 개의 정적 설정 테이블 셀에서 오른쪽 값을 동적으로 만듦
    self.tableCellNotificationTime.detailTextLabel.text = [[DSettings sharedInstance] titleForNotificationTime];
    self.tableCellDaysBefore.detailTextLabel.text =  [[DSettings sharedInstance] titleForDaysBefore:[DSettings sharedInstance].daysBefore];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app-background1.png"]];
    self.tableView.backgroundView = backgroundView;
}


#pragma mark - 섹션 헤더 (스타일 시트 이용 해 스타일 적용)

-(UIView *) createSectionHeaderWithLabel:(NSString *)text
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40.f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 15.f, 300.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    [StyleSheet styleLabel:label withType:LabelTypeLarge];
    label.text = text;
    [view addSubview:label];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createSectionHeaderWithLabel:@"Reminders"];
}



- (IBAction)didClickDoneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
