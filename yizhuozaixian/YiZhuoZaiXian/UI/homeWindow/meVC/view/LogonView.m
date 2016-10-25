//
//  LogonView.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "LogonView.h"
#import "CheckPhoneNumber.h"

@interface LogonView ();
@property (nonatomic,strong) UITextField *numbertextfield;
@property (nonatomic,strong) UITextField *codetextfielf;
@property (nonatomic,strong) UITextField *passwordtextfield;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *huoquBtn;
@property (nonatomic,strong) UIButton *dengluBtn;

@end

@implementation LogonView

- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews{
    _numbertextfield = [[ZCtextField alloc]initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06 * ScreenHeight, 0.8 * ScreenWidth, 0.1 *ScreenWidth) placeholder:@"请输入手机号" backGroundImage:nil leftImage:[UIImage imageNamed:@"icon_login"]];
    _numbertextfield.backgroundColor = [UIColor redColor];
    _numbertextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    
    _codetextfielf = [[ZCtextField alloc]initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15, 0.35*ScreenWidth, 0.1 * ScreenWidth) placeholder:@"请输入验证码" backGroundImage:nil leftImage:[UIImage imageNamed:@"icon_login"]];
    
    _codetextfielf.backgroundColor = [UIColor redColor];
    _codetextfielf.keyboardType = UIKeyboardTypeNumberPad;
    
    _huoquBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0.55 *ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15, 0.35*ScreenWidth, 0.1 * ScreenWidth)andBackgroundColor:[UIColor redColor] andText:@"获取验证码" andTextColor:nil andTextFont:nil andTarget:self andSelector:@selector(buttonClicked:)];
    _huoquBtn.tag = 0;
    _huoquBtn.layer.cornerRadius = 10.0;
    
    _passwordtextfield = [[ZCtextField alloc] initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15+15+0.1*ScreenWidth, 0.8*ScreenWidth, 0.1*ScreenWidth) placeholder:@"请输入登录密码" backGroundImage:nil leftImage:[UIImage imageNamed:@"icon_login"]];
    _passwordtextfield.backgroundColor = [UIColor redColor];
    _passwordtextfield.secureTextEntry = YES;
    
    _dengluBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15+15+0.1*ScreenWidth+15+0.1*ScreenWidth, 0.8*ScreenWidth, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"注册" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(buttonClicked:)];
    _dengluBtn.tag = 1;
    _dengluBtn.layer.cornerRadius = 10.0;

    
    [self addSubview:self.numbertextfield];
    [self addSubview:self.codetextfielf];
    [self addSubview:self.label];
    [self addSubview:self.passwordtextfield];
    [self addSubview:self.dengluBtn];
    [self addSubview:self.huoquBtn];

}

//注销键盘
- (void)resignKeyboard
{
    [self.numbertextfield resignFirstResponder];
    [self.codetextfielf resignFirstResponder];
    [self.passwordtextfield resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)sender
{
    [self resignKeyboard];
    
    switch (sender.tag) {
            
        case 0: //点击获取验证码按钮
            [self.delegate LogonView:self LogonViewButton:sender
                                     model:modelhuoqu
                                numbertext:self.numbertextfield.text
                                  codetext:self.codetextfielf.text];
            
            //检测电话号码合法性
            if (![CheckPhoneNumber isMobileNumber:self.numbertextfield.text]) {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的号码有误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                sender.enabled = NO;
            }
            break;
            
        case 1: //点击登录按钮
            
            if (self.numbertextfield.text.length == 0 || self.passwordtextfield.text.length == 0 || self.codetextfielf.text.length == 0) {
                sender.enabled = NO;
            }else{
            [self.delegate LogonView:self
                                              LogonViewButton:sender
                                                        model:modeldenglu
                                                   numbertext:self.numbertextfield.text
                                                     password:self.passwordtextfield.text];
            }
            
            
            break;
        
        default:
            break;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordtextfield resignFirstResponder];
    [self.numbertextfield resignFirstResponder];
    [self.codetextfielf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
