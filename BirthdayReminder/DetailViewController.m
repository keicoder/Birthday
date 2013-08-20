//
//  DetailViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"

@interface DetailViewController ()

@end


@implementation DetailViewController


#pragma mark - 스토리보드 지정 초기자

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"initWithCoder");
    }
    return self;
}

    
#pragma mark - 뷰 라이프 사이클

- (void) dealloc
{
    NSLog(@"dealloc");
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    // 상세 뷰가 보일 때마다 생일 딕셔너리 속성을 읽고 렌더링
    
    NSString *name = self.birthday[@"name"];
    self.title = name; // 네비게이션 바의 타이틀 업데이트
    
    UIImage *image = self.birthday[@"image"];
    if (image == nil) {
        self.photoView.image = [UIImage imageNamed:@"icon-birthday-cake.png"]; // 딕셔너리애 이미지가 없을 경우 기본 이미지 지정
    } else {
        self.photoView.image = image;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}
    
    
#pragma mark - 메모리 관리

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - 세그웨이(Segues) 화면 전환 메소드 --> 상세 뷰 컨트롤러의 생일(birthday) 딕셔너리를 편집 뷰 컨트롤러로 넘겨줌.

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"ToEditViewFromDetailSegue"]) {
        // 이 생일을 편집
        UINavigationController *navigationController = segue.destinationViewController;
        
        EditViewController *editViewController = (EditViewController *) navigationController.topViewController;
        editViewController.birthday = self.birthday;
        
    }
}


@end
