//
//  DaysBeforeViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DaysBeforeViewController.h"
#import "DSettings.h"


@interface DaysBeforeViewController ()

@end

@implementation DaysBeforeViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app-background.png"]];
    [self.tableView setBackgroundView:backgroundView];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[DSettings sharedInstance] titleForDaysBefore:indexPath.row];
    //if this index path row is the stored days before setting then display a checkmark tick in the table cell
    cell.accessoryType = ([DSettings sharedInstance].daysBefore == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //we could alternatively just return a total row count of 8 but this makes use of the last enumerated value to get the total count
    return DaysBeforeTypeThreeWeeks + 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [DSettings sharedInstance].daysBefore) {
        //if it's the current ticked row then ignore
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:[DSettings sharedInstance].daysBefore inSection:0];
    //Update the stored days before setting for the user
    [DSettings sharedInstance].daysBefore = indexPath.row;
    //The user has changed the selected days before row so we need to reload the table cells for the old and new rows
    [tableView reloadRowsAtIndexPaths:@[oldIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



@end
