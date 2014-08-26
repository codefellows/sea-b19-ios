//
//  UIViewController+RandomBackgroundColor.m
//  Equality
//
//  Created by John Clem on 8/26/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

#import "UIViewController+RandomBackgroundColor.h"
#import <objc/objc-runtime.h>

@implementation UIViewController (RandomBackgroundColor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(random_bg_color_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)random_bg_color_viewWillAppear:(BOOL)animated {
    [self random_bg_color_viewWillAppear:animated];
    // customize viewWillAppear after this line
    [self performSelector:@selector(updateBackgroundColor) withObject:nil afterDelay:1.5];
}

- (void)updateBackgroundColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *bgColor = [UIColor colorWithHue:hue
                                  saturation:saturation
                                  brightness:brightness
                                       alpha:1];
    [UIView animateWithDuration:1.5 animations:^{
        self.view.backgroundColor = bgColor;
    } completion:^(BOOL finished) {
        if (finished) {
            [self performSelector:@selector(updateBackgroundColor) withObject:nil];
        }
    }];
}

@end
