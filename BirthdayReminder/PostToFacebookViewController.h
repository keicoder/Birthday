//
//  PostToFacebookViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "CoreViewController.h"

@interface PostToFacebookViewController : CoreViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;

@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *initialPostText; // 초기 텍스트

- (IBAction)postToFacebook:(id)sender;



@end
