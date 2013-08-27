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
#import "DModel.h"



@interface ImportViewController ()

// 연락처 뷰에서 사용자가 선택한 불러올 연락처의 행을 추적하기 위한 뮤터블 딕셔너리
// 선택 행의 개수에 따라(0이면) 불러오기 버튼을 비활성화 또는 활성화 한다.
// selectedIndexPathToBirthday 속성의 게터 메소드를 오버라이드해 이 메소드를 처음 접근할 때 자동으로 딕셔너리가 초기화되게끔 지연된 초기화 기법을 활용함

@property (nonatomic, strong) NSMutableDictionary *selectedIndexPathToBirthday;


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
    
    // 뷰가 처음 보일 때 불러오기 버튼 비활성화
    [self updateImportButton];
}



#pragma mark - 연락처 뷰에서 사용자가 선택한 불러올 연락처의 행을 추적하기 위한 뮤터블 딕셔너리(selectedIndexPathToBirthday)의 게터 메소드 오버라이드
// selectedIndexPathToBirthday 속성의 게터 메소드를 오버라이드해 이 메소드를 처음 접근할 때 자동으로 딕셔너리가 초기화되게끔 지연된 초기화 기법을 활용함

-(NSMutableDictionary *) selectedIndexPathToBirthday
{
    if (_selectedIndexPathToBirthday == nil) {
        _selectedIndexPathToBirthday = [NSMutableDictionary dictionary];
    }
    return _selectedIndexPathToBirthday;
}



#pragma mark - 선택된 행의 개수에 따라 불러오기 버튼을 활성화/비활성화

//Enables/Disables the import button if there are zero rows selected

- (void) updateImportButton
{
    self.importButton.enabled = [self.selectedIndexPathToBirthday count] > 0;
}



#pragma mark - 행의 선택 여부를 검사하는 헬퍼 메소드

//Helper method to check whether a row is selected or not

-(BOOL) isSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    return self.selectedIndexPathToBirthday[indexPath] ? YES : NO;
}



#pragma mark - 선택 액세서리 뷰를 동적으로 테이블 셀에 구현

//Refreshes the selection tick of a table cell
- (void)updateAccessoryForTableCell:(UITableViewCell *)tableCell atIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView;
    if ([self isSelectedAtIndexPath:indexPath]) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-selected.png"]];
    }
    else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-not-selected.png"]];
    }
    tableCell.accessoryView = imageView;
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
    
    // 커스텀 테이블 셀
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
    
    // accessoryView 속성에 선택 이미지 보여줌
    // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-import-not-selected.png"]];
    // tableCell.accessoryView = imageView;
    [self updateAccessoryForTableCell:cell atIndexPath:indexPath];
    
    return cell;
}



#pragma mark - 테이블 뷰 델리게이트 메소드 (UITableViewDelegate) : 행을 탭할 때 선택 여부 토글

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL isSelected = [self isSelectedAtIndexPath:indexPath];
    
    DBirthdayImport *birthdayImport = self.birthdays[indexPath.row];
    
    if (isSelected) {
        // 이미 선택됐으면 선택 해제한다.
        [self.selectedIndexPathToBirthday removeObjectForKey:indexPath];
    }
    else {
        // 선택되지 않앗으므로 선택한다.
        [self.selectedIndexPathToBirthday setObject:birthdayImport forKey:indexPath];
    }
    
    // 액세서리 뷰 이미지를 업데이트
    [self updateAccessoryForTableCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
    
    // 불러오기 버튼을 활성/비활성화
    [self updateImportButton];
}


#pragma mark - 버튼 액션 메소드

// 연락처 불러오기 뷰에서 다중 선택한 DBirthdayImport 인스턴스를 코어 데이터 엔티티로 불러오기
// DModel의 importBirthdays: 메소드 호출

- (IBAction)didTapImportButton:(id)sender
{
    NSArray *birthdaysToImport = [self.selectedIndexPathToBirthday allValues];
    [[DModel sharedInstance] importBirthdays:birthdaysToImport];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark SelectAll 버튼 액션 메소드

- (IBAction)didTapSelectAllButton:(id)sender
{
    DBirthdayImport *birthdayImport;
    
    int maxLoop = [self.birthdays count];
    
    NSIndexPath *indexPath;
    
    for (int i=0;i<maxLoop;i++) {
        
        // 생일 불러오기 객체를 모두 순회
        birthdayImport = self.birthdays[i];
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        // 선택 항목에 대한 참조를 생성
        self.selectedIndexPathToBirthday[indexPath] = birthdayImport;
    }
    
    [self.tableView reloadData];
    [self updateImportButton];
}


#pragma mark 구현

- (IBAction)didTapSelectNoneButton:(id)sender {
    [self.selectedIndexPathToBirthday removeAllObjects];
    [self.tableView reloadData];
    [self updateImportButton];
}




@end
