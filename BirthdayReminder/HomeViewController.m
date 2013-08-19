//
//  HomeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "HomeViewController.h"

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
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"birthdays" ofType:@"plist"];
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



#pragma mark - 테이블 뷰 데이터 소스 메소드 (Table view data source)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 100;
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


@end
