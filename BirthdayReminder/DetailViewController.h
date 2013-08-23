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

@interface DetailViewController : CoreViewController

// 상세 뷰에서 보여질 사진 뷰 속성
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

// 상세 뷰에서 필요한 수정 가능한 생일 딕셔너리 속성
// @property (weak, nonatomic) NSMutableDictionary *birthday;

// DBirthday 관리 객체에 대한 참조
@property (nonatomic, strong) DBirthday *birthday;

@end
