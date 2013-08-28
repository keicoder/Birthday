//
//  DetailViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"
@class DBirthday;

@interface DetailViewController : CoreViewController <UIActionSheetDelegate>

// 상세 뷰에서 보여질 사진 뷰 속성
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

// 상세 뷰에서 필요한 수정 가능한 생일 딕셔너리 속성
// @property (weak, nonatomic) NSMutableDictionary *birthday;

// DBirthday 관리 객체에 대한 참조
@property (nonatomic, strong) DBirthday *birthday;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingDaysSubTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remainingDaysImageView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)facebookButtonTapped:(id)sender;
- (IBAction)callButtonTapped:(id)sender;
- (IBAction)smsButtonTapped:(id)sender;
- (IBAction)emailButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;





@end
