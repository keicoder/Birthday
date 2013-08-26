//
//  ImportViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 26..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController ()

@end

@implementation ImportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 테이블 뷰 데이터 소스 메소드 (Table view data source)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.birthdays count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
}



#pragma mark - 버튼 액션 메소드

- (IBAction)didTapImportButton:(id)sender
{
    
}


- (IBAction)didTapSelectAllButton:(id)sender
{
    
}


- (IBAction)didTapSelectNoneButton:(id)sender
{
    
}



@end
