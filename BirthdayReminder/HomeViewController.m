//
//  HomeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "EditViewController.h"

@interface HomeViewController ()

// birthdays.plist에서 로드한 생일 딕셔너리로 이뤄진 배열 생성
// 이 배열 속성을 홈 뷰 컨트롤러.m의 private 인터페이스에 선언
@property (nonatomic, strong) NSMutableArray *birthdays;

@end


@implementation HomeViewController

@synthesize tableView;

#pragma mark - 지정 초기자 오버라이드

// birthdays 인스턴스 생성

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"birthdays" ofType:@"plist"];
        // birthdays.plist 파일은 딕셔너리 객체로 구성된 배열임
        NSArray *nonMutableBirthdays = [NSArray arrayWithContentsOfFile:plistPath];
        // plist 파일에서 수정 불가능한 배열 생성 --> 수정 가능한 배열을 생성해야 함.
        
        self.birthdays = [NSMutableArray array];
        
        NSMutableDictionary *birthday;
        NSDictionary *dictionary;
        NSString *name;
        NSString *pic;
        UIImage *image;
        NSDate *birthdate;
        
        for (int i = 0; i < [nonMutableBirthdays count]; i++) {
            dictionary = [nonMutableBirthdays objectAtIndex:i];
            name = dictionary[@"name"];
            pic = dictionary[@"pic"];
            image = [UIImage imageNamed:pic];
            birthdate = dictionary[@"birthdate"];
            
            birthday = [NSMutableDictionary dictionary];
            birthday [@"name"] = name;
            birthday [@"image"] = image;
            birthday [@"birthdate"] = birthdate;
            // 수정 불가능한 딕셔너리를 모두 순회하며 수정 가능한 딕셔너리를 새로 생성
            
            [self.birthdays addObject:birthday];
            // birthdays 배열은 수정 가능하며 name, birthdate, image 속성을 갖춘 수정 가능 생일 딕셔너리를 포함 
        }
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


- (void)viewWillAppear:(BOOL)animated
{
    // Add/Edit 버튼을 통해 생성/편집한 모델(생일의 배열)을 홈 뷰 컨트롤러가 나타나려는 시점마다 재로드
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}



#pragma mark - 테이블 뷰 데이터 소스 메소드 (Table view data source)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSMutableDictionary *birthday = self.birthdays[indexPath.row];
    
    NSString *name = birthday[@"name"];
    NSDate *birthdate = birthday[@"birthdate"];
    UIImage *image = birthday[@"image"];
        
    cell.textLabel.text = name;
    cell.detailTextLabel.text = birthdate.description;
    cell.imageView.image = image;
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 100;
    // birthdays.plist에서 가져온 데이터의 수
    return [self.birthdays count];
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


#pragma mark - 세그웨이(Segues) 화면 전환 메소드

// 아래 세그웨이 코드는 뷰 컨트롤러가 내비게이션 스택에 추가되기 전에 실행됨.
// 따라서 상세 뷰 컨트롤러에서 viewWillAppear:가 호출되는 시점에 상세 뷰 컨트롤러는 이미 birthday 딕셔너리에 접근할 수 있음.
// --> 그러므로 컨트롤러의 제목과 photoView 이미지 속성을 아무 문제없이 업데이트할 수 있음.

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue!");
    
    // 홈 뷰의 테이블 뷰 셀을 탭할 때 호출되는 세그웨이(Segues)
    
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"ToDetailViewSegue"]) { // 세그웨이 식별자 ToDetailViewSegue
        // 먼저 데이터를 가져옴
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        NSMutableDictionary *birthday = self.birthdays[selectedIndexPath.row];
        
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.birthday = birthday;
    }
    
    else if ([identifier isEqualToString:@"ToAddBirthdaySegue"]) // 홈 뷰의 Add 바 버튼 항목을 탭할 때 호출되는 세그웨이(Segues)
    {
        // 생일 배열에 새로운 생일 딕셔너리를 추가
        /* 생일 편집 뷰 컨트롤러는 모달로 보여주는 내비게이션 컨트롤러의 자식이므로 세그웨이의 destinationViewController 속성 값은 내비게이션 컨트롤러를 가리킨다.
           이 내비게이션 컨트롤러에 대한 참조를 통해 생일 편집 뷰 컨트롤러에 대한 참조도 가져올 수 있다. 
           생일 편집 뷰 컨트롤러에 대한 참조를 가져온 후에는 생일 편집 뷰 컨트롤러의 birthday 속성값에 새로 생성한 birthday 딕셔너리를 설정한다. */
        
        NSMutableDictionary *birthday = [NSMutableDictionary dictionary];
        
        birthday[@"name"] = @"My Friend";
        birthday[@"birthdate"] = [NSDate date];
        [self.birthdays addObject:birthday];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        EditViewController *editViewController = (EditViewController *) navigationController.topViewController;
        editViewController.birthday = birthday;
    }
    
}


@end
