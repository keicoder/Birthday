//
//  HomeViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController



#pragma mark - 생일 편집 뷰에서 Cancel 버튼을 눌렀을 때 홈 뷰 컨트롤러로 되돌아오기 위한 unwind 메소드.
// 홈 뷰 컨트롤러로 되돌아와야 하므로 홈 뷰 컨트롤러 내에 언와인드 액션을 선언하고 구현해야 함.

- (IBAction)unwindBackToHomeViewController:(UIStoryboardSegue *)segue;

@end
