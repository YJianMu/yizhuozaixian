//
//  ChangenameController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ChangenameController.h"

@interface ChangenameController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) ZCtextField *nameTextField;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *savebutton;

@end

@implementation ChangenameController

- (ZCtextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[ZCtextField alloc]initWithFrame:CGRectMake(20, 60, ScreenWidth - 40, 0.1 * ScreenWidth) placeholder:nil backGroundImage:nil];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.delegate = self;
        _nameTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _nameTextField.layer.borderWidth = 1;
        _nameTextField.layer.cornerRadius = 6;
        _nameTextField.layer.masksToBounds = YES;
    }
    return _nameTextField;
}
-(UILabel *)label{
    if (!_label) {
        _label = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, 20 + 0.1 * ScreenHeight+30, ScreenWidth, 20) andBackgroundColor:[UIColor whiteColor] andText:@"最多5个字符，可由中英文、数字、“-”、“_”组成" andTextFont:13 andTextAlignment:1];
    }
    return _label;
}

-(UIButton *)savebutton{
    if (!_savebutton) {
        _savebutton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(20, 20+0.1*ScreenHeight+20+20+40, ScreenWidth - 40, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"保存" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(clickSaveButton:)];
        _savebutton.layer.cornerRadius = 10.0;
    }
    return _savebutton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.savebutton];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.label];
    
    
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



- (void)clickSaveButton:(UIButton *)sender{
    
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"不能为空"];
    }else{
    
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
        [param setObject:self.nameTextField.text forKey:@"nickname"];
        param[@"time"] = time;
        param[@"sign"] = [NSString stringWithFormat:@"mUser%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_nameTextField.text].md5String;
    
        [manager POST:ChangeDataURLString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGENAME" object:nil userInfo:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
            NSLog(@"%@",error);
        }];
    
    }
    //self.nameBlock(self.nameTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"点击了修改昵称按钮");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameTextField resignFirstResponder];
}



@end
