//
//  changepasswordViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/15.
//  Copyright © 2016年 xincedong. All rights reserved.
//  修改密码控制器

#import "changepasswordViewController.h"
//#import "ChangePassWordView.h"
#import "NSString+Hash.h"


@interface changepasswordViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic,strong) ChangePassWordView *changepassrordview;
@property (nonatomic,strong) ZCtextField *oldPassword;
@property (nonatomic,strong) ZCtextField *FirstPassword;
@property (nonatomic,strong) ZCtextField *SecondPassword;
@property (nonatomic,strong) UILabel *firstlabel;
@property (nonatomic,strong) UILabel *secondlabel;
@property (nonatomic,strong) UIButton *sendbutton;

@end

@implementation changepasswordViewController

-(ZCtextField *)oldPassword{
    if (!_oldPassword) {
        _oldPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"请输入旧密码" backGroundImage:nil];
        _oldPassword.secureTextEntry = YES;
        _oldPassword.font = [UIFont systemFontOfSize:14.0];
        _oldPassword.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _oldPassword.layer.borderWidth = 1;
        _oldPassword.layer.cornerRadius = 6;
        _oldPassword.layer.masksToBounds = YES;
    }
    return _oldPassword;
}
- (ZCtextField *)FirstPassword{
    if (!_FirstPassword) {
        _FirstPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.1*ScreenWidth +10, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"请输入新密码" backGroundImage:nil];
        _FirstPassword.secureTextEntry = YES;
        _FirstPassword.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _FirstPassword.font = [UIFont systemFontOfSize:14.0];
        _FirstPassword.layer.borderWidth = 1;
        _FirstPassword.layer.cornerRadius = 6;
        _FirstPassword.layer.masksToBounds = YES;
    }
    return _FirstPassword;
}
-(ZCtextField *)SecondPassword{
    if (!_SecondPassword) {
        _SecondPassword = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.2*ScreenWidth +10+10+10, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:@"确认新密码" backGroundImage:nil];
        _SecondPassword.secureTextEntry = YES;
        _SecondPassword.font = [UIFont systemFontOfSize:14.0];
        _SecondPassword.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _SecondPassword.layer.borderWidth = 1;
        _SecondPassword.layer.cornerRadius = 6;
        _SecondPassword.layer.masksToBounds = YES;
    }
    return _SecondPassword;
}


-(UILabel *)firstlabel{
    if (!_firstlabel) {
        _firstlabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +10+10, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"1.新密码必须与旧密码不同" andTextFont:13 andTextAlignment:1];
    }
    return _firstlabel;
}

- (UILabel *)secondlabel{
    if (!_secondlabel) {
        _secondlabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10+10+10, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"2.英文字母区分大小写" andTextFont:13 andTextAlignment:1];
    }
    return _secondlabel;
}

- (UIButton *)sendbutton{
    if (!_sendbutton) {
        _sendbutton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(20, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10 +20 +20+10+10+10, ScreenWidth * 0.2, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"发送" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(clickButton:)];
        
        _sendbutton.layer.cornerRadius = 10.0;
        _sendbutton.center = CGPointMake(ScreenWidth/2, 0.1*ScreenHeight + 10+0.3*ScreenWidth +10 +10 +20 + 10 +20 +20+10+10+10);
    }
    return _sendbutton;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.oldPassword];
    [self.view addSubview:self.FirstPassword];
    [self.view addSubview:self.SecondPassword];
    [self.view addSubview:self.firstlabel];
    [self.view addSubview:self.secondlabel];
    [self.view addSubview:self.sendbutton];
    self.oldPassword.delegate = self;
    self.FirstPassword.delegate =self;
    self.SecondPassword.delegate = self;
   
//    self.changepassrordview.delegate = self;
//    self.changepassrordview = [[ChangePassWordView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [self.view addSubview:self.changepassrordview];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    
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
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(dismissLeft)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height +216 +50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        self.view.frame = frame;
    }];
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)clickButton:(UIButton *)sender{
    if (self.oldPassword.text == nil || self.FirstPassword.text == nil || self.SecondPassword.text == nil) {
        [SVProgressHUD showInfoWithStatus:@"不能为空"];
    }else if (![self.FirstPassword.text isEqualToString:self.SecondPassword.text]){
        [SVProgressHUD showErrorWithStatus:@"新密码不一致"];
    }else{
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
        [param setObject:_oldPassword.text.md5String forKey:@"primarypass"];
        [param setObject:_SecondPassword.text.md5String forKey:@"newpass"];
        param[@"time"] = time;
        param[@"sign"] = [NSString stringWithFormat:@"repassword%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_SecondPassword.text.md5String,_oldPassword.text.md5String].md5String;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSLog(@"%@",param);
        [manager POST:changepassword parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",json);
            if ([json[@"info"] isEqualToString:@"u010"]) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }else if([json[@"info"] isEqualToString:@"u011"]){
                [SVProgressHUD showErrorWithStatus:@"旧密码不正确"];
            }else if([json[@"info"] isEqualToString:@"u009"]){
                [SVProgressHUD showInfoWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showInfoWithStatus:@"第三方登录不能修改密码"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
           
        }];
    }

}



//-(void)changepasswordView:(ChangePassWordView *)changepasswordView andoldPassword:(ZCtextField *)oldPassword andFirstPassword:(ZCtextField *)FirstPassword andSecondPassword:(ZCtextField *)SecondPassword andbutton:(UIButton *)sender{
//    NSLog(@"shibai");

//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:oldPassword.text forKey:@""];
//    [param setObject:SecondPassword.text forKey:@""];
//#warning TODO 获取登录
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:@"" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self popoverPresentationController];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //[self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"shibai");
//        NSLog(@"%@",error);
//        
//    }];

//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
