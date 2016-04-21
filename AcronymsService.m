//
//  AcronymsService.m
//  Acronyms
//
//  Created by Temp on 4/21/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.

#import "AcronymsService.h"
#import "AcronymsModel.h"
#import <AFNetworking/AFNetworking.h>

#define BaseURL @"http://www.nactem.ac.uk/software/acromine" //Base Url of API

@interface AcronymsService()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation AcronymsService

//Creating global access method
+ (instancetype)sharedInstance {
    static AcronymsService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AcronymsService alloc] init];
        [_sharedInstance setup];
    });
    return _sharedInstance;
}

#pragma mark - Singleton Initilization
//Function for initiating networking call for parsing
- (void)setup {
    NSString *urlString = [NSString stringWithFormat:@"%@",BaseURL];
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [_manager setCompletionQueue:dispatch_queue_create("com.onward.acronyms", DISPATCH_QUEUE_CONCURRENT)];
    [_manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
}

//Function for calling service API, error handling & failure messages
- (void)search:(NSString *)text withCompletionBlock:(void (^)(NSArray *items, NSString *message))block {
    if ([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    [self.manager GET:@"dictionary.py" parameters:@{@"sf":text} progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *serializationError = nil;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&serializationError];
        if (serializationError) { //error block
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(@[],serializationError.localizedDescription);
                }
            });
            return;
        }
        NSMutableArray *items = [NSMutableArray array];
        NSArray *longForms = [[results firstObject] valueForKey:@"lfs"];
        for (NSDictionary *item in longForms) {
            [items addObject:[[AcronymsModel alloc] initWithInfo:item]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{ //validation message
            if (block) {
                block(items,[items count] == 0 ? @"No Results Found" : nil);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { //failure block
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(@[],error.localizedDescription);
            }
        });
    }];
}
@end
