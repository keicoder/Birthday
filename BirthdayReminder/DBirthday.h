//
//  DBirthday.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 21..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBirthday : NSManagedObject

// DBirthday를 NSManagedObject의 하위 클래스로 만들면 추가적인 장점이 있다.
// --> DBirthday 하위 클래스에서 새 메소드와 비영속성 속성을 추가할 수 있다.

// 딕셔너리, 배열과 마찬가지로 코어 데이타는 원시 타입을 어트리뷰트로 사용할 수 없다.
// 정수를 NSNumber 인스턴스로 감싼 이유도 이 때문이다.

@property (nonatomic, retain) NSNumber * birthDay;
@property (nonatomic, retain) NSNumber * addressBookID;
@property (nonatomic, retain) NSNumber * birthMonth;
@property (nonatomic, retain) NSNumber * birthYear;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * nextBirthday;
@property (nonatomic, retain) NSNumber * nextBirthdayAge;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * picURL;
@property (nonatomic, retain) NSString * uid;


@property (nonatomic, readonly) int remainingDaysUntilNextBirthday;
@property (nonatomic, readonly) NSString *birthdayNextToDisplay;
@property (nonatomic, readonly) BOOL isBirthdayToday; // 생일이 오늘이면 카운트다운 대신 케이크 이미지를 보여줌


@end
