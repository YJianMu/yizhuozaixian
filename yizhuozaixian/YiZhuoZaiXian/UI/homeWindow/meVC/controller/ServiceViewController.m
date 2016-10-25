//
//  ServiceViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ServiceViewController.h"
//#import "meViewController.h"

@interface ServiceViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ServiceViewController *weakself = self;
    self.view.backgroundColor = [UIColor whiteColor];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否联系客服" message:@"客服电话：020-3873248" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
//    [alert show];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服电话:\n020-84386606" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //[weakself dismissViewControllerAnimated:YES completion:nil];
        //[weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",@"//020-84386606"];
        
        UIWebView *callWebView = [[UIWebView alloc]init];
        
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
        [weakself.view addSubview:callWebView];
        
        //[weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:phone];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
    
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
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
        //拨号
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://02084386606"]];
//        
//       NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"02084386606"];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
        
//        NSString *str = [NSString stringWithFormat:@"tel:%@",@"//02084386606"];
//        
//        UIWebView *callWebView = [[UIWebView alloc]init];
//        
//        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        
//        [self.view addSubview:callWebView];//也可以不加到页面上
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
