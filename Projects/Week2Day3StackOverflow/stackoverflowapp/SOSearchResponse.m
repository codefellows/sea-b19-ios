//
//  SOSearchResponse.m
//
//  Created by Bradley Johnson on 7/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SOSearchResponse.h"
#import "SOItems.h"


NSString *const kSOSearchResponseHasMore = @"has_more";
NSString *const kSOSearchResponseItems = @"items";
NSString *const kSOSearchResponseQuotaMax = @"quota_max";
NSString *const kSOSearchResponseQuotaRemaining = @"quota_remaining";


@interface SOSearchResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SOSearchResponse

@synthesize hasMore = _hasMore;
@synthesize items = _items;
@synthesize quotaMax = _quotaMax;
@synthesize quotaRemaining = _quotaRemaining;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.hasMore = [[self objectOrNilForKey:kSOSearchResponseHasMore fromDictionary:dict] boolValue];
    NSObject *receivedSOItems = [dict objectForKey:kSOSearchResponseItems];
    NSMutableArray *parsedSOItems = [NSMutableArray array];
    if ([receivedSOItems isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSOItems) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSOItems addObject:[SOItems modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSOItems isKindOfClass:[NSDictionary class]]) {
       [parsedSOItems addObject:[SOItems modelObjectWithDictionary:(NSDictionary *)receivedSOItems]];
    }

    self.items = [NSArray arrayWithArray:parsedSOItems];
            self.quotaMax = [[self objectOrNilForKey:kSOSearchResponseQuotaMax fromDictionary:dict] doubleValue];
            self.quotaRemaining = [[self objectOrNilForKey:kSOSearchResponseQuotaRemaining fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasMore] forKey:kSOSearchResponseHasMore];
    NSMutableArray *tempArrayForItems = [NSMutableArray array];
    for (NSObject *subArrayObject in self.items) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItems addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItems addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItems] forKey:kSOSearchResponseItems];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quotaMax] forKey:kSOSearchResponseQuotaMax];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quotaRemaining] forKey:kSOSearchResponseQuotaRemaining];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.hasMore = [aDecoder decodeBoolForKey:kSOSearchResponseHasMore];
    self.items = [aDecoder decodeObjectForKey:kSOSearchResponseItems];
    self.quotaMax = [aDecoder decodeDoubleForKey:kSOSearchResponseQuotaMax];
    self.quotaRemaining = [aDecoder decodeDoubleForKey:kSOSearchResponseQuotaRemaining];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_hasMore forKey:kSOSearchResponseHasMore];
    [aCoder encodeObject:_items forKey:kSOSearchResponseItems];
    [aCoder encodeDouble:_quotaMax forKey:kSOSearchResponseQuotaMax];
    [aCoder encodeDouble:_quotaRemaining forKey:kSOSearchResponseQuotaRemaining];
}

- (id)copyWithZone:(NSZone *)zone
{
    SOSearchResponse *copy = [[SOSearchResponse alloc] init];
    
    if (copy) {

        copy.hasMore = self.hasMore;
        copy.items = [self.items copyWithZone:zone];
        copy.quotaMax = self.quotaMax;
        copy.quotaRemaining = self.quotaRemaining;
    }
    
    return copy;
}


@end
