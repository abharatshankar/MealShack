//
//  UILabel+SOXGlowAnimation.h
//  Glowing-Label
//
//  Created by Daniele Spagnolo on 18/02/2014.
//  Copyright (c) 2014 SpagOSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SOXGlowAnimation)

/**
 * Creates and animates a CAGradientLayer placing it on a UILabel.
 *
 * @param width The size in width of the "glow"
 *
 * @param duration The duration of the animation. The actual velocity of the gradient is obtained by rapporting duration in seconds with gradient width and label width.
 *
 */
- (void)addGlowEffectWithWidth:(CGFloat)width duration:(CGFloat)duration;

@end
