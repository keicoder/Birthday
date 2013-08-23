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


@end