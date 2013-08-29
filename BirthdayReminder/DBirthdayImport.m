//
//  DBirthdayImport.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 27..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DBirthdayImport.h"
#import "UIImage+Thumbnail.h"
// 썸네일 카테고리 임포트


@implementation DBirthdayImport


#pragma mark - 커스텀 초기자 메소드 (연락처 레코드 초기자를 통해 DBirthdayImport 인스턴스를 생성하고 값도 채울 수 있게...)

-(id)initWithAddressBookRecord:(ABRecordRef)addressBookRecord
{
    self = [super init];
    if (self) {
        CFStringRef firstName = nil;
        CFStringRef lastName = nil;
        ABRecordID recordID;
        CFDateRef birthdate = nil;
        NSString *name = @"";
        
        //코어 파운데이션 문자열과 날짜 참조 값을 채우려고 시도
        //Attempt to populate core foundation string and date references
        recordID = ABRecordGetRecordID(addressBookRecord);
        firstName = ABRecordCopyValue(addressBookRecord, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(addressBookRecord, kABPersonLastNameProperty);
        birthdate  = ABRecordCopyValue(addressBookRecord, kABPersonBirthdayProperty);
        
        //이름과 성을 한 문자열로 합침
        //combine first and last names into a single string
        if (firstName != nil) {
            name = [name stringByAppendingString:(__bridge NSString *)firstName];
            if (lastName != nil) {
                name = [name stringByAppendingFormat:@" %@",lastName];
            }
        }
        else if (lastName != nil) {
            name = (__bridge NSString *)lastName;
        }
        
        self.name = name;
        
        //사용자가 연락처에서 생일을 다시 불러올 때
        //코어 데이터 저장소에 중복 데이터를 생성하지 않게끔 고유 id 사용
        //we'll use this unique id to ensure that we never create duplicate imports in our Core Data store
        //if the user attempts to re-import this birthday address book contact
        self.uid = [NSString stringWithFormat:@"ab-%d",recordID];
        self.addressBookID = [NSNumber numberWithInt:recordID];
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:(__bridge NSDate *)birthdate];
        
        self.birthDay = @(dateComponents.day);
        self.birthMonth = @(dateComponents.month);
        self.birthYear = @(dateComponents.year);
        
        [self updateNextBirthdayAndAge];
        
        //150년전 이전에 태어난 친구의 생일을 처리하는 코드
        //just a precautionary measure incase the birthday date has been set more than 150 years ago!
        if ([self.nextBirthdayAge intValue] > 150) {
            self.birthYear = [NSNumber numberWithInt:0];
            self.nextBirthdayAge = [NSNumber numberWithInt:0];
        }
        
        //사용자와 관련한 이미지 데이터를 검사
        //Check for Image Data associated with the user
        if (ABPersonHasImageData(addressBookRecord)) {
            CFDataRef imageData = ABPersonCopyImageData(addressBookRecord);
            
            UIImage *fullSizeImage = [UIImage imageWithData:(__bridge NSData *)imageData];
            
            CGFloat side = 71.f;
            side *= [[UIScreen mainScreen] scale];
            
            UIImage *thumbnail = [fullSizeImage creatThumbnailToFillSize:CGSizeMake(side, side)];
            
            self.imageData = UIImageJPEGRepresentation(thumbnail, 1.f);
            
            CFRelease(imageData);
        }
        
        if (firstName) CFRelease(firstName);
        if (lastName) CFRelease(lastName);
        if (birthdate) CFRelease(birthdate);
    }
    return self;
}



#pragma mark 커스텀 초기자 메소드 (페이스북 사용자 딕셔너리로부터 DBirthdayImport 인스턴스를 생성하는 초기자)

-(id)initWithFacebookDictionary:(NSDictionary *)facebookDictionary
{
    self = [super init];
    if (self) {
        self.name = [facebookDictionary objectForKey:@"name"];
        self.uid = [NSString stringWithFormat:@"fb-%@",facebookDictionary[@"id"]];
        self.facebookID = [NSString stringWithFormat:@"%@",facebookDictionary[@"id"]];
        
        // 페이스북은 페이스북 ID를 통해 페이스북 프로필 사진에 쉽게 접근할 수 있게 편의 URL을 제공한다.
        // Facebook provides a convenience URL for Facebook profile pics as long as you have the Facebook ID
        self.picURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.facebookID];
        
        // 페이스북은 [월]/[일]/[연도] 또는 [월]/[일] 문자열 형태의 생일을 반환한다.
        // Facebook returns birthdays in the string format [month]/[day]/[year] or [month]/[day]
        NSString *birthDateString = [facebookDictionary objectForKey:@"birthday"];
        NSArray *birthdaySegments = [birthDateString componentsSeparatedByString:@"/"];
        
        self.birthDay =  [NSNumber numberWithInt:[birthdaySegments[1] intValue]];
        self.birthMonth = [NSNumber numberWithInt:[birthdaySegments[0] intValue]];
        
        if ([birthdaySegments count] > 2) {
            // 연도 포함
            // includes year
            self.birthYear = [NSNumber numberWithInt:[birthdaySegments[2] intValue]];
        }
        
        [self updateNextBirthdayAndAge];
    }
    return self;
}




// DBirthday.m 에서 복사한 코드

#pragma mark - updateNextBirthdayAndAge (nextBirthday와 nextBirthdayAge를 업데이트하는데 이용)

- (void) updateNextBirthdayAndAge
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:dateComponents];
    
    dateComponents.day = [self.birthDay intValue]; // 친구의 생일 일자 설정
    dateComponents.month = [self.birthMonth intValue]; // 친구의 생일 달 설정
    
    NSDate *birthdayThisYear = [calendar dateFromComponents:dateComponents]; // 친구의 올해 생일
    
    if ([today compare:birthdayThisYear] == NSOrderedDescending) {
        // 올해 생일은 지났으므로 다음 생일은 내년에 돌아온다
        dateComponents.year++;
        self.nextBirthday = [calendar dateFromComponents:dateComponents];
    } else {
        self.nextBirthday = [birthdayThisYear copy];
    }
    
    if ([self.birthYear intValue] > 0) {
        self.nextBirthdayAge = [NSNumber numberWithInt:dateComponents.year - [self.birthYear intValue]];
    } else {
        self.nextBirthdayAge = [NSNumber numberWithInt:0];
    }
}


#pragma mark - updateWithDefaults

- (void) updateWithDefaults
{
    // DBirthday 엔티티의 필수 어트리뷰트인 birthDay와 birthMonth를 설정하기 위해 Add 버튼을 탭할 때 호출
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    self.birthDay = @(dateComponents.day);
    self.birthMonth = @(dateComponents.month);
    self.birthYear = @0;
    
    [self updateNextBirthdayAndAge];
}



#pragma mark - 세 개의 읽기 전용 게터 메소드 (remainingDaysUntilNextBirthday, isBirthdayToday, birthdayTextToDisplay)

- (int) remainingDaysUntilNextBirthday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    NSTimeInterval timeDiffSecs = [self.nextBirthday timeIntervalSinceDate:today];
    int days = floor(timeDiffSecs/(60.f*60.f*24.f));
    
    return days;
}


- (BOOL) isBirthdayToday
{
    return [self remainingDaysUntilNextBirthday] == 0;
}


- (NSString *) birthdayTextToDisplay
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:componentsToday];
    
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:self.nextBirthday options:0]; // 핵심 코드 : NSDateComponents 클래스로 두 날짜 사이의 차이를 계산
    
    if (components.month == 0) {
        if (components.day == 0) {
            // 오늘!
            if ([self.nextBirthdayAge intValue] > 0) {
                return [NSString stringWithFormat:@"%@ Today!", self.nextBirthdayAge];
            } else {
                return @"Today!";
            }
        }
        if (components.day == 1) {
            // 내일!
            if ([self.nextBirthdayAge intValue] > 0) {
                return [NSString stringWithFormat:@"%@ Tomorrow!", self.nextBirthdayAge];
            } else {
                return @"Tomorrow!";
            }
        }
    }
    
    NSString *text = @"";
    
    if ([self.nextBirthdayAge intValue] > 0) {
        text = [NSString stringWithFormat:@"%@ on ", self.nextBirthdayAge];
    }
    
    static NSDateFormatter *dateFormatterPartial;
    
    if (dateFormatterPartial == Nil) {
        dateFormatterPartial = [[NSDateFormatter alloc] init];
        [dateFormatterPartial setDateFormat:@"MMM d"];
    }
    
    return [text stringByAppendingFormat:@"%@", [dateFormatterPartial stringFromDate:self.nextBirthday]];
}




@end
