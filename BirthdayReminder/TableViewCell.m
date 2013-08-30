//
//  TableViewCell.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 25..
//  Copyright (c) 2013년 jun. All rights reserved.
//


#define ICI1 @"inCellDaysImage.png"


#import "TableViewCell.h"
#import "DBirthday.h"
#import "StyleSheet.h"
#import "DBirthdayImport.h"
#import "UIImageView+RemoteFile.h"


@implementation TableViewCell


// 홈 뷰 컨트롤러가 각 테이블 뷰 셀을 설정할 때 홈 뷰 컨트롤러는 cell.birthday에 생일 인스턴스를 대입해 birthday 엔티티를 테이블 뷰 셀로 넘겨준다
// 테이블 뷰 셀의 birthday 세터를 오버라이드하면 birthday 속성을 설정할 때마다 라벨과 테이블 셀의 이미지를 업데이트할 수 있다


- (void) setBirthday:(DBirthday *)birthday
{
    _birthday = birthday;
    self.nameLabel.text = _birthday.name;
    
    int days = _birthday.remainingDaysUntilNextBirthday;
    
    if (days == 0) {
        // 오늘이 생일이다!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:ICI1];
    }
    
    self.birthdayLabel.text = _birthday.birthdayTextToDisplay;
    
    if (_birthday.imageData == nil)
    {
        if ([_birthday.picURL length] > 0) {
            [self.iconView setImageWithRemoteFileURL:_birthday.picURL placeHolderImage:[UIImage imageNamed:@"icon-birthday-cake.png"]];
        }
        else self.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        self.iconView.image = [UIImage imageWithData:_birthday.imageData];
    }
    
}


// 스타일시트 적용
/*
 테이블 뷰  셀 클래스는 뷰 클래스이지 쀼 컨트롤러 클래스가 아니다.
 따라서 viewDidLoad 메소드를 통해 인터페이스 빌더의 아웃렛 속성을 변경할 수 없다.
 * 커스텀 테이블 뷰 셀의 이미지 뷰와 라벨에 스타일을 적용할 때는 iOS에서 이들 아웃렛을 처음 생성할 때 한번만 코드를 실행해야 한다.
 * 따라서 스타일 적용 코드를 추가하기에 적합한 위치는 바로 아웃렛 접근자 세터다.
 * 아웃렛 접근자 세터를 오버라이드해 스타일을 적용한다.
*/


/*
-(void) setIconView:(UIImageView *)iconView
{
    _iconView = iconView;
    if (_iconView) {
        [StyleSheet styleRoundCorneredView:_iconView];
    }
}

-(void) setNameLabel:(UILabel *)nameLabel
{
    _nameLabel = nameLabel;
    if (_nameLabel) {
        [StyleSheet styleLabel:_nameLabel withType:LabelTypeName];
    }
}

-(void) setBirthdayLabel:(UILabel *)birthdayLabel
{
    _birthdayLabel = birthdayLabel;
    if (_birthdayLabel) {
        [StyleSheet styleLabel:_birthdayLabel withType:LabelTypeBirthdayDate];
    }
}
*/

-(void) setRemainingDaysLabel:(UILabel *)remainingDaysLabel
{
    _remainingDaysLabel = remainingDaysLabel;
    if (_remainingDaysLabel) {
        [StyleSheet styleLabel:_remainingDaysLabel withType:LabelTypeDaysUntilBirthday];
    }
}

-(void) setRemainingDaysSubTextLabel:(UILabel *)remainingDaysSubTextLabel
{
    _remainingDaysSubTextLabel = remainingDaysSubTextLabel;
    if (_remainingDaysSubTextLabel) {
        [StyleSheet styleLabel:_remainingDaysSubTextLabel withType:LabelTypeDaysUntilBirthdaySubText];
    }
}


#pragma mark - 연락처 임포트 뷰의 데이블 뷰로 연락처 사진 및 데이터 불러오기

// birthdayImport 세터 오버라이드
// 생일 관리 객체의 세터와 거의 동일

-(void) setBirthdayImport:(DBirthdayImport *)birthdayImport
{
    _birthdayImport = birthdayImport;
    self.nameLabel.text = _birthdayImport.name;
    
    int days = _birthdayImport.remainingDaysUntilNextBirthday;
    
    if (days == 0) {
        // 생일이 오늘!
        self.remainingDaysLabel.text = self.remainingDaysSubTextLabel.text = @"";
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        self.remainingDaysLabel.text = [NSString stringWithFormat:@"%d",days];
        self.remainingDaysSubTextLabel.text = (days == 1) ? @"more day" : @"more days";
        self.remainingDaysImageView.image = [UIImage imageNamed:ICI1];
    }
    
    self.birthdayLabel.text = _birthdayImport.birthdayTextToDisplay;
    
    if (_birthdayImport.imageData == nil)
    {
        if ([_birthdayImport.picURL length] > 0) {
            [self.iconView setImageWithRemoteFileURL:birthdayImport.picURL placeHolderImage:[UIImage imageNamed:@"icon-birthday-cake.png"]];
        }
        else self.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    }
    else {
        self.iconView.image = [UIImage imageWithData:birthdayImport.imageData];
    }
    
}



@end
