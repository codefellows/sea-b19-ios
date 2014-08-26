//
//  NetworkController.m
//  githuboauth
//
//  Created by Bradley Johnson on 8/26/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

#import "NetworkController.h"
#import "Constants.h"



@interface NetworkController ()

@property (strong,nonatomic) NSURLSession *session;
@property (strong,nonatomic) NSString *token;

@end

@implementation NetworkController

-(instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}


-(void)handleCallBackURL:(NSURL *)url {
    NSLog(@" %@",url);
    //parsing (vick) the url given back to us after login
    NSString *query = url.query;
    NSArray *components = [query componentsSeparatedByString:@"code="];
    //this is our temp code
    NSString *code = components.lastObject;
    
    //setting up our parameters for our POST
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",kGitHubClientID,kGitHubClientSecret,code];
    //convert the parameters to data for sending
    NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //get the length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    //creating our request for our data task
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //set a bunch properties on our request
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    //we need the length of the data we are posting
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //tell it the type of data
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //log error
        if (error) {
            NSLog(@" %@",error.localizedDescription);
        } else {
            NSLog(@" %@", response);
            self.token = [self convertDataToToken:data];
            NSLog(@"%@",self.token);
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            //once we set this field, all calls made with this session are authenticated
            [configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@",self.token]}];
            
            self.session = [NSURLSession sessionWithConfiguration:configuration];
            
            [self fetchUsersRepos];
        }
        
    }];
    [postDataTask resume];
}

-(NSString *)convertDataToToken:(NSData *)data {
   
    //parsing the data we got back, turning it into a string first
    NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //cutting it in half at the &
    NSArray *tokenComponents = [response componentsSeparatedByString:@"&"];
    NSString *tokenWithCode = tokenComponents[0];
    //cutting it in half again at the =
    NSArray *tokenArray = [tokenWithCode componentsSeparatedByString:@"="];
    return tokenArray.lastObject;
    
}

-(void)fetchUsersRepos {
    
    NSURL *repoURL = [[NSURL alloc] initWithString:@"https://api.github.com/user/repos"];
    [[self.session dataTaskWithURL:repoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSLog(@"%@",response);
        }
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }] resume];
}
@end
