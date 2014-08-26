//
//  ViewController.m
//  githuboauth
//
//  Created by Bradley Johnson on 8/26/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

#import "ViewController.h"

#define GITHUB_CLIENT_ID @"050ccc57aca5b1143b13"
#define GITHUB_CLIENT_SECRET @"e3e78e77de0dccd5d13b4db841a59f8fa799b8ed"
#define GITHUB_CALLBACK_URI @"githuboauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"


@interface ViewController ()



@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}

@end
