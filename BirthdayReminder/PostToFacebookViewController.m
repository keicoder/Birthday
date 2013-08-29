//
//  PostToFacebookViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "PostToFacebookViewController.h"
#import "StyleSheet.h"
#import "UIImageView+RemoteFile.h"

@interface PostToFacebookViewController ()

@end

@implementation PostToFacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [StyleSheet styleRoundCorneredView:self.photoView];
    [StyleSheet styleTextView:self.textView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *facebookPicURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",self.facebookID];
    
    [self.photoView setImageWithRemoteFileURL:facebookPicURL placeHolderImage:[UIImage imageNamed:@"icon-birthday-cake.png"]];
    self.textView.text = self.initialPostText;
    
    [self.textView becomeFirstResponder];
    
    [self updatePostButton];
}



- (IBAction)postToFacebook:(id)sender {
}


-(void) updatePostButton
{
    self.postButton.enabled = self.textView.text.length > 0;
}



#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updatePostButton];
}







@end
