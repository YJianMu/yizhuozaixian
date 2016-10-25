//
//  OrderTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "payOrderViewController.h"
#import "RecruitmentController.h"
#import "ProgressController.h"



@interface OrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong) NSString *order_sn;
@property (weak, nonatomic) IBOutlet UIButton *wuliuBtn;
@end

@implementation OrderTableViewCell

#pragma mark --------退款－－－－－－－－－－
- (void)setPaidmodel:(paidmodel *)paidmodel{
    _paidmodel = paidmodel;
    if ([paidmodel.order_status isEqualToString:@"4"]) {
        self.stateLabel.text = @"退款中";
    }else if ([paidmodel.order_status isEqualToString:@"5"]){
        self.stateLabel.text = @"退款完成";
    }
    self.titleLabel.text = paidmodel.brand_name;
    self.timeLabel.text = paidmodel.add_time;
    self.numberLabel.text = [NSString stringWithFormat:@"共有%@件商品",paidmodel.num];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,paidmodel.goods_small_img]] placeholderImage:[UIImage imageNamed:@"order_img.png"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",paidmodel.total_prices];
    if ([paidmodel.order_status isEqualToString:@"4"]) {
        self.btn.hidden = NO;
        self.wuliuBtn.hidden = YES;
        [self.btn setTitle:@"查看进度" forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([paidmodel.order_status isEqualToString:@"5"]){
        self.btn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }
    self.order_sn = paidmodel.order_sn;
}

- (void)click:(UIButton *)sender{
    ProgressController *vc = [ProgressController new];
    vc.title = @"退款进度";
    vc.order_sn = self.order_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --------待付款  未支付  去支付－－－－－－－－－－
- (void)setModel:(NoPayModel *)model{
    _model = model;
    self.titleLabel.text = model.brand_name;
    self.timeLabel.text = model.add_time;
    self.order_sn = model.order_sn;
    self.wuliuBtn.hidden = YES;
    [self.btn setTitle:@"去付款" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_small_img]] placeholderImage:[UIImage imageNamed:@"order_img.png"]];
    self.numberLabel.text = [NSString stringWithFormat:@"共有%@件商品",model.num];
    //self.stateLabel.text = ordersModel.order_status;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.total_prices];
}


-(void)btnClick:(UIButton *)button{
    
    payOrderViewController * getOrderVC = [[payOrderViewController alloc]init];
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[UserData sharkedUser].uid forKey:@"user_id"];
    [mdic setObject:_order_sn forKey:@"order_sns"];
    getOrderVC.orderDic = mdic;
    [self.navigationController pushViewController:getOrderVC animated:YES];
}




#pragma mark --------我的订单  未支付  去支付－－－－－－－－－－
- (void)setOrdersModel:(OrderListModel *)ordersModel{
    
    _ordersModel = ordersModel;
    
    self.titleLabel.text = ordersModel.brand_name;
    self.timeLabel.text = ordersModel.add_time;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,ordersModel.goods_small_img]] placeholderImage:[UIImage imageNamed:@"order_img.png"]];
    self.numberLabel.text = [NSString stringWithFormat:@"共有%@件商品",ordersModel.num];
    //self.stateLabel.text = ordersModel.order_status;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",ordersModel.total_prices];
    
    if ([ordersModel.order_status isEqualToString:@"0"])
    {
        self.stateLabel.text = @"未支付";
        [self.btn setTitle:@"去付款" forState:UIControlStateNormal];
        self.wuliuBtn.hidden = YES;
    }else if ([ordersModel.order_status isEqualToString:@"1"])
    {
        self.stateLabel.text = @"已支付";
        [self.btn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.wuliuBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.wuliuBtn.hidden = YES;
        //self.btn.hidden = YES;
    }else if ([ordersModel.order_status isEqualToString:@"2"])
    {
        self.stateLabel.text = @"交易关闭";
        self.btn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else if ([ordersModel.order_status isEqualToString:@"3"])
    {
        self.stateLabel.text = @"交易完成";
        self.btn.hidden = YES;
        self.wuliuBtn.hidden = YES;
    }else
    {
        if ([ordersModel.order_status isEqualToString:@"4"]){
        self.stateLabel.text = @"退款中";
        self.btn.hidden = NO;
            self.wuliuBtn.hidden = YES;
            [self.btn setTitle:@"查看进度" forState:UIControlStateNormal];
            [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([ordersModel.order_status isEqualToString:@"5"]){
            self.stateLabel.text = @"退款完成";
            self.btn.hidden = YES;
            self.wuliuBtn.hidden = YES;
        }
    }
    self.order_sn = ordersModel.order_sn;
    [self.wuliuBtn addTarget:self action:@selector(clickwuliuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickBtn:(UIButton *)sender{
    //跳到支付宝界面
    if ([self.ordersModel.order_status isEqualToString:@"0"])
    {
        payOrderViewController * getOrderVC = [[payOrderViewController alloc]init];
        NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
        [mdic setObject:[UserData sharkedUser].uid forKey:@"user_id"];
        [mdic setObject:_order_sn forKey:@"order_sns"];
        getOrderVC.orderDic = mdic;
        
        [self.navigationController pushViewController:getOrderVC animated:YES];
        
    }else if ([self.ordersModel.order_status isEqualToString:@"1"])
    {
        
        [self clicksure:self.ordersModel.order_sn];
        

    }
    
}






#pragma mark --------待收货   已支付－－－－－－－－－－
- (void)setNogoodsmodel:(NoGoodsModel *)nogoodsmodel{
    _nogoodsmodel = nogoodsmodel;
    self.titleLabel.text = nogoodsmodel.brand_name;
    self.timeLabel.text = nogoodsmodel.add_time;
    self.order_sn = nogoodsmodel.order_sn;
    self.stateLabel.text = @"已支付";
    self.wuliuBtn.hidden = YES;
    //self.btn.hidden = YES;
    [self.btn setTitle:@"确认收货" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(querenBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[self.wuliuBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //[self.wuliuBtn addTarget:self action:@selector(clickwuliuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,nogoodsmodel.goods_small_img]] placeholderImage:[UIImage imageNamed:@"order_img.png"]];
    self.numberLabel.text = [NSString stringWithFormat:@"共有%@件商品",nogoodsmodel.num];
    //self.stateLabel.text = ordersModel.order_status;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",nogoodsmodel.total_prices];
    
}

- (void)querenBtn:(UIButton *)sender{
    [self clicksure:self.nogoodsmodel.order_sn];
}

#pragma mark --------已支付  查看物流－－－－－－－－－－
- (void)clickwuliuBtn:(UIButton *)sender{
#warning TODO   查看物流
    
//    WXCheckLogisticsController *wx = [WXCheckLogisticsController new];
    RecruitmentController *rec = [RecruitmentController new];
    rec.title = @"查看物流";
    [self.navigationController pushViewController:rec animated:YES];
    
}


- (void)clicksure:(NSString *)order_sn{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"order_sn"] = self.order_sn;
    param[@"uid"] = [UserData sharkedUser].uid;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"receipt%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_order_sn].md5String;
    
    
    
    [manager POST:sureorderURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
//        if ([json[@"info"] isEqualToString:@"r002"]) {
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//               
//            }];
//            
//            UIAlertAction *phone = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//               [[NSNotificationCenter defaultCenter] postNotificationName:@"sureorder" object:nil userInfo:nil];
//            }];
//            [alertC addAction:cancleAction];
//            [alertC addAction:phone];
//            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//            
//            [window addSubview:alertC];
//            
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"确认货失败,请重试"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sureorder" object:nil userInfo:nil];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
   
}








- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
