//
//  ZeppelinPreview.m
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

#import "ZeppelinPreview.h"
#import "ZKSwizzle.h"

/**
 Awww...
 
 3.3.1 Applications may only use Documented APIs in the manner prescribed by Apple and must not use or call any private APIs.
 */
//! Uncomment the required lines for awesomeness! (really)

@interface ZeppelinPreview ()
@property (assign, getter=isEnabled) BOOL enabled;
@end

/**
@interface UIView (Statusbar)
-(id)_serviceContentsImage;
-(double)updateContentsAndWidth;
@end

@interface NSObject (Statusbar)
+ (id)imageFromImage:(UIImage *)image withShadowImage:(UIImage *)shadow;
@end

static UIView *serviceView = nil;
ZKSwizzleInterface(ZeppelinServiceItemView, UIStatusBarServiceItemView, UIView)
@implementation ZeppelinServiceItemView

-(id)_serviceContentsImage {
    serviceView = self;
    if ([ZeppelinPreview sharedInstance].isEnabled) {
        return [ZKClass(_UILegibilityImageSet)
                imageFromImage: [UIImage imageNamed:@"Dark Knight"]
                withShadowImage: [[UIImage alloc] init]];
    }
    
    return ZKOrig(id);
}

@end
*/

@implementation ZeppelinPreview

+ (instancetype)sharedInstance {
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)turnOn {
    self.enabled = YES;
    //![serviceView updateContentsAndWidth];
}

- (void)turnOff {
    self.enabled = NO;
    //![serviceView updateContentsAndWidth];
}

@end
