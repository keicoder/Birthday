//
//  EditViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

#pragma mark - 생일 편집 뷰에서 Cancel 버튼을 눌렀을 때 홈 뷰 컨트롤러로 되돌아가기 위한 메소드.
- (IBAction)cancelAndDismiss:(id)sender;

@end
