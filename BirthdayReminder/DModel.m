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


@end