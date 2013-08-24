//
//  UIImage+Thumbnail.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 24..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)


// 생일에 추가할 사진의 크기를 최적화한 작은 버전을 생성
- (UIImage *) creatThumbnailToFillSize:(CGSize)size;


@end
