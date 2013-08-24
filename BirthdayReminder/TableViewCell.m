//
//  TableViewCell.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 25..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "TableViewCell.h"
#import "DBirthday.h"

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
        self.remainingDaysImageView.image = [UIImage imageNamed:@"icon-days-remaining.png"];
    }
    
    self.birthdayLabel.text = _birthday.birthdayTextToDisplay;
    
}


@end
