//
//  Acronyms.h
//  Acronyms
//
//  Created by Parvinder Singh on 4/20/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Acronyms : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger freq;
@property (nonatomic) NSInteger year;

//Future Implemenation
//@property (nonatomic, strong) NSArray *variance;

- (instancetype)initWithInfo:(NSDictionary *)info;
@end



@interface AcronymsManager : NSObject
+ (instancetype)sharedInstance;
- (void)search:(NSString *)text withCompletionBlock:(void (^)(NSArray *items, NSString *message))block;
@end