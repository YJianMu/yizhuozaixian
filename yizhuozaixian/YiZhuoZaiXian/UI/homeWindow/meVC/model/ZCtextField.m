//
//  ZCtextField.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ZCtextField.h"

@implementation ZCtextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image leftImage:(UIImage *)leftimage
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.placeholder = placeholder;
        self.background = image;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftView = [[UIImageView alloc]initWithImage:leftimage];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView.frame = CGRectMake(0, 0, 40, 20);
        self.textColor = [UIColor whiteColor];
        
        
        //self.leftView.contentMode = UIViewContentModeCenter;
        self.font = [UIFont systemFontOfSize:18];
        [self.layer setShadowOffset:CGSizeMake(15, 15)];
        self.layer.cornerRadius = 10;
        //[self.layer setShadowRadius:10];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder backGroundImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.placeholder = placeholder;
        self.background = image;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:18];
        [self.layer setShadowOffset:CGSizeMake(15, 15)];
        self.layer.cornerRadius = 10;
    }
        return self;
}


@end
