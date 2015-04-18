//
//  NSObject+PerformSelector.m
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)

- (id)swift_performSelector:(SEL)selector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:selector];
#pragma clang diagnostic pop
}

@end
