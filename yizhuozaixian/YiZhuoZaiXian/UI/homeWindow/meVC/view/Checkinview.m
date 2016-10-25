//
//  Checkinview.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/17.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "Checkinview.h"


@interface Checkinview () <UITextFieldDelegate>;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UITextField *secretTextField;

- (void)configureSubviews;
@end

@implementation Checkinview

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        if (self) {
            self.frame = [UIScreen mainScreen].bounds;
            self.userInteractionEnabled = YES;
            self.contentMode = UIViewContentModeScaleAspectFill;
            [self configureSubviews];
        }
    }
    return self;
}


- (void)configureSubviews{
    
    self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0.22*ScreenHeight,ScreenWidth, 0.1 * ScreenWidth + 0.015 * ScreenHeight - 0.5)];
    self.numberTextField.placeholder = @"请输入您的帐号";
    self.numberTextField.background = [UIImage imageNamed:@"login_input"];
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.delegate = self;
    self.numberTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_user_n"]];
    self.numberTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.numberTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.numberTextField];
    
    
    self.secretTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0.22*ScreenHeight + 0.015*ScreenHeight + 0.1 * ScreenWidth +0.5, ScreenWidth, 0.1 * ScreenWidth + 0.015 * ScreenHeight)];
    self.secretTextField.placeholder = @"请输入您的密码";
    self.secretTextField.background = [UIImage imageNamed:@"login_input"];
    self.secretTextField.delegate = self;
    self.secretTextField.secureTextEntry = YES;
    self.secretTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password_n"]];
    self.secretTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.secretTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:self.secretTextField];
    
    
//    self.numberTextField = [[ZCtextField alloc]initWithFrame:CGRectMake(0.05*ScreenWidth, 0.22*ScreenHeight,0.9 * ScreenWidth, 0.1 * ScreenWidth) placeholder:@"请输入您的帐号" backGroundImage:[UIImage imageNamed:@"login_input"] leftImage:[UIImage imageNamed:@"icon_loginfirst"]];
//    [self.numberTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    //[self.numberTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//    _numberTextField.delegate = self;
//    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
//    //self.numberTextField.backgroundColor = [UIColor blueColor];
//    
//    [self addSubview:self.numberTextField];
//    
//    self.secretTextField = [[ZCtextField alloc]initWithFrame:CGRectMake(0.05*ScreenWidth, 0.22*ScreenHeight + 0.03*ScreenHeight + 0.1 * ScreenWidth, 0.9 * ScreenWidth, 0.1 * ScreenWidth) placeholder:@"请输入您的密码" backGroundImage:[UIImage imageNamed:@"login_input"] leftImage:[UIImage imageNamed:@"icon_passwordfirst"]];
//    [self.secretTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    //[self.secretTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//    self.secretTextField.delegate = self;
//    self.secretTextField.secureTextEntry = YES;
//   
//    //self.secretTextField.backgroundColor = [UIColor blueColor];
//    [self addSubview:self.secretTextField];
    
    
    UIButton *checkinBtn = [UIButton buttonWithType:0];
    checkinBtn.frame = CGRectMake(0.1*ScreenWidth,0.22*ScreenHeight + 0.03*ScreenHeight +0.1 * ScreenWidth + 0.03*ScreenHeight+0.1 * ScreenWidth,0.8*ScreenWidth,0.1 * ScreenWidth);
    [checkinBtn setBackgroundImage:[UIImage imageNamed:@"new_btn_exp_n"] forState:UIControlStateNormal];
    [checkinBtn setBackgroundImage:[UIImage imageNamed:@"new_btn_exp_s"] forState:UIControlStateHighlighted];
    //checkinBtn.backgroundColor = [UIColor purpleColor];
    checkinBtn.layer.cornerRadius = 10.0;
    [checkinBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    
    [checkinBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    checkinBtn.tag = 4;
    [self addSubview:checkinBtn];

    UIButton *logonBtn = [UIButton buttonWithType:0];
    logonBtn.frame = CGRectMake(0.1*ScreenWidth,0.22*ScreenHeight + 0.03*ScreenHeight +0.1 * ScreenWidth + 0.06*ScreenHeight+0.2 * ScreenWidth ,0.8*ScreenWidth,0.1 * ScreenWidth);
    //logonBtn.backgroundColor = [UIColor whiteColor];
    logonBtn.layer.cornerRadius = 10.0;
    [logonBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [logonBtn setTitle:@"没有帐号？免费注册" forState:UIControlStateNormal];
    
    [logonBtn setTitleColor:[UIColor colorWithHexString:@"#ff1800"] forState:UIControlStateNormal];

    [logonBtn setBackgroundImage:[UIImage imageNamed:@"login_case"] forState:UIControlStateNormal];
    //[logonBtn setBackgroundImage:[UIImage imageNamed:@"log in"] forState:UIControlStateHighlighted];
    logonBtn.tag = 1;
    [self addSubview:logonBtn];
    
    UIButton *ForgotpasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.9*ScreenWidth - 100, 0.22*ScreenHeight + 0.03*ScreenHeight +0.1 * ScreenWidth + 0.06*ScreenHeight+0.2 * ScreenWidth +10 + 0.1 * ScreenWidth, 100, 20)];
    [ForgotpasswordBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [ForgotpasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [ForgotpasswordBtn setTitleColor:[UIColor colorWithHexString:@"#ff1800"] forState:UIControlStateNormal];
    ForgotpasswordBtn.contentHorizontalAlignment = 2;
    ForgotpasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    ForgotpasswordBtn.tag = 5;
    [self addSubview:ForgotpasswordBtn];
    

    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.84*ScreenHeight, ScreenWidth, 20)];
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.text = @"————————第三方登录————————";
    lable.textColor = [UIColor colorWithHexString:@"#666666"];
    lable.textAlignment = 1;
    [self addSubview:lable];
   
    
    UIButton *weixinBtn = [UIButton buttonWithType:0];
    weixinBtn.frame = CGRectMake(0.1 * ScreenWidth,0.9 * ScreenHeight ,0.35*ScreenWidth,0.1 * ScreenWidth);
    //weixinBtn.backgroundColor = [UIColor purpleColor];
    weixinBtn.layer.cornerRadius = 10.0;
    //weixinBtn.titleLabel.text = @"微信登录";
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_wechat_n"] forState:UIControlStateNormal];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_wechat_s"] forState:UIControlStateHighlighted];
    [weixinBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    weixinBtn.tag = 2;
    [self addSubview:weixinBtn];
    
    
    UIButton *qqBtn = [UIButton buttonWithType:0];
    qqBtn.frame = CGRectMake(0.55*ScreenWidth, 0.9*ScreenHeight, 0.35*ScreenWidth, 0.1 * ScreenWidth);
    //qqBtn.backgroundColor = [UIColor purpleColor];
    qqBtn.layer.cornerRadius = 10.0;
    //qqBtn.titleLabel.text = @"QQ登录";
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_qq_n"] forState:UIControlStateNormal];
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_qq_s"] forState:UIControlStateHighlighted];
    [qqBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    qqBtn.tag = 3;
    [self addSubview:qqBtn];
}


#pragma mark - 响应事件 -

- (void)buttonClicked:(UIButton *)sender
{
    switch (sender.tag) {
//        case 0://返回按钮
//            [self.delegate checkinView:self backButtonClicked:sender];
//            break;
        case 1://注册按钮
            [self.delegate checkinView:self checkinButtonClicked:sender checkinMode:XCDCheckinModelLogon];
            break;
        case 2://微信按钮
            [self.delegate checkinView:self checkinButtonClicked:sender checkinMode:XCDCheckinModelWeixin];
            break;
        case 3://QQ按钮
            [self.delegate checkinView:self checkinButtonClicked:sender checkinMode:XCDCheckinModelQQ];
            break;
        case 4://立即登录
            [self.delegate checkinView:self checkinButtonClicked:sender numberText:self.numberTextField.text secretText:self.secretTextField.text];
            break;
        case 5:
            [self.delegate clickForgotPassWord];
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)resignKeyboard
{
    [self.secretTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
}


@end
