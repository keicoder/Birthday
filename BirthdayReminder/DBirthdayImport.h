//
//  DBirthdayImport.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 27..
//  Copyright (c) 2013년 jun. All rights reserved.
//


// DModel의 addressBookBirthdays 메소드는 사용자의 연락처를 모두 순회한다.
// 반환된 연락처를 처리하고 보관하는 클래스 --> 연락처 뷰 컨트롤러(not 홈 뷰 컨트롤러)에 관련 데이터를 보여줌
// 이 클래스는 코어 데이터 관리 객체인 DBirthday와 매우 유사하다.
// notes 속성을 제외하곤 DBirthday 엔티티와 동일한 속성
// 연락처 레코드 초기자를 통해 DBirthdayImport 인스턴스를 생성하고 값도 채울 수 있게끔 initWithAddressBookRecord:라는 커스텀 초기자 메소드도 선언함.


#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface DBirthdayImport : NSObject


@property (nonatomic, strong) NSNumber *addressBookID;
@property (nonatomic, strong) NSNumber *birthDay;
@property (nonatomic, strong) NSNumber *birthMonth;
@property (nonatomic, strong) NSNumber *birthYear;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *nextBirthday;
@property (nonatomic, strong) NSNumber *nextBirthdayAge;
@property (nonatomic, strong) NSString *picURL;
@property (nonatomic, strong) NSString *uid;

@property (nonatomic,readonly) int remainingDaysUntilNextBirthday;
@property (nonatomic,readonly) NSString *birthdayTextToDisplay;
@property (nonatomic,readonly) BOOL isBirthdayToday;


#pragma mark - 커스텀 초기자 메소드 (연락처 레코드 초기자를 통해 DBirthdayImport 인스턴스를 생성하고 값도 채울 수 있게...)

-(id)initWithAddressBookRecord:(ABRecordRef)addressBookRecord;


@end
