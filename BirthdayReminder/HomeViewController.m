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
#import "DBirthday.h"
#import "DModel.h"
#import "TableViewCell.h"
#import "StyleSheet.h"


@interface HomeViewController ()

// birthdays.plist에서 로드한 생일 딕셔너리로 이뤄진 배열 생성
// 이 배열 속성을 홈 뷰 컨트롤러.m의 private 인터페이스에 선언
// @property (nonatomic, strong) NSMutableArray *birthdays;

// NSFetchedResultsController를 private 속성으로 선언
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// 코어 데이터 저장소에 생일이 없을 경우에만 importView(컨테이너 뷰)를 보여줌, private 속성
@property (nonatomic) BOOL hasFriends;


@end


@implementation HomeViewController

@synthesize tableView;

@synthesize importLabel;
@synthesize addressBookButton;
@synthesize facebookButton;
@synthesize importView;



#pragma mark - 지정 초기자 오버라이드

// birthdays 인스턴스 생성

// 코어 데이터 모델로 테이블 뷰를 채우기 위해 수정
// DModel.m - (NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids 메소드(중복 엔티티 검사) 활용
// getExistingBirthdaysWithUIDs: 메소드는 생일 엔티티의 고유 id를 키로 사용해 기존 생일 엔티티의 수정 가능 딕셔너리를 반환한다.
// 이 수정 가능 딕셔너리는 생일 딕셔너리를 불러올 때마다 매번 참조할 수 있다.


// 코어 데이터 활용 - initWithCoder 메소드 삭제
/*
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"birthdays" ofType:@"plist"];
        NSArray *nonMutableBirthdays = [NSArray arrayWithContentsOfFile:plistPath];
        
        DBirthday *birthday;
        NSDictionary *dictionary;
        NSString *name;
        NSString *pic;
        NSString *pathForPic;
        NSData *imageData;
        NSDate *birthdate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        
        NSString *uid;
        NSMutableArray *uids = [NSMutableArray array];
        for (int i=0; i<[nonMutableBirthdays count]; i++) {
            dictionary = [nonMutableBirthdays objectAtIndex:i];
            uid = dictionary[@"name"];
            [uids addObject:uid];
        }
        
        // DModel.m에 추가한 getExistingBirthdaysWithUIDs: 메소드(중복 엔티티 검사) 활용
        NSMutableDictionary *existingEntities = [[DModel sharedInstance] getExistingBirthdaysWithUIDs:uids];
        
        NSManagedObjectContext *context = [DModel sharedInstance].managedObjectContext;
        
        for (int i=0; i<[nonMutableBirthdays count]; i++) {
            dictionary = nonMutableBirthdays[i];
            
            uid = dictionary[@"name"];
            
            birthday = existingEntities[uid];
            
            if (birthday) {
                // 생일이 이미 존재 - 새 엔티티를 생성하지 않고 어트리뷰트만 업데이트
            } else {
                // 생일이 존재하지 않음 - 엔티티를 생성
                birthday = [NSEntityDescription insertNewObjectForEntityForName:@"DBirthday" inManagedObjectContext:context];
                existingEntities[uid] = birthday;
                birthday.uid = uid;
            }
            
            // birthday = [NSEntityDescription insertNewObjectForEntityForName:@"DBirthday" inManagedObjectContext:context];
            
            name = dictionary[@"name"];
            pic = dictionary[@"pic"];
            birthdate = dictionary[@"birthdate"];
            pathForPic = [[NSBundle mainBundle] pathForResource:pic ofType:nil];
            imageData = [NSData dataWithContentsOfFile:pathForPic];
            birthday.name = name;
            birthday.imageData = imageData;
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthdate];
            
            // 새로운 리터럴 구문. 다음과 동일
            // birthday.birthDay = [NSNumber numberWithInt:components.day];
            birthday.birthDay = @(components.day);
            birthday.birthMonth = @(components.month);
            birthday.birthYear = @(components.year);
            [birthday updateNextBirthdayAndAge];
        }
        [[DModel sharedInstance] saveChanges];
    }
    return self;
}
*/

/*
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
*/

#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 컨테이너 뷰인 importView에 클리어 컬러 적용
    // self.importView.backgroundColor = [UIColor clearColor];
    [importView setBackgroundColor:[UIColor clearColor]];
    
    
    // Import Birthdays from ... 라벨에 스타일 시트 적용
    [StyleSheet styleLabel:self.importLabel withType:LabelTypeJun];
    
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
    
    // 코어 데이터 저장소에 생일이 없을 경우에만 importView(컨테이너 뷰)를 보여줌, BOOL 값 확인
    self.hasFriends = [self.fetchedResultsController.fetchedObjects count] > 0;
}


#pragma mark - 코어 데이터 저장소에 생일이 없을 경우에만 importView(컨테이너 뷰)를 보여줌, private 속성, 세터 메소드 오버라이드

-(void) setHasFriends:(BOOL)hasFriends
{
    _hasFriends = hasFriends;
    self.importView.hidden = _hasFriends;
    self.tableView.hidden = !_hasFriends;
    
    if (self.navigationController.topViewController == self) {
        [self.navigationController setToolbarHidden:!_hasFriends animated:NO];
    }
}


#pragma mark - 최초 친구의 정보를 가져오기 위한 버튼 액션 메소드

- (IBAction)importFromAddressBookTapped:(id)sender
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportAddressBook"];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


- (IBAction)importFromFacebookTapped:(id)sender
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportFacebook"];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - 테이블 뷰 데이터 소스 메소드 (Table view data source)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // NSMutableDictionary *birthday = self.birthdays[indexPath.row];
    
    // DBirthday 엔티티
    DBirthday *birthday = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // NSString *name = birthday[@"name"];
    // NSDate *birthdate = birthday[@"birthdate"];
    // UIImage *image = birthday[@"image"];
        
    // cell.textLabel.text = name;
    // cell.detailTextLabel.text = birthdate.description;
    // cell.imageView.image = image;
    
    // cell.textLabel.text = birthday.name;
    // cell.detailTextLabel.text = birthday.birthdayTextToDisplay;
    // cell.imageView.image = [UIImage imageWithData:birthday.imageData];
    
    // 커스텀 테이블 셀
    
    TableViewCell *tableCell = (TableViewCell *)cell;
    tableCell.birthday = birthday;
    if (birthday.imageData == nil)
    {
        tableCell.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        tableCell.iconView.image = [UIImage imageWithData:birthday.imageData];
    }
    
    // 테이블 셀 배경 이미지 적용
    
    UIImage *backgroundImage = (indexPath.row == 0) ? [UIImage imageNamed:@"cell_background.png"] : [UIImage imageNamed:@"cell_background.png"];
    tableCell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 100;
    // birthdays.plist에서 가져온 데이터의 수
    // return [self.birthdays count];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
        return 72;
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
    // NSLog(@"prepareForSegue!");
    
    // 홈 뷰의 테이블 뷰 셀을 탭할 때 호출되는 세그웨이(Segues)
    
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"ToDetailViewSegue"]) {
        
        // 세그웨이 식별자 ToDetailViewSegue
        // 먼저 데이터를 가져옴
        
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        // NSMutableDictionary *birthday = self.birthdays[selectedIndexPath.row];
        
        // DBirthday에서 가져옴
        DBirthday *birthday = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.birthday = birthday;
    }
    
    else if ([identifier isEqualToString:@"ToAddBirthdaySegue"]) // 홈 뷰의 Add 바 버튼 항목을 탭할 때 호출되는 세그웨이(Segues)
    {
        // 생일 배열에 새로운 생일 딕셔너리를 추가
        /* 생일 편집 뷰 컨트롤러는 모달로 보여주는 내비게이션 컨트롤러의 자식이므로 세그웨이의 destinationViewController 속성 값은 내비게이션 컨트롤러를 가리킨다.
           이 내비게이션 컨트롤러에 대한 참조를 통해 생일 편집 뷰 컨트롤러에 대한 참조도 가져올 수 있다. 
           생일 편집 뷰 컨트롤러에 대한 참조를 가져온 후에는 생일 편집 뷰 컨트롤러의 birthday 속성값에 새로 생성한 birthday 딕셔너리를 설정한다. */
        
        // NSMutableDictionary *birthday = [NSMutableDictionary dictionary];
        
        // birthday[@"name"] = @"My Friend";
        // birthday[@"birthdate"] = [NSDate date];
        // [self.birthdays addObject:birthday];
        
        // DBirthday에서 가져옴
        
        // 사용자가 Add 버튼을 탭하면 코어 데이터 관리 객체 컨텍스트 내에서 새 DBirthday 엔티티를 생성하되 컨텍스트를 저장하지는 않는다.
        // 이렇게 해야 추가 작업을 취소할 경우 롤백해 새 생일 엔티티를 제거할 수 있다.
        
        NSManagedObjectContext *context = [DModel sharedInstance].managedObjectContext;
        DBirthday *birthday = [NSEntityDescription insertNewObjectForEntityForName:@"DBirthday" inManagedObjectContext:context];
        
        [birthday updateWithDefaults];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        EditViewController *editViewController = (EditViewController *) navigationController.topViewController;
        editViewController.birthday = birthday;
    }
    
}


#pragma mark - fetchedResultsController의 게터 접근자 메소드 오버라이드 (Fetched Results Controller to keep track of the Core Data DBirthday managed objects)

// NSFetchedResultsController 클래스 : 코어 데이터 엔티티에 저장된 결과셋을 조회, 변경사항을 델리게이트에 알려줌
// --> 이를 통해 객체의 새로운 추가, 수정, 삭제같은 변경사항을 알 수 있음
// --> 여기서는 코어 데이터 저장소 내의 Birthday 엔티티 목록을 추적하고 이를 홈 뷰 컨트롤러에 보여줄 때 이 클래스 사용함

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // 싱글톤 모델을 통해 하나뿐인 관리 객체 컨텍스트에 접근
        NSManagedObjectContext *context = [DModel sharedInstance].managedObjectContext;
        
        // 가져오기 요청에는 엔티티 설명이 필요하다. 여기서는 DBirthday 관리 객체만 필요하다.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBirthday" inManagedObjectContext:context];
        fetchRequest.entity = entity;
        
        // 지금은 일단 nextBirthday 순으로 DBirthday 객체를 정렬한다.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nextBirthday" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        fetchRequest.sortDescriptors = sortDescriptors;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
	
	return _fetchedResultsController;
}


#pragma mark - NSFetchedResultsControllerDelegate (변경 사항 추적 - controllerDidChangeContent:)

// 델리게이트가 변경 사항을 추적하려면 최소 한 개의 변경 추적 델리게이트 메소드를 구현해야 한다. 구현체로는 controllerDidChangeContent:의 빈 구현체를 제공하는 것만으로 충분하다 - iOS 개발자 라이브러리

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // 가져온 결과가 반영됨 --> 여기서는 테이블 뷰의 cellForRowAtIndexPath:, numberOfRowsInSection: 메소드에 반영
}



@end
