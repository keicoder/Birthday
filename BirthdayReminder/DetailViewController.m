//
//  DetailViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "DBirthday.h"
#import "NotesEditViewController.h"
#import "StyleSheet.h"

@interface DetailViewController ()

@end


@implementation DetailViewController

@synthesize photoView;
@synthesize scrollView;
@synthesize birthdayLabel;
@synthesize remainingDaysLabel;
@synthesize remainingDaysSubTextLabel;
@synthesize notesTitleLabel;
@synthesize notesTextLabel;
@synthesize remainingDaysImageView;
@synthesize facebookButton;
@synthesize callButton;
@synthesize smsButton;
@synthesize emailButton;
@synthesize deleteButton;


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


#pragma mark 스타일 시트 적용

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // 스타일 시트 적용
    
    [StyleSheet styleRoundCorneredView:self.photoView];
    
    // [StyleSheet styleLabel:self.birthdayLabel withType:LabelTypeLarge];
    // [StyleSheet styleLabel:self.notesTitleLabel withType:LabelTypeLarge];
    // [StyleSheet styleLabel:self.notesTextLabel withType:LabelTypeLarge];
    [StyleSheet styleLabel:self.remainingDaysLabel withType:LabelTypeDaysUntilBirthday];
    [StyleSheet styleLabel:self.remainingDaysSubTextLabel withType:LabelTypeDaysUntilBirthdaySubText];
}


#pragma mark 생일 컨텐츠 추가 및 메모 라벨의 컨텐츠 높이를 동적으로 계산

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    // 상세 뷰가 보일 때마다 생일 딕셔너리 속성을 읽고 렌더링
    
    // NSString *name = self.birthday[@"name"];
    // self.title = name; // 네비게이션 바의 타이틀 업데이트
    
    self.title = self.birthday.name;
    
    // UIImage *image = self.birthday[@"image"];
    
    UIImage *image = [UIImage imageWithData:self.birthday.imageData];
    
    if (image == nil) {
        // 딕셔너리애 이미지가 없을 경우 기본으로 생일 케이크 이미지를 사용
        self.photoView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    } else {
        self.photoView.image = image;
    }
    
    int days = self.birthday.remainingDaysUntilNextBirthday;
    
    if (days == 0) {
        // 생일이 오늘이다!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    } else {
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"days_icon1.png"];
    }
    
    self.birthdayLabel.text = self.birthday.birthdayTextToDisplay;
    
    
    // 메모 라벨의 컨텐츠 높이를 동적으로 계산
    
    NSString *notes = (self.birthday.notes && self.birthday.notes.length > 0) ? self.birthday.notes : @"";
    
    CGFloat cY = self.notesTextLabel.frame.origin.y;
    
    // 필요한 높이를 계산
    CGSize notesLabelSize = [notes sizeWithFont:self.notesTextLabel.font constrainedToSize:CGSizeMake(300.f, 300.f) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = self.notesTextLabel.frame;
    frame.size.height = notesLabelSize.height;
    self.notesTextLabel.frame = frame;
    
    self.notesTextLabel.text = notes;
    
    cY += frame.size.height;
    cY += 10.f;
    
    CGFloat buttonGap = 6.f;
    
    cY += buttonGap * 2;
    
    NSMutableArray *buttonsToShow = [NSMutableArray arrayWithObjects:self.facebookButton, self.callButton, self.smsButton, self.emailButton, self.deleteButton, nil];
    
    UIButton *button;
    
    int i;
    
    for (i=0; i<[buttonsToShow count]; i++) {
        button = [buttonsToShow objectAtIndex:i];
        frame = button.frame;
        frame.origin.y = cY;
        button.frame = frame;
        cY += button.frame.size.height + buttonGap;
    }
    
    self.scrollView.contentSize = CGSizeMake(320, cY);
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



#pragma mark - 세그웨이(Segues) 화면 전환 메소드 (ToEditViewFromDetailSegue 또는 ToNotesEditViewSegue)

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    
    // 상세 뷰 컨트롤러의 생일(birthday) 엔티티를 편집 뷰 컨트롤러로 넘겨줌.
    
    if ([identifier isEqualToString:@"ToEditViewFromDetailSegue"]) {
        // 이 생일을 편집
        UINavigationController *navigationController = segue.destinationViewController;
        
        EditViewController *editViewController = (EditViewController *) navigationController.topViewController;
        editViewController.birthday = self.birthday;
        
    } else if ([identifier isEqualToString:@"ToNotesEditViewSegue"]) {
        // 이 메모를 편집
        UINavigationController *navigationController = segue.destinationViewController;
        
        NotesEditViewController *notesEditViewController = (NotesEditViewController *) navigationController.topViewController;
        notesEditViewController.birthday = self.birthday;
    }
}


#pragma mark - 버튼 액션

- (IBAction)facebookButtonTapped:(id)sender
{
    
}

- (IBAction)callButtonTapped:(id)sender
{
    
}

- (IBAction)smsButtonTapped:(id)sender
{
    
}

- (IBAction)emailButtonTapped:(id)sender
{
    
}

- (IBAction)deleteButtonTapped:(id)sender
{
    
}


@end
