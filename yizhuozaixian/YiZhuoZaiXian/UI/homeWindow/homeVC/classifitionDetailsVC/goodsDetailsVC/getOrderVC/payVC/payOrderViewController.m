//
//  payOrderViewController.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/7.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "payOrderViewController.h"

#import "PayHelper.h"
#import "Order.h"
#import "WxProduct.h"

#import "payRequsestHandler.h"
#import "WXApi.h"
#import "DataSigner.h"
#import "PartnerConfig.h"
#import <AlipaySDK/AlipaySDK.h>


@interface payOrderViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeTPLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeAddressLabel;


- (IBAction)aliPayButton:(UIButton *)sender;
- (IBAction)wxPayButton:(UIButton *)sender;

@property(nonatomic,strong)NSDictionary * addressDic;

@end

@implementation payOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    
    [self setNavigetion];
    
//    [self setOrderView];
    
    
}
-(void)setNavigetion{
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"在线支付";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (_shoppingCarInfo) {
    
    
        //创建右划返回手势
        UISwipeGestureRecognizer * fanhuiSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(fanhuiSwipe:)];
        [self.view addGestureRecognizer:fanhuiSwipe];
        fanhuiSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        
    }else{
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
    
    
    
}
-(void)fanhuiSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftItemBttClick];
    
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(void)setData{
    
    _addressDic = [NSDictionary dictionary];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary * mmDic = [NSMutableDictionary dictionary];
    [mmDic setObject:_orderDic[@"order_sns"] forKey:@"order_sn"];
    [mmDic setObject:_orderDic[@"user_id"] forKey:@"uid"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    mmDic[@"time"] = time;
    mmDic[@"sign"] = [NSString stringWithFormat:@"orderPay%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_orderDic[@"order_sns"]].md5String;
    
    
    __weak payOrderViewController * weakSelf = self;
    [manager POST:setAddressURLstring parameters:mmDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"下载地址信息完成：%@",[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]);
        weakSelf.addressDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil][@"orderPayInfo"];
        [weakSelf setAddressView];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"下载地址信息出错 error = %@",error);
        
    }];
    



}
-(void)setAddressView{
    _PriceLabel.text = [NSString stringWithFormat:@"￥%@",_addressDic[@"total_prices"]];
    _consigneeNameLabel.text = _addressDic[@"consignee"];
    _consigneeTPLabel.text = _addressDic[@"mobile"];
    _consigneeAddressLabel.text = _addressDic[@"address"];
}

-(void)leftItemBttClick{
    
    NSLog(@"%@",self.navigationController.viewControllers);
    
    if (_shoppingCarInfo) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
//        UIViewController * viewctl = self.navigationController.viewControllers[1];
//        [self.navigationController popToViewController:viewctl animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}


- (IBAction)wxPayButton:(UIButton *)sender {
/*
//    //生成微信订单模型
//    WxProduct * wxProduct = [WxProduct new];
//    wxProduct.orderId = [NSString stringWithFormat:@"%ld",arc4random()*2335234523%10000000+10000000];
//    wxProduct.subject = @"文时特精品男装";
//    wxProduct.body = @"效率！效率！高效率！！！";
//    wxProduct.price = @"1";
//    
//    [PayHelper sendWechatPay:wxProduct];
    
//    //生成支付宝订单模型
//    Order * aliProduct = [Order new];
//    aliProduct.tradeNO = [NSString stringWithFormat:@"%lld",arc4random()*2335234523%10000000+10000000];
//    aliProduct.productName = @"文时特精品男装";
//    aliProduct.amount = @"0.01";
//
//    [PayHelper sendAlipay:aliProduct];
 */
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary * mmDic = [NSMutableDictionary dictionary];
    [mmDic setObject:_addressDic[@"order_sn"] forKey:@"order_sn"];
    [mmDic setObject:[UserData sharkedUser].uid forKey:@"uid"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    mmDic[@"time"] = time;
    mmDic[@"sign"] = [NSString stringWithFormat:@"WXPay%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_addressDic[@"order_sn"]].md5String;
    
    
    [manager POST:wxPayURLstring parameters:mmDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if ( [dict[@"info"] isEqualToString:@"w001"]) {
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = @"1327821301";
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            
            
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",@"wxcb16acafc732ad32",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
            [self performSelector:@selector(yanchiPopView) withObject:nil afterDelay:0.3];

            
        }else{
                NSLog(@"服务器返回错误，未获取到json对象");
            
            
        }
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"微信支付后台获取出错 error = %@",error);
        
    }];

    
    
    
}

- (IBAction)aliPayButton:(UIButton *)sender {
    //生成支付宝订单模型
//    Order * aliProduct = [Order new];
//    aliProduct.tradeNO = [NSString stringWithFormat:@"%lld",arc4random()*2335234523%10000000+10000000];
//    aliProduct.productName = @"文时特精品男装";
//    aliProduct.amount = @"0.01";
//    
//    [PayHelper sendAlipay:aliProduct];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary * mmDic = [NSMutableDictionary dictionary];
    [mmDic setObject:_addressDic[@"order_sn"] forKey:@"order_sn"];
    [mmDic setObject:[UserData sharkedUser].uid forKey:@"uid"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    mmDic[@"time"] = time;
    mmDic[@"sign"] = [NSString stringWithFormat:@"alipay%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_addressDic[@"order_sn"]].md5String;
    
    

    
//    __weak payOrderViewController * weakSelf = self;
    [manager POST:aliPayURLstring parameters:mmDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",dic);
        [[AlipaySDK defaultService] payOrder:dic[@"requestData"] fromScheme:@"YiZhuoZaiXianAppScheme" callback:^(NSDictionary *resultDic) {
            
            NSLog(@"reslut = %@",resultDic);
            [self.navigationController popViewControllerAnimated:YES];

        }];
        
        [self performSelector:@selector(yanchiPopView) withObject:nil afterDelay:0.3];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"根据订单号请求支付宝商品拼接字符串出错 error = %@",error);
        
    }];


}

-(void)yanchiPopView{
    
    
    if (_shoppingCarInfo) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"payRefresh" object:nil userInfo:nil];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }

}

@end
