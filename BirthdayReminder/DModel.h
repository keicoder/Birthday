//
//  DModel.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 22..
//  Copyright (c) 2013년 jun. All rights reserved.
//


#pragma mark - 코어 데이터 모델의 초기화 설명 주석
/*
 애플의 코어 데이터 코드 예제에서는 애플리케이션 델리게이트 클래스에서 초기화 코드를 사용함
 
 **하지만 보통은 싱글톤 모델 클래스를 하나 만들고 싱글톤 인스턴스에서 코어 데이터 모델을 초기화하는 게 일반적임
 이렇게하면 프로젝트 내 모든 클래스에서 싱글톤 모델 인스턴스를 통해 관리 객체 컨텍스트에 직접 접근할 수 있기 때문임
 
 싱글톤 클래스를 설정하기 위해 여기서는 sharedInstance라는 클래스 메소드를 통해서만 모델에 접근할 수 있게 했음
 DModel의 sharedInstance 메소드는 DModel의 싱클톤 인스턴스를 생성하거나 이미 존재할 경우 이를 그냥 반환함
*/

#import <Foundation/Foundation.h>

@interface DModel : NSObject

#pragma mark - 코어 데이터 모델의 초기화 메소드

+ (DModel *)sharedInstance;  // 클래스 메소드

#pragma mark - 코어 데이터 모델의 속성 (애플의 마스터-상세 앱에서 가져옴)
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


#pragma mark - 코어 데이터 저장소 채우기 - public 인스턴스 메소드이므로 DModel.h에 선언
- (void) saveChanges;

#pragma mark - 코어 데이터 저장 취소 기능 - public 인스턴스 메소드이므로 DModel.h에 선언
- (void) cancelChanges;

#pragma mark - 중복 엔티티 검사
- (NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids;

@end
