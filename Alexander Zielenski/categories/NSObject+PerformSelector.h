//
//  NSObject+PerformSelector.h
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)

- (id)swift_performSelector:(SEL)selector;

@end
