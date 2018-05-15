//
//  UIView+S_Extend.m
//  gerendanche
//
//  Created by Marshal on 2017/6/20.
//  Copyright © 2017年 Mr.li. All rights reserved.
//

#import "UIView+S_Extend.h"

@implementation UIView (S_Extend)

- (void)setS_height:(CGFloat)height {
    CGRect rect = [self frame];
    rect.size.height = height;
    [self setFrame:rect];
}

- (CGFloat)s_height {
    return self.frame.size.height;
}

- (void)setS_width:(CGFloat)width {
    CGRect rect = [self frame];
    rect.size.width = width;
    [self setFrame:rect];
}

- (CGFloat)s_width {
    return self.frame.size.width;
}

- (void)setS_X:(CGFloat)x {
    CGRect rect = [self frame];
    rect.origin.x = x;
    [self setFrame:rect];
}

- (CGFloat)s_X {
    return self.frame.origin.x;
}

- (void)setS_Y:(CGFloat)y {
    CGRect rect = [self frame];
    rect.origin.y = y;
    [self setFrame:rect];
}

- (CGFloat)s_Y {
    return self.frame.origin.y;
}

- (void)setS_BY:(CGFloat)BY {
    CGRect bound = [self bounds];
    bound.origin.y = BY;
    [self setBounds:bound];
}

- (CGFloat)s_BY {
    return self.bounds.origin.y;
}

- (void)setS_BX:(CGFloat)BX {
    CGRect bound = [self bounds];
    bound.origin.x = BX;
    [self setBounds:bound];
}

- (CGFloat)s_BX {
    return self.bounds.origin.x;
}

- (CGFloat)s_bottom {
    return self.s_Y+self.s_height;
}

- (CGFloat)s_right {
    return self.s_X+self.s_width;
}

@end
