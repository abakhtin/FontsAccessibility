//
//  UIControl+FontsAccessibility.m
//  FontsAccessibility
//
//  Created by Alex Bakhtin on 5/30/17.
//  Copyright © 2017 EffectiveSoft. All rights reserved.
//

#import "UIControl+FontsAccessibility.h"
#import "UIFont+Accessibilty.h"
#import <objc/runtime.h>

@interface OnDeallocCallback : NSObject
@property (nonatomic, copy) void(^deallocBlock)();
@end

@implementation OnDeallocCallback

- (id)initWithBlock:(void(^)())block {
    self = [super init];
    if (self) {
        self.deallocBlock = block;
    }
    return self;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
}

@end


@interface UIView()
@property(nonatomic, assign) CGFloat initialPointSize;
@end

@implementation UIView(FontsAccessibility)

static void* initialPointSizeKey = &initialPointSizeKey;
static void* automaticalyAdjustFontsForAccessibilityKey = &automaticalyAdjustFontsForAccessibilityKey;

- (CGFloat)initialPointSize {
    return [objc_getAssociatedObject(self, initialPointSizeKey) floatValue];
}

- (void)setInitialPointSize:(CGFloat)initialPointSize {
    objc_setAssociatedObject(self, initialPointSizeKey, @(initialPointSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)automaticalyAdjustFontsForAccessibility {
    return [objc_getAssociatedObject(self, automaticalyAdjustFontsForAccessibilityKey) boolValue];
}

- (void)setAutomaticalyAdjustFontsForAccessibility:(BOOL)automaticalyAdjustFontsForAccessibility {
    self.initialPointSize = self.getInitialPointSize;
    objc_setAssociatedObject(self, automaticalyAdjustFontsForAccessibilityKey, @(automaticalyAdjustFontsForAccessibility), OBJC_ASSOCIATION_ASSIGN);

    __weak typeof(self) weakSelf = self;
    void(^observerBlock)(NSNotification *note) = ^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
        UIFont *font = [strongSelf.currentFont fontWithSize:strongSelf.initialPointSize category:UIApplication.sharedApplication.preferredContentSizeCategory];
        [self adjustAccessibilityFont:font];
    };
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:observerBlock];
    observerBlock(nil);

    OnDeallocCallback *block = [[OnDeallocCallback alloc] initWithBlock:^{
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    objc_setAssociatedObject(self, (__bridge void *)(@"OnDeallocCallback"), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)adjustAccessibilityFont:(UIFont *)font {
    NSAssert(NO, @"Should be overriden in subclass");
}

- (CGFloat)getInitialPointSize {
    NSAssert(NO, @"Should be overriden in subclass");
    return 0.0;
}

- (UIFont *)currentFont {
    NSAssert(NO, @"Should be overriden in subclass");
    return nil;
}

@end


@implementation UILabel (FontsAccessibility)

@dynamic automaticalyAdjustFontsForAccessibility;


- (void)adjustAccessibilityFont:(UIFont *)font {
    self.font = font;
}

- (CGFloat)getInitialPointSize {
    return self.font.pointSize;
}

- (UIFont *)currentFont {
    return self.font;
}

@end


@implementation UIButton (FontsAccessibility)

@dynamic automaticalyAdjustFontsForAccessibility;

- (void)adjustAccessibilityFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (CGFloat)getInitialPointSize {
    return self.titleLabel.font.pointSize;
}

- (UIFont *)currentFont {
    return self.titleLabel.font;
}

@end


@implementation UITextField (FontsAccessibility)

@dynamic automaticalyAdjustFontsForAccessibility;

- (void)adjustAccessibilityFont:(UIFont *)font {
    self.font = font;
}

- (CGFloat)getInitialPointSize {
    return self.font.pointSize;
}

- (UIFont *)currentFont {
    return self.font;
}

@end
