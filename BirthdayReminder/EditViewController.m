//
//  EditViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

#pragma mark 사진 촬영과 사진 라이브러리 검색을 위해 private 속성 선언
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end


@implementation EditViewController

#pragma mark - 텍스트 필드 델리게이트 메소드 (필수 메소드는 없음 / UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    return NO;
}


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// updateSaveButton 메소드의 호출 지점 -->
// viewWillAppear 및 didChangeNameText가 실행되는 시점
// birthday 딕셔너리 - 딕셔너리의 키 값을 기반으로 하위 뷰 업데이트

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSaveButton];
    
    NSString *name = self.birthday [@"name"];
    NSDate *birthdate = self.birthday [@"birthdate"];
    UIImage *image = self.birthday [@"image"];
    
    self.nameTextField.text = name;
    self.datePicker.date = birthdate;
    if (image == Nil) {
        // 생일 이미지가 없으면 기본으로 생일 케이크 이미지 사용
        self.photoView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    } else {
        self.photoView.image = image;
    }
}


#pragma mark - 텍스트 필드의 텍스트 변경 추적 및 반응

// 편집 뷰에서 수정된 birthday 딕셔너리 업데이트
// 사용자가 생일의 name 텍스트 필드를 수정할 때마다 참조된 birthday 딕셔너리의 name 키 값 업데이트

- (IBAction)didChangeNameText:(id)sender
{
    NSLog(@"The text was changed : %@", self.nameTextField.text);
    [self updateSaveButton];
    
    self.birthday[@"name"] = self.nameTextField.text;
}


#pragma mark - 텍스트 필드의 텍스트 변경시에만 Save 버튼을 활성하기 위한 private 메소드

- (void) updateSaveButton
{
    self.saveButton.enabled = self.nameTextField.text > 0;
}


#pragma mark - 스위치 토글 시점에 따른 액션

- (IBAction)didToggleSwitch:(id)sender
{
    if (self.includeYearSwitch.on) {
        NSLog(@"Sure, I'll share my age with you!");
    } else {
        NSLog(@"I'd prefer to keep my birthday year to myself. Thank you!");
    }
}


#pragma mark - 데이트 피커 업데이트 시점에 따른 액션

// 편집 뷰에서 수정된 birthday 딕셔너리 업데이트
// 사용자가 생일의 데이트 피커에서 날짜를 선택하면 참조된 birthday 딕셔너리의 birthdate 키 값 업데이트

- (IBAction)didChangeDatePicker:(id)sender
{
    NSLog(@"New birthdate selected : %@", self.datePicker.date);
    
    self.birthday[@"birthdate"] = self.datePicker.date;
}


#pragma mark - 좌측상단 포토 이미지를 탭할때 실행할 Tap Gesture Recognizer 액션 메소드 (액션 시트 활용)

- (IBAction)didTapPhoto:(id)sender
{
    NSLog(@"Did tap photo!!!");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"No camera detected!");
        [self pickPhoto];  // 만약 카메라를 찍을 수 없는 상황에서도 사진 라이브러리는 이용할 수 있으므로 사진 라이브러리를 보여줄 수 있도록 [self pickPhoto] 추가
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Photo", @"Pick from Photo Library", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - 이미지 피커 컨트롤러(UIImagePickerController)의 인스턴스를 생성

// 이미지 피커 속성의 게터만 오버라이드해 최초로 참조하는 시점에만 이미지 피커 컨트롤러의 인스턴스를 생성 (늦은 초기화)

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}


#pragma mark - 사진을 찍거나 가겨오기 위한 두 메소드

- (void) takePhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void) pickPhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate 메소드 (takePhoto, pickPhoto 메소드 호출)

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self pickPhoto];
            break;
            
        default:
            break;
    }
}


#pragma mark - 이미지 피커 컨트롤러(UIImagePickerControllerDelegate) 델리게이트 콜백

// 찍거나 라이브러리에서 가져온 사진 가져오기
// 편집 뷰에서 수정된 birthday 딕셔너리 업데이트
// 사용자가 생일의 사진을 수정할 때마다 참조된 photoView 이미지 업데이트

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.photoView.image = image;
    
    self.birthday[@"image"] = image;
}





@end
