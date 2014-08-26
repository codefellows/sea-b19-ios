//
//  NetworkController.h
//  githuboauth
//
//  Created by Bradley Johnson on 8/26/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

-(void)handleCallBackURL:(NSURL *)url;

@end
