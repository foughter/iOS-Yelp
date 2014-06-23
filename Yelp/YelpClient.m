//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term Deal:(BOOL)hasDeal CategoryList:(NSArray*)categoryList CategoryCheckArray:(BOOL[])categoryChechArray success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    //NSMutableDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:term forKey:@"term"];
    [parameters setObject:@"San Francisco" forKey:@"location"];

    if (hasDeal == YES)
        [parameters setValue:@"true" forKey:@"deals_filter"];
    
    NSMutableString* categoryStr = [[NSMutableString alloc]init];
    //[categoryStr appendString:@"newamerican,"];
    
    BOOL isFirst = YES;
   
    for (int i = 0; i< categoryList.count; i++)
    {
        if (categoryChechArray[i])
        {
            if (!isFirst)
                [categoryStr appendString:@","];
            
            [categoryStr appendString:categoryList[i]];
            isFirst = NO;
        }
    }
    
    NSLog(@"categoryStr = %@", categoryStr);
    
    if (categoryStr.length > 0)
        [parameters setObject:categoryStr forKey:@"category_filter"];
  
    
//        parameters = @{@"term": term, @"location" : @"San Francisco", @"deals_filter": @"true"};
//    else parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
