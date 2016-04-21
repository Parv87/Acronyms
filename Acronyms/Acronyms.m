//
//  Acronyms.m
//  Acronyms
//
//  Created by Parvinder Singh on 4/20/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import "Acronyms.h"
#import <AFNetworking/AFNetworking.h>

@implementation Acronyms

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        self.name = [info valueForKey:@"lf"];
        self.freq = [[info valueForKey:@"freq"] integerValue];
        self.year = [[info valueForKey:@"since"] integerValue];
    }
    return self;
}

@end



#pragma mark - AcronymsManager

@interface AcronymsManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation AcronymsManager

+ (instancetype)sharedInstance {
    static AcronymsManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AcronymsManager alloc] init];
        [_sharedInstance setup];
    });
    return _sharedInstance;
}

#pragma mark - Singleton Initilization
- (void)setup {
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.nactem.ac.uk/software/acromine"]];
    [_manager setCompletionQueue:dispatch_queue_create("com.onward.acronyms", DISPATCH_QUEUE_CONCURRENT)];
    [_manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
}

- (void)search:(NSString *)text withCompletionBlock:(void (^)(NSArray *items, NSString *message))block {
    if ([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    [self.manager GET:@"dictionary.py" parameters:@{@"sf":text} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *serializationError = nil;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&serializationError];
        if (serializationError) {
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
            [items addObject:[[Acronyms alloc] initWithInfo:item]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(items,[items count] == 0 ? @"No Results Found" : nil);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(@[],error.localizedDescription);
            }
        });
        
    }];
}



@end