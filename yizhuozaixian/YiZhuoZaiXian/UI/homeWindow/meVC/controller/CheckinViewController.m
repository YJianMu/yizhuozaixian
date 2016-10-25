//
//  CheckinViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/17.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "CheckinViewController.h"
#import "Checkinview.h"
#import "LogonViewController.h"
#import "NSString+Hash.h"
#import "UserUIDModel.h"
#import "ForgotPasswordController.h"

@interface CheckinViewController ()<checkinViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) Checkinview *checkView;
@property (nonatomic,strong) NSString *timeLocal;
@property (nonatomic,strong) NSString *devicesn;
@property (nonatomic,strong) NSString *sign;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *nickName;

@end

@implementation CheckinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = YES;
    self.checkView = [[Checkinview alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
    self.checkView.delegate = self;
    self.devicesn = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [self.view addSubview:self.checkView];
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(dismissLeft)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    
    self.navigationItem.leftBarButtonItem = leftItem;
    //self.navigationItem.title = @"登录";
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:22.0]}];
    

    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //    导航栏变为透明
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    //self.navigationController.navigationBar.shadowImage=[UIImage new];
    
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
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (void)dismissLeft{
    if (_tayeInfrom) {
        _returnTayeBlock(YES);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}




//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//   
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)checkinView:(Checkinview *)checkinView backButtonClicked:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)checkinView:(Checkinview *)checkinView checkinButtonClicked:(UIButton *)sender numberText:(NSString *)numberText secretText:(NSString *)secretText{
    
    if (numberText.length == 0 || secretText.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不能为空"];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"登录中，请稍等"];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        self.timeLocal = [NSString stringWithFormat:@"%lld", data];
        
        NSString *token = @"72a4be6a31a136932bb0e76c94e8818c";
        self.sign = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"login",self.timeLocal,@"0",self.devicesn,token,numberText].md5String;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *password = secretText.md5String;
        
        [param setObject:@"1" forKey:@"type"];
        [param setObject:numberText forKey:@"username"];
        [param setObject:password forKey:@"password"];
        [param setObject:self.timeLocal forKey:@"time"];
        [param setObject:@"0" forKey:@"uid"];
        [param setObject:self.devicesn forKey:@"devicesn"];
        [param setObject:self.sign forKey:@"sign"];
        [param setObject:@"0" forKey:@"gender"];
        [param setObject:@"0" forKey:@"imgUrl"];
        [param setObject:@"0" forKey:@"address"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        __weak CheckinViewController *weakself = self;
        [manager POST:LoginURLstring parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            UserUIDModel *uidmodel = [UserUIDModel objectWithKeyValues:result];
            
            NSLog(@"%@  %@",uidmodel.uid,uidmodel.info);
            if ([uidmodel.info isEqualToString:@"u002"]||[uidmodel.info isEqualToString:@"u019"]) {
                [SVProgressHUD showInfoWithStatus:@"帐号不存在"];
            }else if([uidmodel.info isEqualToString:@"u003"]){
                [SVProgressHUD showInfoWithStatus:@"密码错误"];
            }else if([uidmodel.info isEqualToString:@"u006"]){
                [SVProgressHUD showInfoWithStatus:@"登录中，请稍等"];
                [UserData sharkedUser].uid = uidmodel.uid;
                [UserData sharkedUser].token = [NSString stringWithFormat:@"%@%@%@%@",uidmodel.uid,numberText,self.devicesn,uidmodel.time].md5String;
                [UserData saveData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_UID" object:nil userInfo:nil];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
            NSLog(@"%@",error);
        }];
        
    }
}



- (void)checkinView:(Checkinview *)checkinView checkinButtonClicked:(UIButton *)sender checkinMode:(checkinModel)loginMode{
    
    __weak CheckinViewController *weakself = self;
    
    if(loginMode == XCDCheckinModelLogon)
    {
        LogonViewController *vc = [LogonViewController new];
        vc.title = @"注册";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(loginMode == XCDCheckinModelQQ){
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                 NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                 NSTimeInterval a=[dat timeIntervalSince1970];
                 long long int data = (long long int)a;
                 weakself.timeLocal = [NSString stringWithFormat:@"%lld", data];
                 
                 NSString *token = @"72a4be6a31a136932bb0e76c94e8818c";
                 weakself.sign = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"login",weakself.timeLocal,user.uid,self.devicesn,token,user.nickname].md5String;
                
                 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                 
                 NSMutableDictionary *param = [NSMutableDictionary dictionary];
                 [param setObject:@"0" forKey:@"type"];
                 [param setObject:@"0" forKey:@"password"];
                 [param setObject:weakself.timeLocal forKey:@"time"];
                 [param setObject:user.uid forKey:@"uid"];
                 [param setObject:weakself.devicesn forKey:@"devicesn"];
                 [param setObject:weakself.sign forKey:@"sign"];
                 [param setObject:user.nickname forKey:@"username"];
                 [param setObject:@"0" forKey:@"gender"];
                 [param setObject:user.icon forKey:@"imgUrl"];
                 [param setObject:@"0" forKey:@"address"];
                 
                 
                 [manager POST:LoginURLstring parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     //跳转到mecontroller
                     //注册成功做的事情
                     id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                     NSLog(@"%@++++++++++",json);
                     NSLog(@"%@............",responseObject);
                     UserUIDModel *uidmodel = [UserUIDModel objectWithKeyValues:json];
                     [UserData sharkedUser].token = [NSString stringWithFormat:@"%@%@%@%@",uidmodel.uid,user.nickname,weakself.devicesn,uidmodel.time].md5String;
                     [UserData sharkedUser].uid = uidmodel.uid;
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_UID" object:nil userInfo:nil];
                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"失败---%@",error);
                     [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
                 }];
             }else
             {
                 NSLog(@"%@",error);
             }
         }];
        
        
    }else if(loginMode == XCDCheckinModelWeixin){
        
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"icon = %@",user.icon);
                 NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                 NSTimeInterval a=[dat timeIntervalSince1970];
                 long long int data = (long long int)a;
                 weakself.timeLocal = [NSString stringWithFormat:@"%lld", data];
                 
                 NSString *token = @"72a4be6a31a136932bb0e76c94e8818c";
                 self.sign = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"login",weakself.timeLocal,user.uid,weakself.devicesn,token,user.nickname].md5String;
                 
                 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                 
                 NSMutableDictionary *param = [NSMutableDictionary dictionary];
                 [param setObject:@"0" forKey:@"type"];
                 [param setObject:@"0" forKey:@"password"];
                 [param setObject:weakself.timeLocal forKey:@"time"];
                 [param setObject:user.uid forKey:@"uid"];
                 [param setObject:weakself.devicesn forKey:@"devicesn"];
                 [param setObject:weakself.sign forKey:@"sign"];
                 [param setObject:user.nickname forKey:@"username"];
                 [param setObject:@"0" forKey:@"gender"];
                 [param setObject:user.icon forKey:@"imgUrl"];
                 [param setObject:@"0" forKey:@"address"];
                 
                 
                 [manager POST:LoginURLstring parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                     UserUIDModel *uidmodel = [UserUIDModel objectWithKeyValues:json];
                     [UserData sharkedUser].uid = uidmodel.uid;
                     
                     [UserData sharkedUser].token = [NSString stringWithFormat:@"%@%@%@%@",uidmodel.uid,user.nickname,weakself.devicesn,uidmodel.time].md5String;
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_UID" object:nil userInfo:nil];
                     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"失败");
                     [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
                 }];

             }
             else
             {
                 NSLog(@"%@",error);
             }
             
         }];

    }
}

#pragma mark --------忘记密码---------
-(void)clickForgotPassWord{
    ForgotPasswordController *forgot = [ForgotPasswordController new];
    forgot.title = @"忘记密码";
    [self.navigationController pushViewController:forgot animated:YES];
}

@end
