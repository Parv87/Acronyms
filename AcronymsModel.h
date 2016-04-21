//
//  AcronymsModel.h
//  Acronyms
//
//  Created by Temp on 4/21/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcronymsModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger freq;
@property (nonatomic) NSInteger year;

- (instancetype)initWithInfo:(NSDictionary *)info;

@end
