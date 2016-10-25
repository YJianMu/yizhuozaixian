//
//  RefundViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//  申请退款

#import "RefundViewController.h"
#import "RefundView.h"

@interface RefundViewController ()<UIGestureRecognizerDelegate,refoundViewDelegate>
@property (nonatomic,strong) RefundView *refundView;
@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refundView = [RefundView creatRefundView:self.order_sn];
    self.refundView.delegate = self;
    self.view = self.refundView;
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


//#warning TODO 提交申请
- (void)goback:(NSString *)order_sn and:(NSString *)reason{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [UserData sharkedUser].uid;
    param[@"order_sn"] = order_sn;
    param[@"refund_cause"] = reason;
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"refund%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_order_sn,reason].md5String;
    
    
    
    NSLog(@"%@",param);
    
    [manager POST:refundUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refundroder" object:nil userInfo:nil];
        [hud hideAnimated:YES];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
    }];
}
- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
