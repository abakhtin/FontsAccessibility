//
//  UIControl+FontsAccessibility.h
//  FontsAccessibility
//
//  Created by Alex Bakhtin on 5/30/17.
//  Copyright © 2017 EffectiveSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(FontsAccessibility)
- (void)adjustAccessibilityFont:(UIFont *)font;
- (CGFloat)getInitialPointSize;
- (UIFont *)currentFont;
@end

@interface UILabel (FontsAccessibility)
@property(nonatomic, assign) IBInspectable BOOL automaticalyAdjustFontsForAccessibility;
@end

@interface UIButton (FontsAccessibility)
@property(nonatomic, assign) IBInspectable BOOL automaticalyAdjustFontsForAccessibility;
@end

@interface UITextField (FontsAccessibility)
@property(nonatomic, assign) IBInspectable BOOL automaticalyAdjustFontsForAccessibility;
@end
