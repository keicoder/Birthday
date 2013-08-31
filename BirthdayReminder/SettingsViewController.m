//
//  SettingsViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 29..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#define I5SB1 @"app-background1.png"
#define I5SB2 @"screenBackgroundImage_iP5.png"
#define I5SB3 @"iPhone5ScreenBackgroundImage_iP5retina_lightBlue.png"


#import "SettingsViewController.h"
#import "DSettings.h"
#import "StyleSheet.h"
#import "DModel.h"
#import "Appirater.h" // 사용자 앱 리뷰 리마인드
#import <Social/Social.h> // 공유 버튼


@interface SettingsViewController ()

@end


@implementation SettingsViewController


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 두 개의 정적 설정 테이블 셀에서 오른쪽 값을 동적으로 만듦
    self.tableCellNotificationTime.detailTextLabel.text = [[DSettings sharedInstance] titleForNotificationTime];
    self.tableCellDaysBefore.detailTextLabel.text =  [[DSettings sharedInstance] titleForDaysBefore:[DSettings sharedInstance].daysBefore];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 백그라운드 이미지 설정
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:I5SB2]];
    self.tableView.backgroundView = backgroundView;
}


#pragma mark - 섹션 헤더 (스타일 시트 이용 해 스타일 적용)

-(UIView *) createSectionHeaderWithLabel:(NSString *)text
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40.f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 15.f, 300.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    [StyleSheet styleLabel:label withType:LabelTypeJun];
    label.text = text;
    [view addSubview:label];
    return view;
}


#pragma mark - 테이블 뷰 메소드

#pragma mark 헤더 높이
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

#pragma mark 섹션 헤더 텍스트
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // return [self createSectionHeaderWithLabel:@"Reminders"];
    return section == 0 ? [self createSectionHeaderWithLabel:@"Reminders"] : [self createSectionHeaderWithLabel:@"Share the Love"];
}

#pragma mark 테이블 셀 행을 클릭했을 때
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 사용자가 Days Before나 Alert Time 테이블 셀을 탭하면 무시한다.
    if (indexPath.section == 0) return;
    
    
    NSString *text = @"Check out this iPhone App: Birthday Reminder";
    UIImage *image = [UIImage imageNamed:@"Icon-72@2x.png"];
    NSURL *facebookPageLink = [NSURL URLWithString:@"http://www.facebook.com/apps/application.php?id=123956661050729"];
    NSURL *appStoreLink = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=489537509&mt=8"];
    
    SLComposeViewController * composeViewController;
    
    switch (indexPath.row) {
        case 0:
            // 앱 스토어 리뷰를 추가
            [Appirater rateApp];
            break;
            
            /*
             // 공유 액티비티 뷰 호출 예제
             NSArray *activityItems = @[text, image, appStoreLink];
             
             UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
             
             activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
             
             [self presentViewController:activityViewController animated:YES completion:nil];
             */
            
        case 1:
            // 페이스북 공유
        {
            if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                NSLog(@"No Facebook Account available for user");
                return;
            }
            composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [composeViewController addImage:image];
            [composeViewController setInitialText:text];
            [composeViewController addURL:appStoreLink];
            [self presentViewController:composeViewController animated:YES
                             completion:nil];
            break;
        }
            
        case 2:
            // 페이스북 좋아요 링크
            [[UIApplication sharedApplication] openURL:facebookPageLink];
            break;
            
        case 3:
        {
            // 트위터 공유
            
            if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                NSLog(@"No Twitter Account available for user");
                return;
            }
            composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [composeViewController addImage:image];
            [composeViewController setInitialText:text];
            [composeViewController addURL:appStoreLink];
            [self presentViewController:composeViewController animated:YES
                             completion:nil];
            break;
        }
            
        case 4:
        {
            // 이메일 공유 : email 및 sms 공유를 위해선 MessageUI 프레임워크가 필요함
            if (![MFMailComposeViewController canSendMail]) {
                NSLog(@"Can't send email");
                return;
            }
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            
            // 첨부 파일을 보낼 때는 이미지를 raw NSData로 변환해야 한다.
            // When adding attachments we have to convert the image into it's raw NSData representation
            [mailViewController addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"pic.png"];
            [mailViewController setSubject:@"Birthday Reminder"];
            
            //Combine the text and the app store link to create the email body
            NSString *textWithLink = [NSString stringWithFormat:@"%@\n\n%@",text,appStoreLink];
            
            [mailViewController setMessageBody:textWithLink isHTML:NO];
            mailViewController.mailComposeDelegate = self;
            [self presentViewController:mailViewController animated:YES
                             completion:nil];
            break;
        }
            
            
        default:
            break;
    }

}


#pragma mark - 버튼


- (IBAction)didClickDoneButton:(id)sender
{
    [[DModel sharedInstance] updateCachedBirthdays];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
