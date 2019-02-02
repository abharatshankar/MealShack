//
//  UILabel+SOXGlowAnimation.m
//  Glowing-Label
//
//  Created by Daniele Spagnolo on 18/02/2014.
//  Copyright (c) 2014 SpagOSX. All rights reserved.
//

#import "UILabel+SOXGlowAnimation.h"

@implementation UILabel (SOXGlowAnimation)

- (void)addGlowEffectWithWidth:(CGFloat)width duration:(CGFloat)duration {
    
    static CGFloat labelTransparency = 0.5;
    
    CGFloat labelWidth = self.frame.size.width;
    
    // Size of the glow, left/transparent - middle/solid - right/transparent
    CGFloat glowSize = width / labelWidth;
    
    // Starting portion of the label on which to apply the glow
    NSArray *startingLocations = @[[NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:(glowSize / 2)],
                                [NSNumber numberWithFloat:glowSize]];
    
    // Anding portion of the label on which to apply the glow
    NSArray *endingLocations = @[[NSNumber numberWithFloat:(1.0f - glowSize)],
                              [NSNumber numberWithFloat:(1.0f - (glowSize / 2))],
                              [NSNumber numberWithFloat:1.0f]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    
    
    CAGradientLayer *glowMask = [CAGradientLayer layer];
    glowMask.frame = self.bounds;

    // this is really used only to get the correct transparency
    UIColor *gradient = [UIColor colorWithWhite:0.5 alpha:labelTransparency];

    glowMask.colors = @[(id)gradient.CGColor, (id)[UIColor whiteColor].CGColor, (id)gradient.CGColor];
    glowMask.locations = startingLocations;
    glowMask.startPoint = CGPointMake(0 - (glowSize * 2), 1);
    glowMask.endPoint = CGPointMake(1 + glowSize, 1);
    
    self.layer.mask = glowMask;
    
    animation.fromValue = startingLocations;
    animation.toValue = endingLocations;
    animation.repeatCount = HUGE_VALF; // this is "infinite repeat"
    animation.duration  = duration;
    
    [glowMask addAnimation:animation forKey:@"gradientAnimation"];
}

@end
