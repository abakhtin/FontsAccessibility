//
//  UIFont+Accessibilty.h
//  FontsAccessibility
//
//  Created by Alex Bakhtin on 5/30/17.
//  Copyright © 2017 EffectiveSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Accessibilty)

/// The font scale for a given font size.
///
/// - seealso: [Source](https://stackoverflow.com/a/33114525/3643020)
///
/// - Parameter fontSize: The font size.
/// - Returns: The font scale
+ (CGFloat)fontScaleForFontSize:(CGFloat)fontSize sizeCategory:(UIContentSizeCategory)sizeCategory;
- (UIFont *)fontWithSize:(CGFloat)size category:(UIContentSizeCategory)sizeCategory;

@end
