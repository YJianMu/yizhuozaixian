//
//  suggestionViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/21.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "suggestionViewController.h"

#import "CheckEmailNumber.h"
#import <MessageUI/MessageUI.h>

@interface suggestionViewController () <UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic,strong) SuggestionView *suggesttionview;

@property (nonatomic ,strong)UITextView *suggestionTextField;
@property (nonatomic,strong) ZCtextField *emailTextField;
@property (nonatomic,strong) UIButton *sendbutton;
@property (nonatomic,strong) UILabel *firstLabel;
@property (nonatomic,strong) UILabel *secondLabel;

@end

@implementation suggestionViewController

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"我们希望听到您的意见和建议" andTextFont:13 andTextAlignment:NSTextAlignmentLeft];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 20+10+10+0.3*ScreenHeight +10, ScreenWidth - 40, 20) andBackgroundColor:nil andText:@"请留下您的邮箱" andTextFont:13 andTextAlignment:NSTextAlignmentLeft];
       
    }
    return _secondLabel;
}

- (UITextView *)suggestionTextField{
    if (!_suggestionTextField) {
        _suggestionTextField = [[UITextView alloc]initWithFrame:CGRectMake(20, 20+20, ScreenWidth - 40, 0.3*ScreenHeight)];
        //_suggestionTextField.delegate = self;
        _suggestionTextField.font = [UIFont systemFontOfSize:14.0];
        _suggestionTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _suggestionTextField.layer.borderWidth = 1;
        _suggestionTextField.layer.cornerRadius = 6;
        _suggestionTextField.layer.masksToBounds = YES;
    }
    return _suggestionTextField;
}

- (ZCtextField *)emailTextField{
    if (!_emailTextField) {
        _emailTextField = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 20+10+10+0.3*ScreenHeight +10+10+10, ScreenWidth - 40, 0.1*ScreenWidth) placeholder:nil backGroundImage:nil];
        _emailTextField.font = [UIFont systemFontOfSize:14.0];
        _emailTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _emailTextField.layer.borderWidth = 1;
        _emailTextField.layer.cornerRadius = 6;
        _emailTextField.layer.masksToBounds = YES;
    }
    return _emailTextField;
}

- (UIButton *)sendbutton{
    if (!_sendbutton) {
        _sendbutton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0.75 * ScreenWidth - 20, 20+10+10+0.3*ScreenHeight +10+10+10 +0.1*ScreenWidth +10, 0.25 * ScreenWidth, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"发送" andTextColor:nil andTextFont:nil andTarget:self andSelector:@selector(clickBtn:)];
        _sendbutton.layer.cornerRadius = 10.0;
    }
    return _sendbutton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBar.tintColor = nil;
//    self.navigationController.navigationBar.translucent = NO;
    //self.suggesttionview.delegate = self;
    
    //self.suggesttionview = [[SuggestionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.firstLabel];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.suggestionTextField];
    [self.view addSubview:self.secondLabel];
    [self.view addSubview:self.sendbutton];
    self.emailTextField.delegate = self;
    //self.suggestionTextField.delegate = self;

        
        
//    [self.view addSubview:self.suggesttionview];
    
    
    
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
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height +216 +10);
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

//#warning TODO
//-(void)sendBtn:(UIButton *)sender andfirstTextView:(UITextView *)firstTextView andsecondTextField:(UITextField *)secondTextField{
//   
//            NSMutableDictionary *param = [NSMutableDictionary dictionary];
//            [param setObject:firstTextView.text forKey:@""];
//            [param setObject:secondTextField.text forKey:@""];
//        #warning TODO 获取登录
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        
//            [manager POST:@"" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [self popoverPresentationController];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                //[self.navigationController popViewControllerAnimated:YES];
//                NSLog(@"shibai");
//                NSLog(@"%@",error);
//                
//            }];
//     }




-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.suggestionTextField resignFirstResponder];
}



#warning TODO
-(void)clickBtn:(UIButton *)sender{
    
//发post请求给服务器
    if (![CheckEmailNumber isEmailNumber:self.emailTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"邮箱错误"];
    }else if (self.emailTextField.text.length == 0 || self.suggestionTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"不能为空"];
    }else{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
    [param setObject:self.suggestionTextField.text forKey:@"content"];
    [param setObject:self.emailTextField.text forKey:@"email"];
        
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        param[@"time"] = time;
        param[@"sign"] = [NSString stringWithFormat:@"proposal%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_emailTextField.text,_suggestionTextField.text].md5String;
        

        
        
        

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        __weak suggestionViewController *weakself = self;
    [manager POST:suggestionURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id json =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
        if ([json[@"info"] isEqualToString:@"n002"]) {
            [SVProgressHUD showErrorWithStatus:@"提交失败,请重试"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"提交成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"%@",error);
    }];
    }
}


//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.y = 64;
//        self.view.frame = frame;
//    }];
//    return YES;
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    CGFloat offset = self.view.frame.size.height - (textView.frame.origin.y + textView.frame.size.height +216 +10);
//    if (offset <= 0) {
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect frame = self.view.frame;
//            frame.origin.y = offset;
//            self.view.frame = frame;
//        }];
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
