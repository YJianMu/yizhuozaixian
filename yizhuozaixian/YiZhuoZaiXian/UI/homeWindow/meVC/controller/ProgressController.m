//
//  ProgressController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ProgressController.h"
#import "UIView+Frame.h"
#import "ProgressModel.h"

@interface ProgressController () <UIGestureRecognizerDelegate>
@property (nonatomic ,copy)NSString *refund_cause;
@property (nonatomic ,copy)NSString *progress;
@end

@implementation ProgressController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
   
    [self loadNewData];
    
    [self setUI];
}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self loadNewData];
//}

- (void)setUI{
    UITextView *reasonview = [[UITextView alloc]initWithFrame:CGRectMake(20, 20+20, ScreenWidth - 40, 0.2*ScreenHeight)];
    //_suggestionTextField.delegate = self;
    reasonview.font = [UIFont systemFontOfSize:14.0];
    reasonview.layer.borderColor = UIColor.lightGrayColor.CGColor;
    reasonview.layer.borderWidth = 1;
    reasonview.layer.cornerRadius = 6;
    reasonview.layer.masksToBounds = YES;
    reasonview.editable = NO;
    reasonview.tag = 200;
    
    UITextView *progressview = [[UITextView alloc] initWithFrame:CGRectMake(20, 20+10+10+0.2*ScreenHeight +10+10+10, ScreenWidth - 40, 0.2*ScreenHeight)];
    progressview.font = [UIFont systemFontOfSize:14.0];
    progressview.layer.borderColor = UIColor.lightGrayColor.CGColor;
    progressview.layer.borderWidth = 1;
    progressview.layer.cornerRadius = 6;
    progressview.layer.masksToBounds = YES;
    progressview.editable = NO;
    progressview.tag = 100;
    
    UILabel *first = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 20) andBackgroundColor:[UIColor whiteColor] andText:@"退款理由" andTextFont:13 andTextAlignment:NSTextAlignmentLeft];
    
    UILabel *second = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 20+10+10+0.2*ScreenHeight +10, ScreenWidth - 40, 20) andBackgroundColor:nil andText:@"退款进度" andTextFont:13 andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:first];
    [self.view addSubview:progressview];
    [self.view addSubview:reasonview];
    [self.view addSubview:second];
}


- (UIView *)setUpLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    return line;
}

- (void)loadNewData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
    [param setObject:self.order_sn forKey:@"order_sn"];
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"refInfo%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_order_sn].md5String;
    
    
    
    
    
    
    NSLog(@"%@",self.order_sn);
    __weak ProgressController *weakself = self;
    [manager POST:refundorderinfoURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        ProgressModel *model = [ProgressModel objectWithKeyValues:json[@"refundData"]];
        UITextView *view = [weakself.view viewWithTag:100];
        if (model.progress.length == 0) {
            view.text = @"暂无";
        }else{
        view.text = model.progress;
        }
        UITextView *view1 = [weakself.view viewWithTag:200];
        if (model.refund_cause.length == 0) {
            view1.text = @"暂无";
        }else{
        view1.text = model.refund_cause;
        }
        [hud hideAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"%@",error);
    }];
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
