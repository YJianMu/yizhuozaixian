//
//  ZCtextField.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCtextField : UITextField
- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image leftImage:(UIImage *)leftimage;

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image;
@end
