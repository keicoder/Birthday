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
#import <AddressBook/AddressBook.h> // 전화, SMS, 이메일 등 데이터 불러오기
#import "DModel.h" // Delete 버튼을 눌렀을 때 코어 데이터 엔티티 삭제

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
    
    
    // 해당 사항이 없을 경우 버튼을 보여주지 않음
    
    NSMutableArray *buttonsToHide = [NSMutableArray array];
    
    if (self.birthday.facebookID == nil) {
        [buttonsToShow removeObject:self.facebookButton];
        [buttonsToHide addObject:self.facebookButton];
    }
    
    if ([self callLink] == nil) {
        [buttonsToShow removeObject:self.callButton];
        [buttonsToHide addObject:self.callButton];
    }
    
    if ([self smsLink] == nil) {
        [buttonsToShow removeObject:self.smsButton];
        [buttonsToHide addObject:self.smsButton];
    }
    
    if ([self emailLink] == nil) {
        [buttonsToShow removeObject:self.emailButton];
        [buttonsToHide addObject:self.emailButton];
    }
    
    UIButton *button;
    
    for (button in buttonsToHide) {
        button.hidden = YES;
    }
    
    int i;
    
    for (i=0;i<[buttonsToShow count];i++) {
        button = [buttonsToShow objectAtIndex:i];
        button.hidden = NO;
        frame = button.frame;
        frame.origin.y = cY;
        button.frame = frame;
        cY += button.frame.size.height + buttonGap;
    }
    
    self.scrollView.contentSize = CGSizeMake(320, cY);
    
    /*
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
    */
     
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



#pragma mark - Address Book contact helper methods

// 현재 연락처 레코드에 대한 참조를 가져와 kABPersonPhoneProperty (전화번호) 속성의 존재 여부 검사
// ** 애플에서 제공하는 URL Scheme을 이용하면 다른 앱에서 우리 앱을 연결할 수 있게 정의할 수 있다 (info plist를 통해)

-(NSString *)telephoneNumber
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef record =  ABAddressBookGetPersonWithRecordID (addressBook,(ABRecordID)[self.birthday.addressBookID intValue]);
    
    ABMultiValueRef multi = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    NSString *telephone = nil;
    
    if (ABMultiValueGetCount(multi) > 0) {
        telephone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        telephone = [telephone stringByReplacingOccurrencesOfString:@" " withString:@""]; // 번호에서 공백을 모두 제거
    }
    CFRelease(multi);
    CFRelease(addressBook);
    
    return telephone;
}


-(NSString *)callLink

// canOpenURL: 메소드를 사용해 생성하는 시스템 링크가 기기와 호환하는지 검사 -> 연결하려는 앱을 사용자가 설치했는지 확인할 수 있다.

{
    if (!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) return nil;
    NSString *telephoneNumber = [self telephoneNumber];
    if (!telephoneNumber) return nil;
    
    NSString *callLink = [NSString stringWithFormat:@"tel:%@",telephoneNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callLink]]) return callLink;
    
    return nil;
}


-(NSString *)smsLink

// canOpenURL: 메소드를 사용해 생성하는 시스템 링크가 기기와 호환하는지 검사 -> 연결하려는 앱을 사용자가 설치했는지 확인할 수 있다.

{
    if (!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) return nil;
    NSString *telephoneNumber = [self telephoneNumber];
    if (!telephoneNumber) return nil;
    
    NSString *smsLink = [NSString stringWithFormat:@"sms:%@",telephoneNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:smsLink]]) return smsLink;
    
    return nil;
}


-(NSString *)emailLink

// telephoneNumber 메소드와 거의 유사
// 현재 연락처 레코드에 대한 참조를 가져와 kABPersonEmailProperty (email) 속성의 존재 여부 검사

{
    if (!self.birthday.addressBookID || [self.birthday.addressBookID intValue]==0) return nil;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef record =  ABAddressBookGetPersonWithRecordID (addressBook,(ABRecordID)[self.birthday.addressBookID intValue]);
    
    ABMultiValueRef multi = ABRecordCopyValue(record, kABPersonEmailProperty);
    
    NSString *email = nil;
    if (ABMultiValueGetCount(multi) > 0) {//check if the contact has 1 or more emails assigned
        email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
    }
    CFRelease(multi);
    CFRelease(addressBook);
    
    if (email) {
        NSString *emailLink = [NSString stringWithFormat:@"mailto:%@",email];
        
        // 이메일의 제목은 Happy Birthday로 미리 채울 수 있다.
        // we can pre-populate the email subject with the words Happy Birthday
        emailLink = [emailLink stringByAppendingString:@"?subject=Happy%20Birthday"];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:emailLink]]) return emailLink;
    }
    
    
    return nil;
}


#pragma mark - 구현

- (IBAction)facebookButtonTapped:(id)sender
{
    
}

- (IBAction)callButtonTapped:(id)sender
{
    NSString *link = [self callLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)smsButtonTapped:(id)sender
{
    NSString *link = [self smsLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)emailButtonTapped:(id)sender
{
    NSString *link = [self emailLink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)deleteButtonTapped:(id)sender
{
    // 삭제하기전 사용자에게 확인 -> 액션 시트 활용
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:[NSString stringWithFormat:@"Delete %@",self.birthday.name]
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}



#pragma mark - 액션 시트 델리게이트 메소드 (UIActionSheetDelegate)

// 엔티티가 다른 엔티티와 관계가 없을 때는 코어 데이터 엔티티를 쉽게 제거할 수 있다.

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 사용자가 취소 버튼을 눌러 삭제 명령을 취소했는지 확인
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    // 코어 데이터 관리 객체 컨텍스트에 대한 참조를 가져옴
    NSManagedObjectContext *context = [DModel sharedInstance].managedObjectContext;
    
    // 관리 객체 컨텍스트를 통해 생일 엔티티를 삭제함
    [context deleteObject:self.birthday];
    
    // 삭제 변경 사항을 코어 데이터 저장소에 저장
    [[DModel sharedInstance] saveChanges];
    
    // 이 뷰 컨트롤러를 스택에서 꺼내고 홈 화면으로 돌아감
    [self.navigationController popViewControllerAnimated:YES];
}



@end
