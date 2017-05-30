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

@interface UILabel()
@property(nonatomic, assign) CGFloat initialPointSize;
@end

@implementation UILabel (FontsAccessibility)

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
    self.initialPointSize = self.font.pointSize;
    objc_setAssociatedObject(self, automaticalyAdjustFontsForAccessibilityKey, @(automaticalyAdjustFontsForAccessibility), OBJC_ASSOCIATION_ASSIGN);

    __weak typeof(self) weakSelf = self;
    void(^observerBlock)(NSNotification *note) = ^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.font = [strongSelf.font fontWithSize:strongSelf.initialPointSize category:UIApplication.sharedApplication.preferredContentSizeCategory];
    };
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:observerBlock];
    observerBlock(nil);

    OnDeallocCallback *block = [[OnDeallocCallback alloc] initWithBlock:^{
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    objc_setAssociatedObject(self, (__bridge void *)(@"OnDeallocCallback"), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
