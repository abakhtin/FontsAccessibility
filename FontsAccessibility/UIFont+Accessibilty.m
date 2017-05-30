//
//  UIFont+Accessibilty.m
//  FontsAccessibility
//
//  Created by Alex Bakhtin on 5/30/17.
//  Copyright © 2017 EffectiveSoft. All rights reserved.
//

#import "UIFont+Accessibilty.h"

@implementation UIFont (Accessibilty)

+ (CGFloat)fontScaleForFontSize:(CGFloat)fontSize sizeCategory:(UIContentSizeCategory)sizeCategory{
    if([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) return (fontSize + 8) / fontSize;
    if([sizeCategory isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) return (fontSize + 7) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryAccessibilityExtraLarge]) return (fontSize + 6) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryAccessibilityLarge]) return (fontSize + 5) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryAccessibilityMedium]) return (fontSize + 4) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryExtraExtraExtraLarge]) return (fontSize + 3) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryExtraExtraLarge]) return (fontSize + 2) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryExtraLarge]) return (fontSize + 1) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryLarge]) return 1.0;
    if([sizeCategory isEqualToString: UIContentSizeCategoryMedium]) return (fontSize - 1) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategorySmall]) return (fontSize - 2) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryExtraSmall]) return (fontSize - 3) / fontSize;
    if([sizeCategory isEqualToString: UIContentSizeCategoryUnspecified]) return 1.0;
    return 1.0;
}

- (UIFont *)fontWithSize:(CGFloat)size category:(UIContentSizeCategory)sizeCategory {
    return [UIFont fontWithDescriptor: self.fontDescriptor size:size * [UIFont fontScaleForFontSize:size sizeCategory:sizeCategory]];
}

@end
