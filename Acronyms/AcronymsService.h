//
//  AcronymsService.h
//  Acronyms
//
//  Created by Temp on 4/21/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcronymsService : NSObject

+ (instancetype)sharedInstance;
- (void)search:(NSString *)text withCompletionBlock:(void (^)(NSArray *items, NSString *message))block;

@end
