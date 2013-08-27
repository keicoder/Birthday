//
//  ImportViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 26..
//  Copyright (c) 2013년 jun. All rights reserved.
//

// 연락처 임포트 뷰의 데이블 뷰로 연락처 사진 및 데이터를 불러오기 위해 상위 클래스인 ImportViewController를 활용해 내용을 채움
// -> 이렇게 하면 연락처 불러오기 뷰 뿐만 아니라 나중에 페이스북 불러오기 뷰 컨트롤러를 개발할 때도 상위 클래스에서 로직을 이미 구현한 만큼 시간을 절약할 수 있다.



#import "ImportViewController.h"
#import "DBirthdayImport.h"
#import "TableViewCell.h"


@interface ImportViewController ()

@end

@implementation ImportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.birthdays count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    DBirthdayImport *birthdayImport = self.birthdays[indexPath.row];
    
    TableViewCell *tableCell = (TableViewCell *)cell;
    
    tableCell.birthdayImport = birthdayImport;
    
    if (birthdayImport.imageData == nil)
    {
        tableCell.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        tableCell.iconView.image = [UIImage imageWithData:birthdayImport.imageData];
    }
    
    // 테이블 셀 배경 이미지 적용
    UIImage *backgroundImage = (indexPath.row == 0) ? [UIImage imageNamed:@"cell_background.png"] : [UIImage imageNamed:@"cell_background.png"];
    tableCell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    return cell;
}



#pragma mark - 버튼 액션 메소드

- (IBAction)didTapImportButton:(id)sender
{
    
}


- (IBAction)didTapSelectAllButton:(id)sender
{
    
}


- (IBAction)didTapSelectNoneButton:(id)sender
{
    
}



@end
