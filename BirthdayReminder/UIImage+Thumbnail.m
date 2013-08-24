//
//  UIImage+Thumbnail.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 24..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)


// 생일에 추가할 사진의 크기를 최적화한 작은 버전을 생성
// creatThumbnailToFillSize: 메소드가 인자로 받은 크기에 맞게 잘라낸 이미지를 생성
// 이 기능을 카테고리에 구현하면 이미지 크기를 최적화해야 하는 파일에서 손쉽게 카테고리 파일을 불러와 활용할 수 있다.

- (UIImage *) creatThumbnailToFillSize:(CGSize)size
{
    CGSize mainImageSize = self.size;
    
    UIImage *thumb;
    
    CGFloat widthScaler = size.width / mainImageSize.width;
    CGFloat heightScaler = size.height / mainImageSize.height;
    
    CGSize repositionedMainImageSize = mainImageSize;
    
    CGFloat scaleFactor;
    // 너비와 높이 중 이미지를 줄일 기준을 판단
    if (widthScaler > heightScaler) {
        // 너비 값을 기반으로 계산
        scaleFactor = widthScaler;
        repositionedMainImageSize.height = ceil(size.height / scaleFactor);
    } else {
        // 높이 값을 기반으로 계산
        scaleFactor = heightScaler;
        repositionedMainImageSize.width = ceil(size.width / scaleFactor);
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGFloat xInc = ((repositionedMainImageSize.width - mainImageSize.width) / 2.f) *scaleFactor;
    CGFloat yInc = ((repositionedMainImageSize.height - mainImageSize.height) / 2.f) *scaleFactor;
    
    [self drawInRect:CGRectMake(xInc, yInc, mainImageSize.width * scaleFactor, mainImageSize.height * scaleFactor)];
    thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumb;
}


@end
