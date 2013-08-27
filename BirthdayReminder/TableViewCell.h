//
//  TableViewCell.h
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 25..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBirthday;
@class DBirthdayImport;


@interface TableViewCell : UITableViewCell


@property (nonatomic, strong) DBirthday *birthday;
@property (nonatomic, strong) DBirthdayImport *birthdayImport;

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UIImageView *remainingDaysImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *birthdayLabel;
@property (nonatomic, weak) IBOutlet UILabel *remainingDaysLabel;
@property (nonatomic, weak) IBOutlet UILabel *remainingDaysSubTextLabel;

@end
