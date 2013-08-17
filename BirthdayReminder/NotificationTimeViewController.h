//
//  NotificationTimeViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "CoreViewController.h"

@interface NotificationTimeViewController : CoreViewController

@property (weak, nonatomic) IBOutlet UILabel *whatTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

- (IBAction)didChangeTime:(id)sender;


@end
