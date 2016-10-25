//
//  TransactionClosedOrderDetailsViewController.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "TransactionClosedOrderDetailsViewController.h"
/** cell */
#import "ConsigneeMessageCell.h"
#import "DeliveryModeCell.h"
#import "CommodityInformationCell.h"
#import "CommodityTotalPriceCell.h"

#import "MerchantInformationHeaderView.h"

#import "OrderStatusCell.h"
#import "DetailOrderFooterView.h"

#import "gooodsDetailsVC.h"



@interface TransactionClosedOrderDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,MerchantInformationHeaderViewDelegate,UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *scoreArray;
@property (nonatomic ,strong)BFTest *detailModel;

@end



@implementation TransactionClosedOrderDetailsViewController
- (NSMutableArray *)scoreArray {
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
    }
    return _scoreArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNewData];
    [self setNavigtion];
    [self setUpUI];
}
-(void)setNavigtion{
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
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
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
-(void)leftItemBttClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ******** 设置UI ********
- (void)setUpUI{
    self.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - ******** <UITableViewDataSource,UITableViewDelegate> ********

- (void)loadNewData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //[param setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@""];
    //[param setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"devicesn"];
    [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
    [param setObject:self.order_sn forKey:@"order_sn"];
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"orderDet%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,_order_sn].md5String;
    
    
    [manager POST:DetailOrderData parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@----",json);
        
        
        BFTest *model = [BFTest objectWithKeyValues:json[@"orderDetails"]];
        NSArray *array = [GoodsList objectArrayWithKeyValuesArray:model.orderGoods];
        [self.scoreArray removeAllObjects];
        [self.scoreArray addObjectsFromArray:array];
        self.detailModel = model;
        [self.tableView reloadData];
        //GoodsList *list = self.scoreArray[0];
        NSLog(@"%@",json);
        [hud hideAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.scoreArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ConsigneeMessageCell *cell = [ConsigneeMessageCell cellWithTableView:tableView];
        cell.model = self.detailModel;
        return cell;
    }else if (indexPath.section == 1){
        OrderStatusCell *cell = [OrderStatusCell cellWithTableView:tableView];
        cell.model = self.detailModel;
        cell.add_time = self.add_time;
        return cell;
    }else if (indexPath.section == 2){
        DeliveryModeCell *cell = [DeliveryModeCell cellWithTableView:tableView];
        cell.model = self.detailModel;
        return cell;
    }else if (indexPath.section == 3){
        CommodityInformationCell *cell = [CommodityInformationCell cellWithTableView:tableView];
        GoodsList *list = self.scoreArray[indexPath.row];
        cell.model = list;
        return cell;
    }else{
        CommodityTotalPriceCell *cell = [CommodityTotalPriceCell cellWithTableView:tableView];
        cell.model = self.detailModel;
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        MerchantInformationHeaderView *headerView = [MerchantInformationHeaderView headerView];
        headerView.delegate = self;
        headerView.model = self.detailModel;
        return headerView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        DetailOrderFooterView *footer = [DetailOrderFooterView footerView];
        footer.model = self.detailModel;
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 80;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 15;
    }else if(section == 3){
        return 48;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 102;
    }else if (indexPath.section == 3){
        return 90;
    }else if(indexPath.section == 2){
        return 70;
    }
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        GoodsList *model = self.scoreArray[indexPath.row];
        
        gooodsDetailsVC * goodsVC = [[gooodsDetailsVC alloc]init];
        
        //    goodsVC.fileName = model.fileName;
        goodsVC.goodsSizeURLstring = [NSString stringWithFormat:@"%@%@",goodsDetailsURLstring,model.goods_id];
        goodsVC.goodsID = model.goods_id;
        goodsVC.goodImage = model.goods_small_img;
        goodsVC.goodsName = model.goods_name;
        goodsVC.shoppingCarInto = YES;
        NSLog(@"%@",model);
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:goodsVC];
        nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#FF0000"];
        [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nvc animated:YES completion:nil];
        
    }
}


#pragma mark - ******** 给商家打电话 ********
- (void)phoneToMerchant{
    __weak TransactionClosedOrderDetailsViewController *weakself = self;
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@",@"客服电话:",self.detailModel.brand_tel];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",self.detailModel.brand_tel];
        
        UIWebView *callWebView = [[UIWebView alloc]init];
        
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
        [weakself.view addSubview:callWebView];
        
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:phone];
    
    [self presentViewController:alertC animated:YES completion:nil];

}



@end
