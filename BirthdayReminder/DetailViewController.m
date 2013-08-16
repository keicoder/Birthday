//
//  DetailViewController.m
//  BirthdayReminder
//
//  Created by lovejun on 2013. 8. 16..
//  Copyright (c) 2013년 jun. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end


@implementation DetailViewController


#pragma mark - 스토리보드 지정초기자

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"initWithCoder");
    }
    return self;
}

    
#pragma mark - 뷰 라이프 사이클
// UIViewController의 

- (void) dealloc
{
    NSLog(@"dealloc");
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}
    
    
#pragma mark - 메모리 관리

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
