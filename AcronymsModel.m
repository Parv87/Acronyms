//
//  AcronymsModel.m
//  Acronyms
//
//  Created by Temp on 4/21/16.
//  Copyright © 2016 Onward Technologies Inc. All rights reserved.
//

#import "AcronymsModel.h"

@implementation AcronymsModel

//Method to set properties for json result values
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
