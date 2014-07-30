//
//  SOItems.h
//
//  Created by Bradley Johnson on 7/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SOOwner;

@interface SOItems : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *closedReason;
@property (nonatomic, assign) double answerCount;
@property (nonatomic, assign) double lastEditDate;
@property (nonatomic, assign) double bountyAmount;
@property (nonatomic, strong) SOOwner *owner;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) double viewCount;
@property (nonatomic, assign) double creationDate;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double acceptedAnswerId;
@property (nonatomic, assign) double bountyClosesDate;
@property (nonatomic, assign) double lastActivityDate;
@property (nonatomic, assign) double questionId;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double closedDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
