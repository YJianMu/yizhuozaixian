//
//  LogonViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//  注册

#import "LogonViewController.h"
#import "CheckPhoneNumber.h"
#import "MZTimerLabel.h"
#import "NSString+Hash.h"
#import "ServiceDelegateViewController.h"

@interface LogonViewController ()<MZTimerLabelDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITextField *numbertextfield;
@property (nonatomic,strong) UITextField *codetextfielf;
@property (nonatomic,strong) UITextField *passwordtextfield;
@property (nonatomic,strong) UILabel *timer_show;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *huoquBtn;
@property (nonatomic,strong) UIButton *dengluBtn;
//@property (nonatomic, strong) LogonView *logonView;
@property (nonatomic,strong) NSString *identifierNumber;
@property (nonatomic,strong) UIButton *delegateBtn;
@end

@implementation LogonViewController

-(UILabel *)timer_show{
    if (!_timer_show) {
        _timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0.55 *ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15, 0.35*ScreenWidth, 0.1 * ScreenWidth)];
    }
    return _timer_show;
}

-(UITextField *)numbertextfield{
    if (!_numbertextfield) {
        _numbertextfield = [[ZCtextField alloc]initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06 * ScreenHeight, 0.8 * ScreenWidth, 0.1 *ScreenWidth) placeholder:@"请输入手机号" backGroundImage:nil];
        _numbertextfield.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _numbertextfield.layer.borderWidth = 1;
        _numbertextfield.layer.cornerRadius = 6;
        _numbertextfield.layer.masksToBounds = YES;
        _numbertextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numbertextfield;
}

-(UITextField *)codetextfielf{
    if (!_codetextfielf) {
        _codetextfielf = [[ZCtextField alloc]initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15, 0.35*ScreenWidth, 0.1 * ScreenWidth) placeholder:@"请输入验证码" backGroundImage:nil];
        
        _codetextfielf.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _codetextfielf.layer.borderWidth = 1;
        _codetextfielf.layer.cornerRadius = 6;
        _codetextfielf.layer.masksToBounds = YES;
        _codetextfielf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codetextfielf;
}

-(UIButton *)huoquBtn{
    if (!_huoquBtn) {
        _huoquBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0.55 *ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15, 0.35*ScreenWidth, 0.1 * ScreenWidth)andBackgroundColor:[UIColor redColor] andText:@"获取验证码" andTextColor:nil andTextFont:[UIFont systemFontOfSize:13.0] andTarget:self andSelector:@selector(clickhuoquBtn)];
        _huoquBtn.layer.cornerRadius = 10.0;
    }
    return _huoquBtn;
}


-(UITextField *)passwordtextfield{
    if (!_passwordtextfield) {
        _passwordtextfield = [[ZCtextField alloc] initWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15+15+0.1*ScreenWidth, 0.8*ScreenWidth, 0.1*ScreenWidth) placeholder:@"请输入登录密码" backGroundImage:nil];
        _passwordtextfield.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _passwordtextfield.layer.borderWidth = 1;
        _passwordtextfield.layer.cornerRadius = 6;
        _passwordtextfield.layer.masksToBounds = YES;
        _passwordtextfield.delegate = self;
        _passwordtextfield.secureTextEntry = YES;
    }
    return _passwordtextfield;
}

- (UIButton *)dengluBtn{
    if (!_dengluBtn) {
        _dengluBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15+15+0.1*ScreenWidth+15+0.1*ScreenWidth, 0.8*ScreenWidth, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"注册" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(clickdengluBtn)];
        _dengluBtn.layer.cornerRadius = 10.0;
    }
    return _dengluBtn;
}

- (UIButton *)delegateBtn{
    if (!_delegateBtn) {
        _delegateBtn = [MyViewCreateControl initTitleButtonWithFrame:
                        CGRectMake(0.1*ScreenWidth, 64 + 0.06*ScreenHeight + 0.1 *ScreenWidth + 15+15+0.1*ScreenWidth+15+0.1*ScreenWidth+0.1*ScreenWidth +15, 0.8*ScreenWidth, 15)
                                                  andBackgroundColor:nil
                                                             andText:nil
                                                        andTextColor:[UIColor blackColor]
                                                         andTextFont:[UIFont systemFontOfSize:13.0]
                                                           andTarget:self
                                                         andSelector:@selector(clickdelegateBtn)];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"《服务协议》注册代表同意协议"];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 6)];
        [_delegateBtn setAttributedTitle:attri forState:UIControlStateNormal];
        //_delegateBtn.layer.cornerRadius = 10.0;
    }
    return _delegateBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self.view addSubview:self.numbertextfield];
    [self.view addSubview:self.codetextfielf];
    [self.view addSubview:self.label];
    [self.view addSubview:self.passwordtextfield];
    [self.view addSubview:self.dengluBtn];
    [self.view addSubview:self.huoquBtn];
    [self.view addSubview:self.delegateBtn];
    
    self.identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(dismissLeft)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //全屏右划手势
    //需要获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //创建全屏滑动手势~调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    //设置手势代理~拦截手势触发
    pan.delegate = self;
    //给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    //将系统自带的滑动手势禁用
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
}
- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
}

- (void)clickdelegateBtn{
    ServiceDelegateViewController *vc = [ServiceDelegateViewController new];
    vc.title = @"服务协议";
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.huoquBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.huoquBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.huoquBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                self.huoquBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)clickhuoquBtn{
   
    
    if (![CheckPhoneNumber isMobileNumber:self.numbertextfield.text]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的号码有误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self startTime];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.numbertextfield.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                
            }else{
                
            }
        }];
    }
}


- (void)clickdengluBtn{
    __weak LogonViewController *weakself = self;

    if (self.passwordtextfield.text.length == 0 ) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请您输入密码" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }else if (self.passwordtextfield.text.length < 6 ) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度要大于六个字符" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [SMSSDK commitVerificationCode:self.codetextfielf.text phoneNumber:self.numbertextfield.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSString *password = weakself.passwordtextfield.text.md5String;
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:weakself.numbertextfield.text forKey:@"username"];
                [param setObject:password forKey:@"password"];
                [param setObject:weakself.identifierNumber forKey:@"devicesn"];
                NSLog(@"%@",param);
                
                [manager POST:RegisterURLstring parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //跳转到mecontroller
                    //注册成功做的事情
                    id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    NSLog(@"%@",json);
                    
                    if ([json[@"info"] isEqualToString:@"u001"])
                    {
                        [SVProgressHUD showInfoWithStatus:@"帐号已注册"];
                    }else if([json[@"info"] isEqualToString:@"u004"])
                    {
                        //注册成功
                        [SVProgressHUD showInfoWithStatus:@"注册成功,请登录"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"注册失败"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
                }];
                
            }else{
                
                //验证码有误判断
                [SVProgressHUD showErrorWithStatus:@"验证码有误"];
            }
        }];

    }
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.numbertextfield resignFirstResponder];
    [self.codetextfielf resignFirstResponder];
    [self.passwordtextfield resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}



@end
