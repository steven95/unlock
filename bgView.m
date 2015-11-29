//
//  bgView.m
//  手势解锁
//
//  Created by Jusive on 15/11/27.
//  Copyright © 2015年 Jusive. All rights reserved.
//

#import "bgView.h"

@implementation bgView


- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"Home_refresh_bg"];
    [image drawInRect:rect];
}


@end
