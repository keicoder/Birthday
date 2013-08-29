//
//  DModel.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 22..
//  Copyright (c) 2013년 jun. All rights reserved.
//


/*
 애플의 코어 데이터 코드 예제에서는 애플리케이션 델리게이트 클래스에서 초기화 코드를 사용함
 
 **하지만 보통은 싱글톤 모델 클래스를 하나 만들고 싱글톤 인스턴스에서 코어 데이터 모델을 초기화하는 게 일반적임
 이렇게하면 프로젝트 내 모든 클래스에서 싱글톤 모델 인스턴스를 통해 관리 객체 컨텍스트에 직접 접근할 수 있기 때문임
 
 싱글톤 클래스를 설정하기 위해 여기서는 sharedInstance라는 클래스 메소드를 통해서만 모델에 접근할 수 있게 했음
 DModel의 sharedInstance 메소드는 DModel의 싱클톤 인스턴스를 생성하거나 이미 존재할 경우 이를 그냥 반환함
 */

#import "DModel.h"
#import "DBirthday.h"
#import <AddressBook/AddressBook.h>
#import "DBirthdayImport.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


typedef enum : int
{
    FacebookActionGetFriendsBirthdays = 1,
    FacebookActionPostToWall
}FacebookAction;



@interface DModel()

@property (strong) ACAccount *facebookAccount;  // 인증된 페이스북 계정에 대한 참조
@property FacebookAction currentFacebookAction; // 현재 진행 중인 페이스북 그래프 API 액션을 추적하기 위한 속성

@property (nonatomic,strong) NSString *postToFacebookMessage;
@property (nonatomic,strong) NSString *postToFacebookID;

@end


@implementation DModel

static DModel *_sharedInstance = nil;


#pragma mark - 코어 데이터 모델의 초기화 메소드

// 클래스 메소드
// sharedInstance 메소드는 자기 자신의 인스턴스를 생성함
// 오브젝티브 C에서 싱글톤을 구현할 때는 이런 기법을 자주 사용함
// 애플리케이션에서 이 모델에 접근할 때는 그냥 [DModel sharedInstance]를 참조하면 됨

+ (DModel *)sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance = [[DModel alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - 코어 데이터 모델의 속성 합성
// ** readonly 속성에서는 자동 합성 코드를 만들어 주지 않음

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - 코어 데이터 스택 (Core Data stack)

// managed object context 반환
// context가 존재하지 않으면 context 생성하고 애플리케이션의 영속성 저장소 조율기에 바운드(bound to the persistent store coordinator) 시킴

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// 애플리케이션의 관리 객체 모델을 반환함
// 모델이 이미 존재하지 않으면 애플리케이션의 모델로부터 관리 객체 모델을 생성함

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BirthdayReminder" withExtension:@"momd"];  // 해당 앱의 modelURL로 수정
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// 애플리케이션의 영속성 저장소 조율기를 반환함
// 조율기가 이미 존재하지 않으면 조율기를 생성하고 애플리케이션의 저장소를 조율기에 추가함

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BirthdayReminder.sqlite"]; // 해당 앱의 storeURL로 수정
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - 애플리케이션의 다큐먼트 디렉토리

// 애플리케이션의 다큐먼트 디렉토리 반환

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - 코어 데이터 저장소 채우기 - public 인스턴스 메소드이므로 DModel.h에 선언

- (void) saveChanges
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]) {
        if (![self.managedObjectContext save:&error]) {
            // save failed
            NSLog(@"Save failed : %@", [error localizedDescription]);
        } else {
            NSLog(@"Save succeeded");
        }
    }
}


#pragma mark - 코어 데이터 저장 취소 기능 - public 인스턴스 메소드이므로 DModel.h에 선언

- (void) cancelChanges
{
    // 관리 객체 컨텍스트의 rollback 메소드를 호출하면 마지막 저장 시점 이후 코어 데이터 모델의 모든 변경 사항이 제거된다.
    [self.managedObjectContext rollback];
}



#pragma mark - 중복 엔티티 검사

// getExistingBirthdaysWithUIDs: 메소드는 생일 엔티티의 고유 id를 키로 사용해 기존 생일 엔티티의 수정 가능 딕셔너리를 반환한다.
// 이 수정 가능 딕셔너리는 생일 딕셔너리를 불러올 때마다 매번 참조할 수 있다.

- (NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    // NSPredicate는 결과셋을 필터링하는 데 사용한다.
    // 여기서는 uid 배열 내 하나 이상의 항목과 일치하는 결과셋을 반환하게끔 지정한다.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid IN %@", uids];
    fetchRequest.predicate = predicate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBirthday" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    
    NSInteger resultCount = [fetchedObjects count];
    
    if (resultCount == 0) {
        return [NSMutableDictionary dictionary]; // 코어 데이터 저장소에 아무것도 없음
    }
    
    DBirthday *birthday;
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    int i;
    
    for (i = 0; i < resultCount; i++) {
        birthday = fetchedObjects[i];
        tmpDict[birthday.uid] = birthday;
    }
    
    return tmpDict;
}



#pragma mark - 데이터 조회 메소드 (생일이 있는 연락처만 필터링하는 데이터 모델)
// 연락처 가져오기 뷰 컨트롤러는 모델의 이 메소드 호출, 이 메소드는 다시 연락처 접근 가능 여부를 검사한다.
// 주소록 프레임워크는 C로 작성됨. 따라서 ARC 기능이 없다. 개발자 스스로 메모리 누수를 막아야 한다.

- (void) fetchAddressBookBirthdays
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        
        // 사용자가 승인하지 않았거나 거부한 경우
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"Access to the Address Book has been granted");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 완료 핸들러는 백그라운드 스레드에서 실행될 수 있으며 이 호출은 메인 스레드에서 UI를 업데이트한다.
                        // completion handler can occur in a background thread and this call will update the UI on the main thread
                        [self extractBirthdaysFromAddressBook:ABAddressBookCreateWithOptions(NULL, NULL)];
                        });
                }
                else {
                    NSLog(@"Access to the Address Book has been denied");
                }
            });
            break;
        }
        
        case kABAuthorizationStatusAuthorized:
        {
            NSLog(@"User has already granted access to the Address Book");
            // 이미 승인한 경우
            [self extractBirthdaysFromAddressBook:addressBook];
            break;
        }
        
        // 사용자가 시스템에 대한 접근을 제한한 경우 (부모 통제 기능 등)
        case kABAuthorizationStatusRestricted:
        {
            NSLog(@"User has restricted access to Address Book possibly due to parental controls");
            break;
        }
        
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"User has denied access to the Address Book");
            break;
        }
    }
    
    CFRelease(addressBook);
}



#pragma mark - 연락처에서 생일을 가져옴 (사용자가 승인한 경우 fetchAddressBookBirthdays: 호출 이후 바로 호출 됨)
// 주소록 프레임워크는 코어 파운데이션에 포함되며 Copy나 Create가 들어 있는 C함수를 사용할 때는 항상 작업을 마친 객체 참조를 릴리즈해야 한다.



-(void) extractBirthdaysFromAddressBook:(ABAddressBookRef)addressBook
{
    NSLog(@"extractBirthdaysFromAddressBook");
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    CFIndex peopleCount = ABAddressBookGetPersonCount(addressBook);
    
    DBirthdayImport *birthday;
    
    // 현재는 선언만 해둠. 이 배열은 나중에 채운다.
    // this is just a placeholder for now - we'll get the array populated later in the chapter
    NSMutableArray *birthdays = [NSMutableArray array];
    
    for (int i = 0; i < peopleCount; i++)
    {
        ABRecordRef addressBookRecord = CFArrayGetValueAtIndex(people, i);
        // kABPersonBirthdayProperty 속성은 연락처에 지정한 생일을 나타냄
        // 이 값을 이용 생일이 지정된 연락처만 추출
        CFDateRef birthdate  = ABRecordCopyValue(addressBookRecord, kABPersonBirthdayProperty);
        if (birthdate == nil) continue;
        CFStringRef firstName = ABRecordCopyValue(addressBookRecord, kABPersonFirstNameProperty);
        if (firstName == nil) {
            CFRelease(birthdate);
            continue;
        }
        // NSLog(@"Found contact with birthday: %@, %@",firstName,birthdate);
        
        birthday = [[DBirthdayImport alloc] initWithAddressBookRecord:addressBookRecord];
        [birthdays addObject:birthday];
        
        
        CFRelease(firstName);
        CFRelease(birthdate);
    }
    
    CFRelease(people);
    
    // 생일을 이름 알파벳순으로 정렬
    // order the birthdays alphabetically by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [birthdays sortUsingDescriptors:sortDescriptors];
    
    
    // 생일 객체 배열이 들어 있는 알림을 내보냄(전달)
    //dispatch a notification with an array of birthday objects
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:birthdays,@"birthdays", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddressBookBirthdaysDidUpdate object:self userInfo:userInfo];
}



#pragma mark - 연락처 불러오기 뷰에서 다중 선택한 DBirthdayImport 인스턴스를 코어 데이터 엔티티로 불러오기

// 임의의 생일 id 목록을 지정해 id가 일치하는 생일을 가져오는 메소드와 동일한 로직
// 로직
// 1. 불러올 생일을 모두 순회하며 고유 id를 모은다.
// 2. 고유 id 배열을 getExistingBirthdaysWithUIDs:로 넘겨줌으로서 id가 일치하는 기존 생일 엔티티로 이뤄진 수정 가능 딕셔너리를 가져온다.
// 3. 불러올 생일을 다시 모두 순회하며 코어 데이터 생일 엔티티를 생성하거나 저장된 코어 데이터 생일 엔티티를 업데이트 한다.
// 4. 변경 사항을 저장한다.

-(void) importBirthdays:(NSArray *)birthdaysToImport
{
    int i;
    int max = [birthdaysToImport count];
    
    DBirthday *importBirthday;
    DBirthday *birthday;
    
    NSString *uid;
    NSMutableArray *newUIDs = [NSMutableArray array];
    
    for (i=0;i<max;i++)
    {
        importBirthday = birthdaysToImport[i];
        uid = importBirthday.uid;
        [newUIDs addObject:uid];
    }
    
    // DModel의 유틸리티 메소드를 사용해 불러올 생일 배열과 ID가 일치하는 기존 생일을 조회한다.
    NSMutableDictionary *existingBirthdays = [self getExistingBirthdaysWithUIDs:newUIDs];
    
    NSManagedObjectContext *context = [DModel sharedInstance].managedObjectContext;
    
    for (i=0;i<max;i++)
    {
        importBirthday = birthdaysToImport[i];
        uid = importBirthday.uid;
        
        birthday = existingBirthdays[uid];
        if (birthday) {
            // 이 udid를 갖고 있는 생일이 코어 데이터에 이미 존재하므로 중복 데이터를 생성하지 않는다.
        }
        else {
            birthday = [NSEntityDescription insertNewObjectForEntityForName:@"DBirthday" inManagedObjectContext:context];
            birthday.uid = uid;
            existingBirthdays[uid] = birthday;
        }
        
        // 새로운 생일 엔티티나 기존에 저장한 생일 엔티티를 업데이트한다.
        birthday.name = importBirthday.name;
        birthday.uid = importBirthday.uid;
        birthday.picURL = importBirthday.picURL;
        birthday.imageData = importBirthday.imageData;
        birthday.addressBookID = importBirthday.addressBookID;
        birthday.facebookID = importBirthday.facebookID;
        
        birthday.birthDay = importBirthday.birthDay;
        birthday.birthMonth = importBirthday.birthMonth;
        birthday.birthYear = importBirthday.birthYear;
        
        [birthday updateNextBirthdayAndAge];
    }
    
    // 새로 추가한 내용이나 변경 사항을 코어 데이터 저장소에 저장한다.
    [self saveChanges];
    
}



#pragma mark - 페이스북 불러오기



-(void) fetchFacebookBirthdays
{
    NSLog(@"fetchFacebookBirthdays");
    if (self.facebookAccount == nil) {
        self.currentFacebookAction = FacebookActionGetFriendsBirthdays;
        [self authenticateWithFacebook];
        return;
    }
    // 여기까지 오면 페이스북 계정이 이미 인증된 상태이다.
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    // 애플 소셜 프레임워크의 SLRequest 클래스를 활용해 페이스북 그래프 API의 me/friends 경로를 호출하면서 친구 딕셔너리 배열 중 name, id, birthday 필드만을 요청한다.
    // 페이스북 전체 API는 //developers.facebook.com/docs/reference/api에서 참고할 수 있다.
    NSDictionary *params = @{ @"fields" : @"name,id,birthday"};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:params];
    
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting my Facebook friend birthdays: %@",error);
        }
        else
        {
            // 페이스의 me/friends 그래프 API는 루트 딕셔너리를 반환한다.
            // Facebook's me/friends Graph API returns a root dictionary
            NSDictionary *resultD = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            NSLog(@"Facebook returned friends: %@",resultD);
            
            // 'data' 키를 사용하면 페이스북 친구 딕셔너리의 배열이 반환된다.
            // with a 'data' key - an array of Facebook friend dictionaries
            NSArray *birthdayDictionaries = resultD[@"data"];
            
            int birthdayCount = [birthdayDictionaries count];
            NSDictionary *facebookDictionary;
            
            NSMutableArray *birthdays = [NSMutableArray array];
            DBirthdayImport *birthday;
            NSString *birthDateS;
            
            for (int i = 0; i < birthdayCount; i++)
            {
                facebookDictionary = birthdayDictionaries[i];
                birthDateS = facebookDictionary[@"birthday"];
                if (!birthDateS) continue;
                
                // DBirthdayImport의 인스턴스를 생성
                // create an instance of DBirthdayImport
                NSLog(@"Found a Facebook Birthday: %@",facebookDictionary);
                
                // 할 일 - DBirthdayImport 인스턴스를 생성 (DBirthdayImport 클래스에서 initWithFacebookDictionary: 메소드 선언/구현)
                birthday = [[DBirthdayImport alloc] initWithFacebookDictionary:facebookDictionary];
                [birthdays addObject: birthday];
            }
            
            // 생일을 이름순으로 정렬
            // Order the birthdays by name
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [birthdays sortUsingDescriptors:sortDescriptors];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // 메인 스레드에서 뷰를 업데이트
                // update the view on the main thread
                NSDictionary *userInfo = @{@"birthdays":birthdays};
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFacebookBirthdaysDidUpdate object:self userInfo:userInfo];
            });
        }
    }];
}


#pragma mark - 페이스북 인증 메소드

- (void)authenticateWithFacebook {
    
    // 앱에서는 ACAccountStore를 통해 트위터, 페이스북, 시나 웨이보 계정에 접근할 수 있다.
    // Centralized iOS user Twitter, Facebook and Sina Weibo accounts are accessed by apps via the ACAccountStore
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    // 페이스북 앱 ID
    // Replace with your Facebook.com app ID
    NSDictionary *options = @{ACFacebookAppIdKey: @"318108061668153",
                              ACFacebookPermissionsKey: @[@"publish_stream",@"friends_birthday"],ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    // requestAccessToAccountsWithType: 메소드를 호출할 때는 사용자가 계정 접근 요청에 반응해 허용 안함이나 승인을 탭할 때 호출할 코드 블록을 인자로 넘김
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook options:options completion:^(BOOL granted, NSError *error) {
        if(granted) {
            
            // 완료 핸들러는 메인 스레드에서 실행되지 않을 수도 있다.
            // The completition handler may not fire in the main thread and as we are going to
            NSLog(@"Facebook Authorized!");
            NSArray *accounts = [accountStore accountsWithAccountType:accountTypeFacebook];
            self.facebookAccount = [accounts lastObject];
            
            // 인증 성공 후 사용자가 하려는 페이스북 작업을 마무리할 수 있게 인증을 처리하기 전에 사용자가 하려는 행동을 확인한다.
            // By checking what Facebook action the user was trying to perform before the authorization process we can complete the Facebook action when the authorization succeeds
            switch (self.currentFacebookAction) {
                case FacebookActionGetFriendsBirthdays:
                    [self fetchFacebookBirthdays];
                    break;
                case FacebookActionPostToWall:
                    // 할일 : 친구의 페이스북 담벼락에 글 남기기
                    // TODO : post to a friend's Facebook Wall
                    [self postToFacebookWall:self.postToFacebookMessage withFacebookID:self.postToFacebookID];
                    break;
            }
        } else {
            
            if ([error code] == ACErrorAccountNotFound) {
                NSLog(@"No Facebook Account Found");
            }
            else {
                NSLog(@"Facebook SSO Authentication Failed: %@",error);
            }
        }
    }];
}



#pragma mark - 페이스북 담벼락에 글 남기기

- (void)postToFacebookWall:(NSString *)message withFacebookID:(NSString *)facebookID
{
    NSLog(@"postToFacebookWall");
    
    if (self.facebookAccount == nil) {
        //We're not authorized yet so store the Facebook message and id and start the authentication flow
        self.postToFacebookMessage = message;
        self.postToFacebookID = facebookID;
        self.currentFacebookAction = FacebookActionPostToWall;
        [self authenticateWithFacebook];
        return;
    }
    
    NSLog(@"We're authorized so post to Facebook!");
    
    NSDictionary *params = @{@"message":message};
    
    //Use the user's Facebook ID to call the post to friend feed Graph API path
    NSString *postGraphPath = [NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",facebookID];
    
    NSURL *requestURL = [NSURL URLWithString:postGraphPath];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:requestURL parameters:params];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error != nil) {
            NSLog(@"Error posting to Facebook: %@",error);
        }
        else
        {
            //Facebook returns a dictionary with the id of the new post - this might be useful for other projects
            NSDictionary *dict = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            NSLog(@"Successfully posted to Facebook! Post ID: %@",dict);
        }
    }];
    
}



#pragma mark - 생일 엔티티의 데이터베이스를 순회하고 시간이 지난 nextBirthday 값을 업데이트

-(void) updateCachedBirthdays
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBirthday" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    
    // 다음 생일 순서대로 모든 생일 엔티티를 가져옴
    // Fetch all the birthday entities in order of next birthday
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nextBirthday" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    NSInteger resultCount = [fetchedObjects count];
    
    DBirthday *birthday;
    
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponentsToday = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    // 오늘 00:00에 해당하는 날짜를 생성
    // This creates a date with time 00:00 today
    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:dateComponentsToday];
    
    for (int i = 0; i < resultCount; i++) {
        birthday = (DBirthday *) fetchedObjects[i];
        
        // 다음 생일이 이미 지났다면 생일 엔티티를 업데이트해야 한다.
        // if next birthday has past then we'll need to update the birthday entity
        if ([today compare:birthday.nextBirthday] == NSOrderedDescending) {
            
            // 이제 다음 생일이 정확하지 않고 이미 지났다.
            // next birthday is now incorrect and is in the past...
            [birthday updateNextBirthdayAndAge];
            }
    }
    
    [self saveChanges];
    
    // 데이터베이스에서 생일 정보가 업데이트됐음을 옵저버에게 모두 알려준다.
    // Let any observer's know that the birthdays in our database have been updated
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCachedBirthdaysDidUpdate object:self userInfo:nil];
}



@end