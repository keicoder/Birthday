//
//  SettingsViewController.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> // email 및 sms 공유

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *tableCellDaysBefore;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableCellNotificationTime;

- (IBAction)didClickDoneButton:(id)sender;


@end
