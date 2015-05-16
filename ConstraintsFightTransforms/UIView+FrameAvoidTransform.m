//
//  UIView+FrameAvoidTransform.m
//  ConstraintsFightTransforms
//
//  Created by Anton Bukov on 16.05.15.
//  Copyright (c) 2015 Itty Bitty Apps. All rights reserved.
//

#import <JRSwizzle/JRSwizzle.h>
#import "UIView+FrameAvoidTransform.h"

@implementation UIView (FrameAvoidTransform)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView jr_swizzleMethod:@selector(frame) withMethod:@selector(xxx_frame) error:NULL];
        [UIView jr_swizzleMethod:@selector(setFrame:) withMethod:@selector(xxx_setFrame:) error:NULL];
    });
}

- (CGRect)xxx_frame
{
    return CGRectOffset(self.bounds,
                        self.center.x-CGRectGetWidth(self.bounds)/2,
                        self.center.y-CGRectGetHeight(self.bounds)/2);
}

- (void)xxx_setFrame:(CGRect)frame
{
    self.bounds = (CGRect){CGPointZero,frame.size};
    self.center = CGPointMake(CGRectGetMidX(frame),
                              CGRectGetMidY(frame));
    
}

- (CGRect)transformedFrame
{
    return CGRectApplyAffineTransform(self.frame, self.transform);
}

@end
