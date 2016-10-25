//
//  ChangePassWordView.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ChangePassWordView.h"

@interface ChangePassWordView ();


@property (nonatomic,strong) ZCtextField *oldPassword;
@property (nonatomic,strong) ZCtextField *FirstPassword;
@property (nonatomic,strong) ZCtextField *SecondPassword;

@end

@implementation ChangePassWordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews{
    self.oldPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"" backGroundImage:nil leftImage:nil];
    self.oldPassword.backgroundColor = [UIColor greenColor];
    [self addSubview:self.oldPassword];
    
    
    self.FirstPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.1*ScreenWidth +10, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"" backGroundImage:nil leftImage:nil];
    self.FirstPassword.backgroundColor = [UIColor greenColor];
    [self addSubview:self.FirstPassword];
    
    self.SecondPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.2*ScreenWidth +10+10+10, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"" backGroundImage:nil leftImage:nil];
    self.SecondPassword.backgroundColor = [UIColor greenColor];
    [self addSubview:self.SecondPassword];
    
    UILabel *firstlabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +10+10, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"1.新密码必须与旧密码不同" andTextFont:13 andTextAlignment:1];
    [self addSubview:firstlabel];
    
    UILabel *secondlabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10+10+10, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"2.请输入6到18位数的密码，英文字母区分大小写" andTextFont:13 andTextAlignment:1];
    [self addSubview:secondlabel];
    
    UIButton *button = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10 +20 +20+10+10+10, ScreenWidth * 0.2, 0.1*ScreenWidth) andBackgroundColor:[UIColor greenColor] andText:@"发送" andTextColor:[UIColor blueColor] andTextFont:nil andTarget:self andSelector:@selector(clickButton:)];
    button.center = CGPointMake(ScreenWidth/2, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10 +20 +20+10+10+10);
    
    [self addSubview:button];
    
}

- (void)clickButton:(UIButton *)sender{
    [self.delegate changepasswordView:self andoldPassword:self.oldPassword andFirstPassword:self.FirstPassword andSecondPassword:self.SecondPassword andbutton:sender];
}



@end
