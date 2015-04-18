//
//  ZeppelinPreview.h
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZeppelinPreview : NSObject

+ (instancetype)sharedInstance;
- (void)turnOn;
- (void)turnOff;

@end
