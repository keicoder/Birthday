//
//  EditViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"


#pragma mark - 편집 뷰 컨트롤러를 텍스트 필드의 델리게이트로 설정 <UITextFieldDelegate>
#pragma mark 액션 시트 구현을 위해 <UIActionSheetDelegate> 프로토콜 구현 선언
#pragma mark 사진 촬영과 사진 라이브러리 검색을 위해 <UIImagePickerControllerDelegate>와 <UINavigationControllerDelegate> 프로토콜 구현 선언
@interface EditViewController : CoreViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - 공개 속성
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *includeYearLabel;
@property (weak, nonatomic) IBOutlet UISwitch *includeYearSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

// birthday 딕셔너리 - 딕셔너리의 키 값을 기반으로 하위 뷰 업데이트
@property (nonatomic, strong) NSMutableDictionary *birthday;

#pragma mark - 좌측상단 포토 이미지 속성
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *picPhotoLabel;


#pragma mark - 텍스트 필드의 텍스트 변경 추적 및 반응
- (IBAction)didChangeNameText:(id)sender;

#pragma mark - 스위치 토글 시점에 따른 액션
- (IBAction)didToggleSwitch:(id)sender;

#pragma mark - 데이트 피커 업데이트 시점에 따른 액션
- (IBAction)didChangeDatePicker:(id)sender;

#pragma mark - 좌측상단 포토 이미지를 탭할때 실행할 Tap Gesture Recognizer 액션 메소드
- (IBAction)didTapPhoto:(id)sender;



@end
